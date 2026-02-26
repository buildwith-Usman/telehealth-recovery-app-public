import 'package:recovery_consultation_app/app/services/base_stateful_page.dart';
import 'package:recovery_consultation_app/app/utils/image_url_utils.dart';
import 'package:recovery_consultation_app/domain/models/session_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/presentation/admin/admin_home_controller.dart';
import 'package:recovery_consultation_app/presentation/widgets/cards/list_profile_card.dart';
import 'package:recovery_consultation_app/presentation/widgets/common/section_header.dart';
import '../../app/config/app_colors.dart';
import '../../app/config/app_enum.dart';
import '../../app/config/app_icon.dart';
import '../../app/config/app_routes.dart';
import '../../app/utils/sizes.dart';
import '../widgets/app_text.dart';
import '../widgets/button/custom_navigation_button.dart';
import '../widgets/textfield/search_textfield.dart';
import '../widgets/banner/admin_sliding_banner.dart';
import 'widgets/admin_metric_card.dart';
import 'widgets/recent_activity_feed.dart';

class AdminHomePage extends BaseStatefulPage<AdminHomeController> {
  const AdminHomePage({super.key});

  @override
  BaseStatefulPageState<AdminHomeController> createState() =>
      _AdminHomePageState();
}

class _AdminHomePageState extends BaseStatefulPageState<AdminHomeController> {
  @override
  Widget buildPageContent(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteLight,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: widget.controller.refreshData,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header and Search with padding
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildAdminHeader(),
                      gapH20,
                      _buildSearchField(),
                      gapH20,
                      SectionHeader(
                        title: 'Upcoming Sessions',
                        titleFontSize: 20,
                        titleFontWeight: FontWeightType.semiBold,
                        titleColor: AppColors.primary,
                        onSeeAll: () =>
                            widget.controller.navigateToAdminSessionPage(),
                      )
                    ],
                  ),
                ),
                 gapH6,
                // Session Banner - Upcoming Sessions from API
                Obx(() {
                  final appointments = widget.controller.upcomingAppointments;
                  final upcomingSessions = _convertAppointmentsToSessions(appointments, AdminSessionType.upcoming);
                  return _buildSessionBanner(200, upcomingSessions);
                }),
                gapH12,
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SectionHeader(
                    title: 'Ongoing Sessions',
                    titleFontSize: 20,
                    titleFontWeight: FontWeightType.semiBold,
                    titleColor: AppColors.primary,
                    onSeeAll: () => widget.controller.navigateToAdminSessionPage(),
                  ),
                ),
                gapH6,
                // Ongoing Sessions from API
                Obx(() {
                  final appointments = widget.controller.ongoingAppointments;
                  final ongoingSessions = _convertAppointmentsToSessions(appointments, AdminSessionType.ongoing);
                  return _buildSessionBanner(220, ongoingSessions);
                }),
                // Dashboard Metrics
                gapH10,
                // Top Therapist Section Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SectionHeader(
                    title: 'Patients',
                    titleFontSize: 18,
                    titleFontWeight: FontWeightType.semiBold,
                    titleColor: AppColors.primary,
                    onSeeAll: () => widget.controller.navigateToAdminPatientsList(),
                  ),
                ),
                gapH10,
                // Horizontal Patient List
                _buildPatientList(),
                gapH10,
                // Top Specialist Section Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SectionHeader(
                    title: 'Specialists',
                    titleFontSize: 18,
                    titleFontWeight: FontWeightType.semiBold,
                    titleColor: AppColors.primary,
                    onSeeAll: () => widget.controller.navigateToAdminSpecialistList(),
                  ),
                ),
                gapH16,
                // Horizontal Specialist List
                _buildTopSpecialistList(),
                gapH20,
                // Dashboard Metrics
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildDashboardMetrics(),
                ),
                gapH20,
                // Recent Activity Feed
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildRecentActivityFeed(),
                ),
                gapH20,
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Convert AppointmentEntity list to AdminSessionData list
  List<AdminSessionData> _convertAppointmentsToSessions(
      List<dynamic> appointments, AdminSessionType sessionType) {
    if (appointments.isEmpty) {
      return [];
    }

    return appointments.map((appointment) {
      // Parse date and start time to create DateTime
      final dateTime = _parseAppointmentDateTime(appointment.date, appointment.startTime);
      
      // Calculate duration
      final duration = _calculateDuration(appointment.startTimeInSeconds, appointment.endTimeInSeconds);

      return AdminSessionData(
        id: appointment.id?.toString() ?? 'unknown',
        patientName: appointment.patient?.name ?? 'Unknown Patient',
        patientImageUrl: appointment.patient?.imageUrl ?? '',
        specialistName: appointment.doctor?.name ?? 'Unknown Specialist',
        specialistSpecialty: appointment.doctor?.doctorInfo?.specialization ?? 'Specialist',
        specialistImageUrl: appointment.doctor?.imageUrl ?? '',
        dateTime: dateTime,
        duration: duration,
        status: appointment.status ?? 'Scheduled',
        consultationFee: double.tryParse(appointment.price?.toString() ?? '0') ?? 0.0,
        sessionType: sessionType,
      );
    }).toList();
  }

  /// Parse appointment date and start time to create DateTime
  DateTime _parseAppointmentDateTime(String? date, String? startTime) {
    try {
      if (date == null || startTime == null) return DateTime.now();
      // Expected format: "2024-12-25" for date, "14:30" for time
      final dateTime = DateTime.parse('$date ${startTime}00');
      return dateTime;
    } catch (e) {
      return DateTime.now();
    }
  }

  /// Calculate duration from start and end time in seconds
  String _calculateDuration(int? startSeconds, int? endSeconds) {
    try {
      if (startSeconds == null || endSeconds == null) return '60 min';
      final durationInSeconds = endSeconds - startSeconds;
      final minutes = (durationInSeconds / 60).toInt();
      return '$minutes min';
    } catch (e) {
      return '60 min';
    }
  }

  Widget _buildSessionBanner(
      double? height, List<AdminSessionData> sessions) {
    if (sessions.isEmpty) {
      return SizedBox(
        height: height,
        child: Center(
          child: AppText.primary(
            'No sessions available',
            fontFamily: FontFamilyType.inter,
            fontSize: 14,
            fontWeight: FontWeightType.regular,
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return AdminSlidingBanner(
      sessions: sessions,
      height: height,
      autoScrollDuration: const Duration(seconds: 5),
      onSessionTap: (session) {
        // Handle session tap, e.g., navigate to session details
        print('Tapped on session with ID: ${session.id}');
        widget.controller.navigateToSessionDetails(session);
      },
    );
  }

  Widget _buildAdminHeader() {
    return Row(
      children: [
        // Profile Avatar and Greeting
        Expanded(
          child: Row(
            children: [
              // Admin Profile Avatar
              GestureDetector(
                onTap: () {
                  widget.controller.navigateToViewProfile();
                },
                child: Obx(() {
                  final user = widget.controller.user;
                  final imageUrl = user?.imageUrl != null
                      ? ImageUrlUtils().getFullImageUrl(user!.imageUrl)
                      : '';

                  return Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withValues(alpha: 0.1),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.admin_panel_settings,
                                  color: AppColors.accent,
                                  size: 24,
                                );
                              },
                            )
                          : const Icon(
                              Icons.admin_panel_settings,
                              color: AppColors.accent,
                              size: 24,
                            ),
                    ),
                  );
                }),
              ),
              gapW12,
              // Greeting Text
              Expanded(
                child: Obx(() {
                  final user = widget.controller.user;
                  final adminName = user?.name ?? 'Admin';

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.primary(
                        'Hi, $adminName',
                        fontFamily: FontFamilyType.poppins,
                        fontSize: 18,
                        fontWeight: FontWeightType.semiBold,
                        color: AppColors.black,
                      ),
                      gapH2,
                      AppText.primary(
                        'System Overview Dashboard',
                        fontFamily: FontFamilyType.inter,
                        fontSize: 14,
                        fontWeight: FontWeightType.regular,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
        gapW16,
        // Right Action Buttons
        Row(
          children: [
            // System Health Indicator
            CustomNavigationButton.withAppIcon(
              onPressed: widget.controller.navigateToSpecialistApproval,
              appIcon: AppIcon.approvalIcon,
              isFilled: true,
              filledColor: AppColors.white,
              size: 40,
              iconColor: AppColors.accent,
              iconSize: 22,
              showBorder: false,
            ),
            gapW8,
            // Notification Button
            CustomNavigationButton.withAppIcon(
              onPressed: () {
                // Handle admin notifications
              },
              appIcon: AppIcon.notification,
              isFilled: true,
              filledColor: AppColors.white,
              iconColor: AppColors.black,
              size: 40,
              iconSize: 22,
              showBorder: false,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return SearchTextField(
      hintText: 'Search users, specialists, reports...',
      height: 50,
      borderRadius: 8,
      backgroundColor: AppColors.white,
      prefixIcon: Padding(
        padding: const EdgeInsets.all(12.0),
        child: AppIcon.searchIcon.widget(
          width: 24,
          height: 24,
        ),
      ),
      onChanged: (value) {
        // Handle search input
        print('Admin search query: $value');
      },
      onFieldSubmitted: (value) {
        // Handle search submission
        print('Admin search submitted: $value');
      },
    );
  }

  Widget _buildDashboardMetrics() {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.primary(
              'Dashboard Overview',
              fontFamily: FontFamilyType.poppins,
              fontSize: 20,
              fontWeight: FontWeightType.semiBold,
              color: AppColors.black,
            ),
            gapH16,
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1,
              children: [
                AdminMetricCard(
                  title: 'Total Users',
                  value: widget.controller.totalUsers.value.toString(),
                  subtitle: 'Patients & Specialists',
                  icon: Icons.people,
                  iconColor: AppColors.primary,
                  showTrend: true,
                  trend: '+12%',
                  onTap: widget.controller.viewAllUsers,
                ),
                AdminMetricCard(
                  title: 'Active Sessions',
                  value: widget.controller.activeSessions.value.toString(),
                  subtitle: 'Currently ongoing',
                  icon: Icons.psychology,
                  iconColor: AppColors.checkedColor,
                  showTrend: true,
                  trend: '+8%',
                ),
                AdminMetricCard(
                  title: 'Pending Approvals',
                  value: widget.controller.pendingApprovals.value.toString(),
                  subtitle: 'Specialist applications',
                  icon: Icons.pending_actions,
                  iconColor: Colors.orange,
                  showTrend: false,
                  onTap: widget.controller.viewAllSpecialists,
                ),
                AdminMetricCard(
                  title: 'Monthly Revenue',
                  value:
                      '\$${(widget.controller.monthlyRevenue.value / 1000).toStringAsFixed(1)}K',
                  subtitle: 'Current month',
                  icon: Icons.monetization_on,
                  iconColor: AppColors.accent,
                  showTrend: true,
                  trend: '+15%',
                  onTap: widget.controller.viewReports,
                ),
                AdminMetricCard(
                  title: 'Session Management',
                  value: '${widget.controller.activeSessions.value}',
                  subtitle: 'Manage all sessions',
                  icon: Icons.video_call,
                  iconColor: Colors.purple,
                  showTrend: false,
                  onTap: () => Get.toNamed(AppRoutes.adminSessions),
                ),
              ],
            ),
          ],
        ));
  }

Widget _buildPatientList() {
  return Obx(() {
    final patients = widget.controller.patientList;

    if (patients.isEmpty) {
      return SizedBox(
        height: 190,
        child: Center(
          child: AppText.primary(
            'No patients found',
            fontFamily: FontFamilyType.inter,
            fontSize: 14,
            fontWeight: FontWeightType.regular,
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return SizedBox(
      height: 190,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: patients.length,
        itemBuilder: (context, index) {
          final item = patients[index];
          return SizedBox(
            width: 180, // adjust width based on your design
            child: ListProfileCard(
              item: item,
              margin: EdgeInsets.zero,
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 12),
      ),
    );
  });
}

Widget _buildTopSpecialistList() {
  return Obx(() {
    final specialists = widget.controller.topSpecialists;

    if (specialists.isEmpty) {
      return SizedBox(
        height: 220,
        child: Center(
          child: AppText.primary(
            'No specialists found',
            fontFamily: FontFamilyType.inter,
            fontSize: 14,
            fontWeight: FontWeightType.regular,
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: specialists.length,
        itemBuilder: (context, index) {
          final item = specialists[index];
          return SizedBox(
            width: 180, // adjust width based on your design
            child: ListProfileCard(
              item: item,
              margin: EdgeInsets.zero,
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 12),
      ),
    );
  });
}

  Widget _buildRecentActivityFeed() {
    const recentActivities = [
      ActivityItem(
        title: 'New Specialist Application',
        subtitle: 'Dr. Sarah Johnson applied as Specialist',
        timestamp: '2 min ago',
        icon: Icons.person_add,
        iconColor: AppColors.primary,
        isUrgent: true,
      ),
      ActivityItem(
        title: 'Patient Registration',
        subtitle: 'John Doe registered as new patient',
        timestamp: '15 min ago',
        icon: Icons.person,
        iconColor: AppColors.checkedColor,
      ),
      ActivityItem(
        title: 'Session Completed',
        subtitle: 'Therapy session between Dr. Smith & Patient',
        timestamp: '1 hour ago',
        icon: Icons.check_circle,
        iconColor: AppColors.checkedColor,
      ),
      ActivityItem(
        title: 'Payment Processed',
        subtitle: 'Payment of \$120 received',
        timestamp: '2 hours ago',
        icon: Icons.payment,
        iconColor: AppColors.accent,
      ),
      ActivityItem(
        title: 'Support Ticket',
        subtitle: 'Patient reported technical issue',
        timestamp: '3 hours ago',
        icon: Icons.support,
        iconColor: Colors.orange,
        isUrgent: true,
      ),
    ];

    return const RecentActivityFeed(activities: recentActivities);
  }
}
