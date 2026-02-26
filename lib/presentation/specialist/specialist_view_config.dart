import 'package:flutter/material.dart';
import 'package:recovery_consultation_app/presentation/earning_history/earning_history_page.dart';
import 'package:recovery_consultation_app/presentation/session_history/session_history_page.dart';
import 'package:recovery_consultation_app/presentation/specialist_about/specialist_about_page.dart';
import 'package:recovery_consultation_app/presentation/specialist_reviews/specialist_review_page.dart';
import 'package:recovery_consultation_app/presentation/withdrawal_history/withdrawal_history_page.dart';

/// Configuration object for specialist view
/// Follows Strategy Pattern and Open/Closed Principle
/// New view modes can be added without modifying existing code
class SpecialistViewConfig {
  final String title;
  final String buttonText;
  final List<String> tabs;
  final List<Widget> tabWidgets;
  final bool showBottomButton;
  final SpecialistViewMode mode;

  const SpecialistViewConfig({
    required this.title,
    required this.buttonText,
    required this.tabs,
    required this.tabWidgets,
    required this.showBottomButton,
    required this.mode,
  });

  /// Patient viewing specialist profile (from specialist list)
  factory SpecialistViewConfig.patientView() {
    return const SpecialistViewConfig(
      title: 'Specialist Details',
      buttonText: 'Book Consultation',
      tabs: ['About', 'Reviews'],
      tabWidgets: [
        SpecialistAboutPage(),
        SpecialistReviewPage(),
      ],
      showBottomButton: true,
      mode: SpecialistViewMode.patientView,
    );
  }

  /// Specialist viewing their own profile
  factory SpecialistViewConfig.specialistSelfView() {
    return const SpecialistViewConfig(
      title: 'My Profile',
      buttonText: 'Edit Profile',
      tabs: ['About', 'Reviews', 'Sessions', 'Earnings', 'Withdrawal'],
      tabWidgets: [
        SpecialistAboutPage(),
        SpecialistReviewPage(),
        SessionHistoryPage(),
        EarningHistoryPage(),
        WithdrawalHistoryPage(),
      ],
      showBottomButton: true,
      mode: SpecialistViewMode.specialistSelf,
    );
  }

  /// Admin viewing specialist profile
  factory SpecialistViewConfig.adminView() {
    return const SpecialistViewConfig(
      title: 'Specialist Profile',
      buttonText: 'Edit Profile',
      tabs: ['About', 'Reviews', 'Sessions', 'Earnings', 'Withdrawal'],
      tabWidgets: [
        SpecialistAboutPage(),
        SpecialistReviewPage(),
        SessionHistoryPage(),
        EarningHistoryPage(),
        WithdrawalHistoryPage(),
      ],
      showBottomButton: true,
      mode: SpecialistViewMode.admin,
    );
  }
}

/// Enum defining different view modes
enum SpecialistViewMode {
  patientView,    // Patient viewing a specialist
  specialistSelf, // Specialist viewing their own profile
  admin,          // Admin viewing a specialist profile
}
