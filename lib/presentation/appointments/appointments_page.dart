import 'package:recovery_consultation_app/app/services/base_stateful_page.dart';
import 'package:recovery_consultation_app/presentation/appointments/appointments_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/presentation/navigation/nav_controller.dart';
import '../../app/config/app_colors.dart';
import '../../app/config/app_enum.dart';
import '../../app/utils/sizes.dart';
import '../widgets/app_text.dart';
import '../widgets/button/custom_navigation_button.dart';
import '../widgets/cards/appointment_card.dart';

class AppointmentsPage extends BaseStatefulPage<AppointmentsController> {
  const AppointmentsPage({super.key});

  @override
  BaseStatefulPageState<AppointmentsController> createState() =>
      _AppointmentsPageState();
}

class _AppointmentsPageState
    extends BaseStatefulPageState<AppointmentsController> {
  @override
  Widget buildPageContent(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteLight,
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              gapH20,
              _buildToggleButtons(),
              gapH20,
              Expanded(
                child: Obx(() => _buildAppointmentsList()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final  NavController navController = Get.find();
    return Row(
      children: [
        CustomNavigationButton(
          type: NavigationButtonType.previous,
          onPressed: () => {
            if (navController.currentIndex == 1 || navController.currentIndex == 2)
              {navController.changeTab(0)}
            else
              Get.back()
          },
          isFilled: true,
          filledColor: AppColors.whiteLight,
          iconColor: AppColors.accent,
          backgroundColor: AppColors.white,
        ),
        Expanded(
          child: Center(
            child: AppText.primary(
              'Appointments',
              fontFamily: FontFamilyType.poppins,
              fontSize: 20,
              fontWeight: FontWeightType.semiBold,
              color: AppColors.black,
            ),
          ),
        ),
        // Empty container to balance the layout
        const SizedBox(width: 40),
      ],
    );
  }

  Widget _buildToggleButtons() {
    return Obx(() => Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildToggleButton(
                  title: 'Upcoming',
                  status: AppointmentStatus.pending,
                  isSelected: widget.controller.selectedStatus ==
                      AppointmentStatus.pending,
                ),
              ),
              Expanded(
                child: _buildToggleButton(
                  title: 'Completed',
                  status: AppointmentStatus.completed,
                  isSelected: widget.controller.selectedStatus ==
                      AppointmentStatus.completed,
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildToggleButton({
    required String title,
    required AppointmentStatus status,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => widget.controller.selectStatus(status),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: AppText.primary(
            title,
            fontFamily: FontFamilyType.poppins,
            fontSize: 14,
            fontWeight: FontWeightType.medium,
            color: isSelected ? AppColors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentsList() {
    if (widget.controller.appointments.isEmpty) {
      return _buildEmptyState();
    }

    return _buildListView();
  }

  Widget _buildEmptyState() {
    final isUpcoming =
        widget.controller.selectedStatus == AppointmentStatus.pending;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isUpcoming ? Icons.calendar_today : Icons.history,
            size: 64,
            color: AppColors.accent,
          ),
          gapH16,
          AppText.primary(
            isUpcoming
                ? 'No upcoming appointments'
                : 'No completed appointments',
            fontFamily: FontFamilyType.poppins,
            fontSize: 18,
            fontWeight: FontWeightType.medium,
            color: AppColors.textSecondary,
          ),
          gapH8,
          AppText.primary(
            isUpcoming
                ? 'Book your first consultation with our specialists'
                : 'Your completed appointments will appear here',
            fontFamily: FontFamilyType.poppins,
            fontSize: 14,
            fontWeight: FontWeightType.regular,
            color: AppColors.textSecondary,
            textAlign: TextAlign.center,
          ),
          if (isUpcoming) ...[
            gapH24,
            ElevatedButton.icon(
              onPressed: () => widget.controller.bookNewAppointment(),
              icon: const Icon(Icons.add, color: AppColors.white),
              label: AppText.primary(
                'Book Appointment',
                fontFamily: FontFamilyType.poppins,
                fontSize: 14,
                fontWeight: FontWeightType.medium,
                color: AppColors.white,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.controller.appointments.length,
      itemBuilder: (context, index) {
        final appointment = widget.controller.appointments[index];
        return AppointmentCard(specialist: appointment);
      },
    );
  }
}
