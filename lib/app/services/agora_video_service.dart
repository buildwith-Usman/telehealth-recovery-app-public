import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class AgoraVideoService extends GetxService {
  static AgoraVideoService get instance => Get.find<AgoraVideoService>();
  
  // Agora configuration - You should get these from your Agora console
  static const String appId = 'c37ff66bc3114487b42f01a0b8c40055'; // Replace with your actual App ID
  
  RtcEngine? _engine;
  RtcEngine? get engine => _engine;
  
  // Observable states
  final RxBool _isJoined = false.obs;
  final RxBool _isLocalVideoEnabled = true.obs;
  final RxBool _isLocalAudioEnabled = true.obs;
  final RxBool _isSpeakerEnabled = true.obs;
  final RxBool _isCameraFront = true.obs;
  final RxInt _remoteUid = 0.obs;
  final RxBool _isRemoteVideoEnabled = false.obs;
  
  // Getters
  bool get isJoined => _isJoined.value;
  bool get isLocalVideoEnabled => _isLocalVideoEnabled.value;
  bool get isLocalAudioEnabled => _isLocalAudioEnabled.value;
  bool get isSpeakerEnabled => _isSpeakerEnabled.value;
  bool get isCameraFront => _isCameraFront.value;
  int get remoteUid => _remoteUid.value;
  bool get isRemoteVideoEnabled => _isRemoteVideoEnabled.value;
  
  // Stream controllers for events
  final StreamController<String> _eventController = StreamController<String>.broadcast();
  Stream<String> get eventStream => _eventController.stream;
  
  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeEngine();
  }
  
  @override
  void onClose() {
    _eventController.close();
    _leaveChannel();
    _engine?.release();
    super.onClose();
  }
  
  /// Initialize Agora RTC Engine
  Future<void> _initializeEngine() async {
    try {
      // Create the engine
      _engine = createAgoraRtcEngine();
      
      // Initialize the engine
      await _engine!.initialize(const RtcEngineContext(
        appId: appId,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ));
      
      // Set up event handlers
      _engine!.registerEventHandler(RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          print('Successfully joined channel: ${connection.channelId}');
          _isJoined.value = true;
          _eventController.add('joined');
        },
        onUserJoined: (RtcConnection connection, int uid, int elapsed) {
          print('Remote user joined: $uid');
          _remoteUid.value = uid;
          _eventController.add('user_joined');
        },
        onUserOffline: (RtcConnection connection, int uid, UserOfflineReasonType reason) {
          print('Remote user left: $uid');
          _remoteUid.value = 0;
          _isRemoteVideoEnabled.value = false;
          _eventController.add('user_left');
        },
        onRemoteVideoStateChanged: (RtcConnection connection, int uid, RemoteVideoState state, RemoteVideoStateReason reason, int elapsed) {
          print('Remote video state changed: $uid, state: $state');
          if (uid == _remoteUid.value) {
            _isRemoteVideoEnabled.value = state == RemoteVideoState.remoteVideoStateStarting || 
                                          state == RemoteVideoState.remoteVideoStateDecoding;
            _eventController.add('remote_video_changed');
          }
        },
        onError: (ErrorCodeType err, String msg) {
          print('Agora Error: $err, $msg');
          _eventController.add('error:$msg');
        },
        onLeaveChannel: (RtcConnection connection, RtcStats stats) {
          print('Left channel');
          _isJoined.value = false;
          _remoteUid.value = 0;
          _isRemoteVideoEnabled.value = false;
          _eventController.add('left');
        },
      ));
      
      // Enable video
      await _engine!.enableVideo();
      await _engine!.enableAudio();
      
      print('Agora engine initialized successfully');
    } catch (e) {
      print('Failed to initialize Agora engine: $e');
      _eventController.add('error:Failed to initialize engine');
    }
  }
  
  /// Request necessary permissions
  Future<bool> requestPermissions() async {
    try {
      final Map<Permission, PermissionStatus> permissions = await [
        Permission.camera,
        Permission.microphone,
      ].request();
      
      bool allGranted = permissions.values.every(
        (status) => status == PermissionStatus.granted,
      );
      
      if (!allGranted) {
        print('Permissions not granted');
        _eventController.add('error:Permissions not granted');
      }
      
      return allGranted;
    } catch (e) {
      print('Error requesting permissions: $e');
      _eventController.add('error:Permission request failed');
      return false;
    }
  }
  
  /// Join a video call channel
  Future<bool> joinChannel({
    required String channelName,
    required String token,
    required int uid,
  }) async {
    try {
      if (_engine == null) {
        print('Engine not initialized');
        return false;
      }
      
      // Request permissions first
      final hasPermissions = await requestPermissions();
      if (!hasPermissions) {
        return false;
      }
      
      // Configure video settings
      await _engine!.setVideoEncoderConfiguration(
        const VideoEncoderConfiguration(
          dimensions: VideoDimensions(width: 640, height: 480),
          frameRate: 15,
          bitrate: 0, // Let Agora handle bitrate automatically
          orientationMode: OrientationMode.orientationModeAdaptive,
        ),
      );
      
      // Enable local video explicitly (ensures camera is ready)
      await _engine!.enableLocalVideo(true);
      _isLocalVideoEnabled.value = true;
      
      // Start local preview before joining channel (for local video widget to work)
      await _engine!.startPreview();
      
      // Add a small delay on first load to ensure camera is fully initialized
      // This fixes the issue where preview doesn't show on first load
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Join channel
      await _engine!.joinChannel(
        token: token,
        channelId: channelName,
        uid: uid,
        options: const ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          channelProfile: ChannelProfileType.channelProfileCommunication,
        ),
      );
      
      // Trigger a state update to ensure widget rebuilds after preview starts
      _isLocalVideoEnabled.value = true;
      
      print('Joining channel: $channelName');
      return true;
    } catch (e) {
      print('Failed to join channel: $e');
      _eventController.add('error:Failed to join channel');
      return false;
    }
  }
  
  /// Leave the current channel
  Future<void> leaveChannel() async {
    await _leaveChannel();
  }
  
  Future<void> _leaveChannel() async {
    try {
      await _engine?.stopPreview();
      await _engine?.leaveChannel();
      print('Left channel');
    } catch (e) {
      print('Error leaving channel: $e');
    }
  }
  
  /// Toggle local video on/off
  Future<void> toggleLocalVideo() async {
    try {
      _isLocalVideoEnabled.value = !_isLocalVideoEnabled.value;
      await _engine?.enableLocalVideo(_isLocalVideoEnabled.value);
      _eventController.add('local_video_toggled');
    } catch (e) {
      print('Error toggling video: $e');
    }
  }
  
  /// Toggle local audio on/off
  Future<void> toggleLocalAudio() async {
    try {
      _isLocalAudioEnabled.value = !_isLocalAudioEnabled.value;
      await _engine?.enableLocalAudio(_isLocalAudioEnabled.value);
      _eventController.add('local_audio_toggled');
    } catch (e) {
      print('Error toggling audio: $e');
    }
  }
  
  /// Switch between front and rear camera
  Future<void> switchCamera() async {
    try {
      await _engine?.switchCamera();
      _isCameraFront.value = !_isCameraFront.value;
      _eventController.add('camera_switched');
    } catch (e) {
      print('Error switching camera: $e');
    }
  }
  
  /// Toggle speaker on/off
  Future<void> toggleSpeaker() async {
    try {
      _isSpeakerEnabled.value = !_isSpeakerEnabled.value;
      await _engine?.setEnableSpeakerphone(_isSpeakerEnabled.value);
      _eventController.add('speaker_toggled');
    } catch (e) {
      print('Error toggling speaker: $e');
    }
  }
  
  /// Get local video widget
  Widget getLocalVideoWidget() {
    if (_engine == null) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: Icon(
            Icons.videocam_off,
            color: Colors.white,
            size: 40,
          ),
        ),
      );
    }
    
    if (!_isLocalVideoEnabled.value) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: Icon(
            Icons.videocam_off,
            color: Colors.white,
            size: 40,
          ),
        ),
      );
    }
    
    // Ensure widget has proper constraints and rebuilds properly
    // Using key to force rebuild on first load when preview starts
    return SizedBox.expand(
      key: ValueKey('local_video_${_isLocalVideoEnabled.value}_${_engine.hashCode}'),
      child: AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: _engine!,
          canvas: const VideoCanvas(uid: 0),
        ),
      ),
    );
  }
  
  /// Get remote video widget
  Widget getRemoteVideoWidget() {
    if (_engine == null || _remoteUid.value == 0 || !_isRemoteVideoEnabled.value) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: Icon(
            Icons.person,
            color: Colors.white,
            size: 60,
          ),
        ),
      );
    }
    
    return AgoraVideoView(
      controller: VideoViewController.remote(
        rtcEngine: _engine!,
        canvas: VideoCanvas(uid: _remoteUid.value),
        connection: const RtcConnection(channelId: ''),
      ),
    );
  }
  
  /// Generate a simple token for testing (use server-side token generation in production)
  static String generateTestToken(String channelName, int uid) {
    // This is a simple placeholder - in production, you should generate tokens server-side
    // For testing, you can use Agora's token generator or set your project to testing mode
    return '';
  }
}