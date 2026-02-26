import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../../app/controllers/base_controller.dart';
import '../../app/services/role_manager.dart';
import '../../app/services/agora_video_service.dart';
import '../../app/config/app_routes.dart';
import '../../app/config/app_constant.dart';
import '../../di/client_module.dart';
import '../../domain/entity/appointment_entity.dart';
import '../../domain/usecase/update_appointment_use_case.dart';
import '../../app/config/app_enum.dart';

class VideoCallController extends BaseController with ClientModule {
  final UpdateAppointmentUseCase updateAppointmentUseCase;

  VideoCallController({required this.updateAppointmentUseCase});

  // Agora service instance
  late AgoraVideoService _agoraService;
  AgoraVideoService get agoraService => _agoraService;
  
  // Stream subscription for Agora events
  StreamSubscription<String>? _agoraEventSubscription;
  
  // Reactive variables
  final RxBool _isCallActive = true.obs;
  final Rx<CallStatus> _callStatus = CallStatus.connecting.obs;
  final RxString _callDuration = '00:00'.obs;
  final RxBool _isRecording = false.obs;
  final RxBool _showControls = true.obs;

  // Call participant info
  final RxString _participantName = ''.obs;
  final RxString _participantImageUrl = ''.obs;
  final RxString _appointmentId = ''.obs;
  final RxString _participantRole = ''.obs;
  final RxString _channelName = ''.obs;
  
  // Store appointment entity for future use (e.g., prescriptions, notes, rating)
  AppointmentEntity? get appointment => _appointment;
  AppointmentEntity? _appointment;

  // Getters that delegate to Agora service
  bool get isMuted => !_agoraService.isLocalAudioEnabled;
  bool get isVideoEnabled => _agoraService.isLocalVideoEnabled;
  bool get isSpeakerOn => _agoraService.isSpeakerEnabled;
  bool get isCallActive => _isCallActive.value;
  CallStatus get callStatus => _callStatus.value;
  String get callDuration => _callDuration.value;
  bool get isRecording => _isRecording.value;
  bool get showControls => _showControls.value;
  String get participantName => _participantName.value;
  String get participantImageUrl => _participantImageUrl.value;
  String get appointmentId => _appointmentId.value;
  String get participantRole => _participantRole.value;
  String get channelName => _channelName.value;

  // Get role manager instance
  RoleManager get roleManager => RoleManager.instance;

  @override
  void onInit() {
    super.onInit();
    _initializeCall();
    _startCallTimer();
  }

  void _initializeCall() async {
    try {
      // Initialize Agora service
      _agoraService = AgoraVideoService.instance;
      
      // Get appointment entity from arguments
      final arguments = Get.arguments;
      if (arguments is! AppointmentEntity) {
        logger.error('Invalid arguments: AppointmentEntity is required');
        _callStatus.value = CallStatus.disconnected;
        Get.snackbar(
          'Error',
          'Invalid appointment data. Please try again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final appointment = arguments;
      _appointment = appointment;

      // Validate required appointment data
      if (appointment.id == null) {
        logger.error('Appointment ID is null');
        _callStatus.value = CallStatus.disconnected;
        Get.snackbar(
          'Error',
          'Invalid appointment. Please try again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Extract participant info based on current user's role
      _extractParticipantInfo(appointment);
      
      // Extract Agora call parameters from appointment
      _appointmentId.value = appointment.id!.toString();
      _channelName.value = appointment.getAgoraChannelName();
      final token = appointment.getAgoraToken();
      final uid = appointment.getAgoraUid();

      // Listen to Agora events
      _agoraEventSubscription = _agoraService.eventStream.listen((event) {
        _handleAgoraEvent(event);
      });

      // Join the video call channel
      final success = await _agoraService.joinChannel(
        channelName: _channelName.value,
        token: token,
        uid: uid,
      );

      if (success) {
        _callStatus.value = CallStatus.connected;
      } else {
        _callStatus.value = CallStatus.disconnected;
        Get.snackbar(
          'Connection Failed',
          'Unable to join the video call. Please check your internet connection.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      logger.error('Error initializing call: $e');
      _callStatus.value = CallStatus.disconnected;
      Get.snackbar(
        'Error',
        'Failed to initialize video call. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Extract participant information based on current user's role
  void _extractParticipantInfo(AppointmentEntity appointment) {
    final doctor = appointment.doctor;
    final patient = appointment.patient;
    
    if (roleManager.isPatient) {
      // Patient is calling the doctor
      _participantName.value = doctor?.name ?? 'Doctor';
      _participantImageUrl.value = doctor?.imageUrl ?? '';
      _participantRole.value = 'specialist';
    } else if (roleManager.isSpecialist) {
      // Specialist is calling the patient
      _participantName.value = patient?.name ?? 'Patient';
      _participantImageUrl.value = patient?.imageUrl ?? '';
      _participantRole.value = 'patient';
    } else {
      // Fallback for admin or unknown roles
      _participantName.value = doctor?.name ?? patient?.name ?? 'Participant';
      _participantImageUrl.value = doctor?.imageUrl ?? patient?.imageUrl ?? '';
      _participantRole.value = 'participant';
    }
  }

  void _handleAgoraEvent(String event) {
    if (kDebugMode) {
      print('Agora event: $event');
    }
    
    switch (event) {
      case 'joined':
        _callStatus.value = CallStatus.connected;
        break;
      case 'user_joined':
        // Remote user joined
        Get.snackbar(
          'User Joined',
          '$participantName has joined the call',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
        );
        break;
      case 'user_left':
        // Remote user left
        Get.snackbar(
          'User Left',
          '$participantName has left the call',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
        );
        break;
      case 'left':
        _callStatus.value = CallStatus.ended;
        break;
      default:
        if (event.startsWith('error:')) {
          final errorMessage = event.substring(6);
          Get.snackbar(
            'Call Error',
            errorMessage,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
        break;
    }
  }

  void _startCallTimer() {
    // Start call duration timer
    int seconds = 0;
    ever(_isCallActive, (isActive) {
      if (isActive) {
        Stream.periodic(const Duration(seconds: 1), (i) => i).listen((count) {
          if (_isCallActive.value) {
            seconds++;
            final minutes = seconds ~/ 60;
            final remainingSeconds = seconds % 60;
            _callDuration.value = 
                '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
          }
        });
      }
    });
  }

  void toggleMute() async {
    await _agoraService.toggleLocalAudio();
    if (kDebugMode) {
      print('Microphone ${isMuted ? 'muted' : 'unmuted'}');
    }
    
    // Show feedback to user
    Get.snackbar(
      'Microphone',
      isMuted ? 'Microphone muted' : 'Microphone unmuted',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 1),
    );
  }

  void toggleVideo() async {
    await _agoraService.toggleLocalVideo();
    if (kDebugMode) {
      print('Video ${isVideoEnabled ? 'enabled' : 'disabled'}');
    }
    
    Get.snackbar(
      'Camera',
      isVideoEnabled ? 'Camera turned on' : 'Camera turned off',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 1),
    );
  }

  void toggleSpeaker() async {
    await _agoraService.toggleSpeaker();
    if (kDebugMode) {
      print('Speaker ${isSpeakerOn ? 'on' : 'off'}');
    }
  }

  void toggleRecording() {
    // Only specialists can record
    if (roleManager.currentRole?.name == 'specialist') {
      _isRecording.value = !_isRecording.value;
      if (kDebugMode) {
        print('Recording ${_isRecording.value ? 'started' : 'stopped'}');
      }
      
      Get.snackbar(
        _isRecording.value ? 'Recording Started' : 'Recording Stopped',
        _isRecording.value 
            ? 'This session is now being recorded' 
            : 'Recording has been saved',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    } else {
      Get.snackbar(
        'Access Denied',
        'Only specialists can record sessions',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void toggleControls() {
    _showControls.value = !_showControls.value;
  }

  void switchCamera() async {
    await _agoraService.switchCamera();
    if (kDebugMode) {
      print('Switching camera');
    }
    Get.snackbar(
      'Camera Switched',
      'Camera view has been switched',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 1),
    );
  }


  void endCall() {
    // Show confirmation dialog - DO NOT change state here
    Get.dialog(
      AlertDialog(
        title: const Text('End Call'),
        content: const Text('Are you sure you want to end this call?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _confirmAndEndCall();
            },
            child: const Text('End Call'),
          ),
        ],
      ),
      barrierDismissible: false, // Prevent accidental dismissal
    );
  }

  /// Confirm and end the call - only called after user confirms in dialog
  void _confirmAndEndCall() async {
    try {
      // Show loading indicator
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
      );

      if (kDebugMode) {
        print('Call ended - confirmed by user');
      }

      // Update call state only after confirmation
      _isCallActive.value = false;
      _callStatus.value = CallStatus.ended;

      // Leave the Agora channel
      await _agoraService.leaveChannel();

      // Close loading indicator
      Get.back();

      // Check user role and perform appropriate action
      final currentRole = roleManager.currentRole?.name;

      if (currentRole == 'patient' && participantName.isNotEmpty) {
        // For patients: navigate to home, then show rating on destination screen
        await _navigatePatientAfterCall();
      } else if ((currentRole == 'specialist' || currentRole == 'doctor') &&
          participantName.isNotEmpty) {
        // For specialists: navigate to home, then show notes on destination screen
        await _navigateSpecialistAfterCall();
      } else {
        // For other cases, navigate directly back
        Get.offAllNamed(AppRoutes.navScreen);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error ending call: $e');
      }
      // Close any open dialogs
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      // Show error and navigate back
      Get.snackbar(
        'Error',
        'Failed to end call properly. Returning to home.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      Get.offAllNamed(AppRoutes.navScreen);
    }
  }

  /// Navigate patient away from call screen first, then show rating on destination
  Future<void> _navigatePatientAfterCall() async {
    try {
      // Prepare post-call data for the destination screen
      final postCallData = {
        Arguments.showRating: true,
        Arguments.doctorName: participantName,
        Arguments.doctorImageUrl: participantImageUrl.isNotEmpty ? participantImageUrl : null,
        Arguments.appointmentId: int.tryParse(appointmentId) ?? 0,
        Arguments.receiverId: _appointment?.docUserId ?? 0, // Doctor ID for API call
      };

      // Navigate away from video call screen
      Get.offAllNamed(AppRoutes.navScreen, arguments: postCallData);

      if (kDebugMode) {
        print('Patient navigated to home screen with post-call data');
        print('  receiverId (doctorId): ${postCallData['receiverId']}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in patient navigation: $e');
      }
      // Fallback: just navigate back
      Get.offAllNamed(AppRoutes.navScreen);
    }
  }

  /// Navigate specialist away from call screen first, then show notes on destination
  Future<void> _navigateSpecialistAfterCall() async {
    try {
      // Update appointment status to "completed" before navigating
      final appointmentIdInt = int.tryParse(appointmentId);
      if (appointmentIdInt != null) {
        final params = UpdateAppointmentParams(
          appointmentId: appointmentIdInt,
          status: 'completed',
        );

        final result = await executeApiCall<AppointmentEntity?>(
          () => updateAppointmentUseCase.execute(params),
          onSuccess: () => logger.method('✅ Appointment status updated to completed'),
          onError: (e) => logger.method('⚠️ Failed to update appointment status: $e'),
        );

        if (kDebugMode) {
          print('Appointment ${appointmentIdInt} updated to completed: ${result != null}');
        }
      } else {
        logger.warning('Invalid appointment ID, skipping status update');
      }

      // Prepare post-call data for the destination screen
      final postCallData = {
        Arguments.showNotes: true,
        Arguments.patientName: participantName,
        Arguments.patientImageUrl: participantImageUrl.isNotEmpty ? participantImageUrl : null,
        Arguments.appointmentId: appointmentId,
      };

      // Navigate away from video call screen
      Get.offAllNamed(AppRoutes.navScreen, arguments: postCallData);

      if (kDebugMode) {
        print('Specialist navigated to home screen with post-call data');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in specialist navigation: $e');
      }
      // Fallback: just navigate back
      Get.offAllNamed(AppRoutes.navScreen);
    }
  }



  /// Handle navigation after rating is submitted
  // DEPRECATED: Now handled on the destination screen
  // Kept for reference only

  /// Save consultation notes after video call
  // DEPRECATED: Now handled on the destination screen
  // Kept for reference only

  void minimizeCall() {
    if (kDebugMode) {
      print('Minimizing call');
    }
    // Implement minimize functionality - go back but keep call active
    Get.back();
  }

  void sendMessage() {
    // Open chat during call
    if (kDebugMode) {
      print('Opening chat');
    }
    Get.snackbar(
      'Chat',
      'Chat feature will be available soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void shareScreen() {
    // Screen sharing functionality - only for specialists
    if (roleManager.currentRole?.name == 'specialist') {
      if (kDebugMode) {
        print('Starting screen share');
      }
      Get.snackbar(
        'Screen Share',
        'Screen sharing started',
        snackPosition: SnackPosition.TOP,
      );
    } else {
      Get.snackbar(
        'Access Denied',
        'Only specialists can share screen',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void takePicture() {
    // Take screenshot during call (for specialists)
    if (roleManager.currentRole?.name == 'specialist') {
      if (kDebugMode) {
        print('Taking picture');
      }
      Get.snackbar(
        'Picture Saved',
        'Session screenshot has been saved',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  void showParticipantInfo() {
    // Show detailed participant information
    Get.snackbar(
      participantName,
      'Role: ${participantRole.isNotEmpty ? participantRole : 'Patient'}',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void onClose() {
    // Cancel Agora event subscription
    _agoraEventSubscription?.cancel();
    
    if (_isCallActive.value) {
      _agoraService.leaveChannel();
    }
    super.onClose();
  }
}