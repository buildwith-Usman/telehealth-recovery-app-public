import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/presentation/widgets/cards/item_horizontal_content_card.dart';
import '../../app/config/app_colors.dart';
import '../../app/services/base_stateful_page.dart';
import '../widgets/app_text.dart';
import '../widgets/button/custom_navigation_button.dart';
import '../widgets/cards/item_recent_patient_consultation_history.dart';
import 'recent_patient_consultation_history_controller.dart';

class RecentPatientConsultationHistoryPage
    extends BaseStatefulPage<RecentPatientConsultationHistoryController> {
  const RecentPatientConsultationHistoryPage({super.key});

  @override
  BaseStatefulPageState<RecentPatientConsultationHistoryController>
      createState() => _RecentPatientConsultationHistoryPageState();
}

class _RecentPatientConsultationHistoryPageState
    extends BaseStatefulPageState<RecentPatientConsultationHistoryController> {
  @override
  Widget buildPageContent(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteLight,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: _buildHeader(),
            ),
            // Expanded list
            Expanded(
              child: _ConsultationHistoryList(
                items: widget.controller.historyItems,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CustomNavigationButton(
          type: NavigationButtonType.previous,
          onPressed: () => {Get.back()},
          isFilled: true,
          filledColor: AppColors.whiteLight,
          iconColor: AppColors.accent,
          backgroundColor: AppColors.white,
        ),
        Expanded(
          child: Center(
            child: AppText.primary(
              'Consultation History',
              fontFamily: FontFamilyType.poppins,
              fontSize: 20,
              fontWeight: FontWeightType.semiBold,
              color: AppColors.black,
            ),
          ),
        ),
        const SizedBox(width: 40),
      ],
    );
  }
}

/// List with expand/collapse behavior
class _ConsultationHistoryList extends StatefulWidget {
  // Accept the reactive list directly so this widget can react locally
  // to changes and keep the expansion state isolated.
  final RxList<ItemHorizontalContentCardData> items;

  const _ConsultationHistoryList({required this.items});

  @override
  State<_ConsultationHistoryList> createState() =>
      _ConsultationHistoryListState();
}

class _ConsultationHistoryListState extends State<_ConsultationHistoryList> {
  int _expandedIndex = 0; // first item expanded by default

  @override
  Widget build(BuildContext context) {
    // Keep Obx local to the widget that actually changes (the list contents).
    return Obx(() {
      final items = widget.items;
      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        physics: const BouncingScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ItemRecentPatientConsultationHistory(
            item: item,
            margin: const EdgeInsets.symmetric(vertical: 8),
            isExpanded: index == _expandedIndex,
            onHeaderTap: () {
              setState(() {
                if (_expandedIndex == index) {
                  _expandedIndex = -1; // collapse current
                } else {
                  _expandedIndex = index; // expand new item
                }
              });
            },
          );
        },
      );
    });
  }
}
