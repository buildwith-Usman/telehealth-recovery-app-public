import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../app/config/app_colors.dart';
import '../../app/config/app_enum.dart';
import '../../app/services/base_stateful_page.dart';
import '../../app/utils/sizes.dart';
import '../widgets/app_text.dart';
import 'video_call_controller.dart';

class VideoCallPage extends BaseStatefulPage<VideoCallController> {
  const VideoCallPage({super.key});

  @override
  BaseStatefulPageState<VideoCallController> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends BaseStatefulPageState<VideoCallController> {
  @override
  void initState() {
    super.initState();
    // Set full screen and hide system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    // Restore system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget buildPageContent(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() => Stack(
        children: [
          // Main video view
          _buildMainVideoView(),
          
          // Self video view (Picture in Picture)
          _buildSelfVideoView(),
          
          // Call status and info
          _buildCallStatusBar(),
          
          // Call controls
          if (widget.controller.showControls) _buildCallControls(),
          
          // Connection status overlay
          if (widget.controller.callStatus == CallStatus.connecting)
            _buildConnectingOverlay(),
        ],
      )),
    );
  }

  Widget _buildMainVideoView() {
    return GestureDetector(
      onTap: widget.controller.toggleControls,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.3),
              Colors.black.withOpacity(0.1),
              Colors.black.withOpacity(0.3),
            ],
          ),
        ),
        child: widget.controller.isVideoEnabled
            ? _buildVideoStream()
            : _buildVideoDisabledView(),
      ),
    );
  }

  Widget _buildVideoStream() {
    // Show remote video if available, otherwise show local video
    return Stack(
      children: [
        // Remote video (main view)
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: widget.controller.agoraService.remoteUid > 0
              ? widget.controller.agoraService.getRemoteVideoWidget()
              : _buildWaitingForParticipant(),
        ),
        
        // Gradient overlay for better UI readability
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.transparent,
                Colors.black.withOpacity(0.3),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildWaitingForParticipant() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.grey80,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
                image: widget.controller.participantImageUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(widget.controller.participantImageUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: widget.controller.participantImageUrl.isEmpty
                  ? const Icon(
                      Icons.person,
                      color: AppColors.white,
                      size: 60,
                    )
                  : null,
            ),
            gapH16,
            AppText.primary(
              widget.controller.participantName,
              fontSize: 24,
              fontWeight: FontWeightType.semiBold,
              color: AppColors.white,
            ),
            gapH8,
            AppText.primary(
              'Waiting for ${widget.controller.participantName} to join...',
              fontSize: 16,
              color: AppColors.white.withOpacity(0.7),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoDisabledView() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.grey80,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
                image: widget.controller.participantImageUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(widget.controller.participantImageUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: widget.controller.participantImageUrl.isEmpty
                  ? const Icon(
                      Icons.person,
                      color: AppColors.white,
                      size: 60,
                    )
                  : null,
            ),
            gapH16,
            AppText.primary(
              widget.controller.participantName,
              fontSize: 24,
              fontWeight: FontWeightType.semiBold,
              color: AppColors.white,
            ),
            gapH8,
            AppText.primary(
              'Video is turned off',
              fontSize: 16,
              color: AppColors.white.withOpacity(0.7),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelfVideoView() {
    return Positioned(
      top: 60,
      right: 20,
      child: GestureDetector(
        onTap: widget.controller.showParticipantInfo,
        child: Container(
          width: 120,
          height: 160,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.white.withOpacity(0.3), width: 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Obx(() => widget.controller.isVideoEnabled
                ? widget.controller.agoraService.getLocalVideoWidget()
                : Container(
                    color: AppColors.grey80,
                    child: const Center(
                      child: Icon(
                        Icons.videocam_off,
                        color: AppColors.white,
                        size: 30,
                      ),
                    ),
                  )),
          ),
        ),
      ),
    );
  }

  Widget _buildCallStatusBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Participant info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.primary(
                      widget.controller.participantName,
                      fontSize: 18,
                      fontWeight: FontWeightType.semiBold,
                      color: AppColors.white,
                    ),
                    gapH4,
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.controller.callStatus == CallStatus.connected
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ),
                        gapW8,
                        AppText.primary(
                          widget.controller.callStatus == CallStatus.connected
                              ? widget.controller.callDuration
                              : 'Connecting...',
                          fontSize: 14,
                          color: AppColors.white.withOpacity(0.8),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Recording indicator and minimize button
              Row(
                children: [
                  if (widget.controller.isRecording) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.white,
                            ),
                          ),
                          gapW4,
                          AppText.primary(
                            'REC',
                            fontSize: 12,
                            fontWeight: FontWeightType.bold,
                            color: AppColors.white,
                          ),
                        ],
                      ),
                    ),
                    gapW12,
                  ],
                  
                  // Minimize button
                  GestureDetector(
                    onTap: widget.controller.minimizeCall,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.minimize,
                        color: AppColors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCallControls() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(top: 24, bottom: 60, left: 30, right: 30),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.8),
              ],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Mic mute/unmute button (left)
              _buildControlButton(
                icon: widget.controller.isMuted ? Icons.mic_off : Icons.mic,
                isActive: !widget.controller.isMuted,
                onTap: widget.controller.toggleMute,
                backgroundColor: AppColors.white,
              ),
              // End call button (center)
              _buildControlButton(
                icon: Icons.call_end,
                isActive: false,
                backgroundColor: Colors.red,
                onTap: widget.controller.endCall,
              ),
              // Camera switch button (right)
              _buildControlButton(
                icon: widget.controller.isVideoEnabled ? Icons.videocam : Icons.videocam_off,
                isActive: false,
                onTap: widget.controller.toggleVideo,
                backgroundColor: AppColors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
    Color? backgroundColor,
  }) {
    final bgColor = backgroundColor ?? (isActive ? AppColors.primary : Colors.black.withOpacity(0.5));
    
    // Use white icon for dark backgrounds (red, black, primary) and black icon for light backgrounds (white)
    final iconColor = backgroundColor == Colors.red || 
                     backgroundColor == null || 
                     backgroundColor == AppColors.primary ||
                     backgroundColor == Colors.black
        ? AppColors.white
        : AppColors.black;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildConnectingOverlay() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: AppColors.primary,
            ),
            gapH24,
            AppText.primary(
              'Connecting to ${widget.controller.participantName}...',
              fontSize: 18,
              fontWeight: FontWeightType.medium,
              color: AppColors.white,
              textAlign: TextAlign.center,
            ),
            gapH8,
            AppText.primary(
              'Please wait while we establish the connection',
              fontSize: 14,
              color: AppColors.white.withOpacity(0.7),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}