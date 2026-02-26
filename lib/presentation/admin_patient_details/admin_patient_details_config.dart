import 'package:flutter/material.dart';
import 'package:recovery_consultation_app/presentation/admin_patient_profile_view/admin_patient_profile_view_page.dart';
import 'package:recovery_consultation_app/presentation/payment_history/payment_history_page.dart';
import 'package:recovery_consultation_app/presentation/session_history/session_history_page.dart';

/// Configuration object for admin patient details view
/// Follows Strategy Pattern similar to SpecialistViewConfig
/// Centralizes tab structure and UI configuration
class AdminPatientDetailsConfig {
  final String title;
  final String buttonText;
  final List<String> tabs;
  final List<Widget> tabWidgets;
  final bool showBottomButton;

  const AdminPatientDetailsConfig({
    required this.title,
    required this.buttonText,
    required this.tabs,
    required this.tabWidgets,
    required this.showBottomButton,
  });

  /// Admin viewing patient profile with full details
  factory AdminPatientDetailsConfig.adminView() {
    return const AdminPatientDetailsConfig(
      title: 'Patient Details',
      buttonText: 'Edit Profile',
      tabs: ['About', 'Session History', 'Payments'],
      tabWidgets: [
        AdminPatientProfileViewPage(),
        SessionHistoryPage(),
        PaymentHistoryPage()
      ],
      showBottomButton: true,
    );
  }
}
