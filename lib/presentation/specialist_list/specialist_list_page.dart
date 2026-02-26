import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/presentation/navigation/nav_controller.dart';
import 'package:recovery_consultation_app/presentation/widgets/button/primary_button.dart';
import 'package:recovery_consultation_app/presentation/widgets/cards/list_profile_card.dart';
import 'package:recovery_consultation_app/presentation/widgets/common/recovery_grid_view.dart';
import '../../app/config/app_colors.dart';
import '../../app/config/app_enum.dart';
import '../../app/config/app_icon.dart';
import '../../app/services/base_stateful_page.dart';
import '../../app/utils/sizes.dart';
import '../widgets/app_text.dart';
import '../widgets/button/custom_navigation_button.dart';
import 'specialist_list_controller.dart';

class SpecialistListPage extends BaseStatefulPage<SpecialistListController> {
  const SpecialistListPage({super.key});

  @override
  BaseStatefulPageState<SpecialistListController> createState() =>
      _SpecialistListPageState();
}

class _SpecialistListPageState
    extends BaseStatefulPageState<SpecialistListController> {

  @override
  void initState() {
    if (kDebugMode) {
      print('SpecialistListPage: initState called');
      print('SpecialistListPage: About to call super.initState()');
    }
    super.initState();
    if (kDebugMode) {
      print('SpecialistListPage: super.initState() completed');
      print('SpecialistListPage: Controller type = ${widget.controller.runtimeType}');
    }

    // Update arguments every time the page is visited
    // This ensures the correct tab is selected even when the controller is reused
    // Use addPostFrameCallback to avoid calling setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.updateFromArguments();
    });
  }

  @override
  Widget buildPageContent(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteLight,
      body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          _buildHeader(),
                          gapH20,
                          _buildToggleButtons(),
                        ],
                      )
                  ),
                  gapH20,
                  Obx(() => _buildSpecialistList()),
                  gapH30,
                ],
              ),
            ),
          )),
    );
  }

  // @override
  // Widget buildPageContent(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: AppColors.whiteLight,
  //     body: SafeArea(
  //       child:
  //       SingleChildScrollView(
  //         child:  Padding(
  //           padding:
  //           const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.stretch,
  //             children: [
  //               _buildHeader(),
  //               gapH20,
  //               _buildToggleButtons(),
  //               gapH20,
  //               Obx(() => _buildSpecialistList())
  //             ],
  //           ),
  //         ),
  //       ),
  //
  //     ),
  //   );
  // }

  Widget _buildHeader() {
    final NavController navController = Get.find();

    return SizedBox(
      height: 50, // Adjust height as needed
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Back button at left
          Align(
            alignment: Alignment.centerLeft,
            child: CustomNavigationButton(
              type: NavigationButtonType.previous,
              onPressed: () {
                if (navController.currentIndex == 3 ||
                    navController.currentIndex == 2) {
                  navController.changeTab(0);
                } else {
                  Get.back();
                }
              },
              isFilled: true,
              filledColor: AppColors.whiteLight,
              iconColor: AppColors.accent,
              backgroundColor: AppColors.white,
            ),
          ),

          // Center title
          Center(
            child: AppText.primary(
              'Specialists',
              fontFamily: FontFamilyType.poppins,
              fontSize: 20,
              fontWeight: FontWeightType.semiBold,
              color: AppColors.black,
            ),
          ),

          // Optional buttons at right
          if (widget.controller.roleManager.isPatient)
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomNavigationButton.withAppIcon(
                    onPressed: () {
                      widget.controller.navigateToQuestionnaires();
                    },
                    appIcon: AppIcon.questionnaireIcon,
                    isFilled: true,
                    filledColor: AppColors.white,
                    iconColor: AppColors.primary,
                    size: 40,
                    iconSize: 18,
                    showBorder: false,
                  ),
                  gapW12,
                  CustomNavigationButton.withAppIcon(
                    onPressed: () {
                      _showSpecialistFilterBottomSheet();
                    },
                    appIcon: AppIcon.filterIcon,
                    isFilled: true,
                    filledColor: AppColors.white,
                    iconColor: AppColors.primary,
                    size: 40,
                    iconSize: 18,
                    showBorder: false,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }


  Widget _buildToggleButtons() {
    return Obx(() => Container(
          height: 45,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildToggleButton(
                  title: 'Therapists',
                  type: SpecialistType.therapist,
                  isSelected: widget.controller.selectedType ==
                      SpecialistType.therapist,
                ),
              ),
              Expanded(
                child: _buildToggleButton(
                  title: 'Psychiatrists',
                  type: SpecialistType.psychiatrist,
                  isSelected: widget.controller.selectedType ==
                      SpecialistType.psychiatrist,
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildToggleButton({
    required String title,
    required SpecialistType type,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => widget.controller.selectType(type),
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
            fontSize: 12,
            fontWeight: FontWeightType.medium,
            color: isSelected ? AppColors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialistList() {
    if (widget.controller.filteredSpecialists.isEmpty) {
      return _buildEmptyState();
    }

    return _buildGridView();
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          gapH16,
          AppText.primary(
            'No specialists found',
            fontFamily: FontFamilyType.poppins,
            fontSize: 18,
            fontWeight: FontWeightType.medium,
            color: AppColors.textSecondary,
          ),
          gapH8,
          AppText.primary(
            'Try switching between Therapist and Psychiatrist',
            fontFamily: FontFamilyType.inter,
            fontSize: 14,
            fontWeight: FontWeightType.regular,
            color: AppColors.textSecondary.withOpacity(0.7),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Widget _buildGridView() {
  //   return GridView.builder(
  //     shrinkWrap: true,
  //     physics: const NeverScrollableScrollPhysics(),
  //     padding: const EdgeInsets.only(bottom: 20),
  //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //       crossAxisCount: 2,
  //       childAspectRatio: 0.75,
  //       crossAxisSpacing: 12,
  //       mainAxisSpacing: 12,
  //     ),
  //     itemCount: widget.controller.filteredSpecialists.length,
  //     itemBuilder: (context, index) {
  //       final specialist = widget.controller.filteredSpecialists[index];
  //       return ListProfileCard(
  //         item: specialist,
  //         margin: EdgeInsets.zero,
  //       );
  //     },
  //   );
  // }

  Widget _buildGridView() {
    final specialists = widget.controller.filteredSpecialists;

    return RecoveryGridView(
      itemCount: specialists.length,
      itemBuilder: (context, index) {
        return ListProfileCard(
          margin: EdgeInsets.zero,
          item: specialists[index],
        );
      },
      mainAxisExtent: 215,
    );
  }


  Widget _buildLanguageMultiSelect() {
    final languages = const [
      'None',
      'English',
      'Urdu',
      'Siraiki',
      'Punjabi',
      'Pashto',
      'Sindhi'
    ];

    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.primary(
              'Select a Language',
              fontSize: 14,
              fontWeight: FontWeightType.medium,
              color: AppColors.black,
            ),
            gapH8,
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.whiteLight,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.lightGrey,
                  width: 1,
                ),
              ),
              child: Column(
                children: languages.map((language) {
                  final isNone = language == 'None';
                  final isSelected = isNone
                      ? widget.controller.selectedLanguages.isEmpty
                      : widget.controller.selectedLanguages.contains(language);

                  return GestureDetector(
                    onTap: () {
                      if (isNone) {
                        widget.controller.clearLanguages();
                      } else {
                        widget.controller.toggleLanguage(language);
                        // If selecting a language, remove "None" if it was implied
                        // (None is only shown when list is empty)
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: isSelected
                            ? AppColors.primary.withOpacity(0.1)
                            : Colors.transparent,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.whiteLight,
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.lightGrey,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: isSelected
                                ? const Icon(
                                    Icons.check,
                                    size: 14,
                                    color: AppColors.white,
                                  )
                                : null,
                          ),
                          gapW12,
                          Expanded(
                            child: AppText.primary(
                              language,
                              fontSize: 16,
                              fontWeight: FontWeightType.medium,
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            if (widget.controller.selectedLanguages.isNotEmpty) ...[
              gapH8,
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.controller.selectedLanguages.map((lang) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primary,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppText.primary(
                          lang,
                          fontSize: 14,
                          fontWeight: FontWeightType.medium,
                          color: AppColors.primary,
                        ),
                        gapW6,
                        GestureDetector(
                          onTap: () {
                            widget.controller.toggleLanguage(lang);
                          },
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ));
  }

  Widget _buildTimeMultiSelect() {
    final times = const [
      'All',
      'Morning (5 AM – 12 PM)',
      'Afternoon (12 PM – 5 PM)',
      'Evening (5 PM – 9 PM)',
      'Night (9 PM – 5 AM)',
    ];

    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.primary(
              'Preferred Time',
              fontSize: 14,
              fontWeight: FontWeightType.medium,
              color: AppColors.black,
            ),
            gapH8,
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.whiteLight,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.lightGrey,
                  width: 1,
                ),
              ),
              child: Column(
                children: times.map((time) {
                  final isAll = time == 'All';
                  final isSelected = isAll
                      ? widget.controller.selectedTimes.isEmpty
                      : widget.controller.selectedTimes.contains(time);

                  return GestureDetector(
                    onTap: () {
                      if (isAll) {
                        widget.controller.clearTimes();
                      } else {
                        widget.controller.toggleTime(time);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: isSelected
                            ? AppColors.primary.withOpacity(0.1)
                            : Colors.transparent,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.whiteLight,
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.lightGrey,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: isSelected
                                ? const Icon(
                                    Icons.check,
                                    size: 14,
                                    color: AppColors.white,
                                  )
                                : null,
                          ),
                          gapW12,
                          Expanded(
                            child: AppText.primary(
                              time,
                              fontSize: 16,
                              fontWeight: FontWeightType.medium,
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            if (widget.controller.selectedTimes.isNotEmpty) ...[
              gapH8,
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.controller.selectedTimes.map((time) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primary,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppText.primary(
                          time,
                          fontSize: 14,
                          fontWeight: FontWeightType.medium,
                          color: AppColors.primary,
                        ),
                        gapW6,
                        GestureDetector(
                          onTap: () {
                            widget.controller.toggleTime(time);
                          },
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ));
  }

  Widget _buildDayMultiSelect() {
    final days = const [
      'None',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.primary(
              'Select a Day',
              fontSize: 14,
              fontWeight: FontWeightType.medium,
              color: AppColors.black,
            ),
            gapH8,
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.whiteLight,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.lightGrey,
                  width: 1,
                ),
              ),
              child: Column(
                children: days.map((day) {
                  final isNone = day == 'None';
                  final isSelected = isNone
                      ? widget.controller.selectedDays.isEmpty
                      : widget.controller.selectedDays.contains(day);

                  return GestureDetector(
                    onTap: () {
                      if (isNone) {
                        widget.controller.clearDays();
                      } else {
                        widget.controller.toggleDay(day);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: isSelected
                            ? AppColors.primary.withOpacity(0.1)
                            : Colors.transparent,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.whiteLight,
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.lightGrey,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: isSelected
                                ? const Icon(
                                    Icons.check,
                                    size: 14,
                                    color: AppColors.white,
                                  )
                                : null,
                          ),
                          gapW12,
                          Expanded(
                            child: AppText.primary(
                              day,
                              fontSize: 16,
                              fontWeight: FontWeightType.medium,
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            if (widget.controller.selectedDays.isNotEmpty) ...[
              gapH8,
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.controller.selectedDays.map((day) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primary,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppText.primary(
                          day,
                          fontSize: 14,
                          fontWeight: FontWeightType.medium,
                          color: AppColors.primary,
                        ),
                        gapW6,
                        GestureDetector(
                          onTap: () {
                            widget.controller.toggleDay(day);
                          },
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ));
  }

  void _showSpecialistFilterBottomSheet() {
    // Reset filters to defaults when opening the bottom sheet
    widget.controller.resetFiltersToDefaults();
    
    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(Get.context!).size.height * 0.9,
        ),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
              // Scrollable content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title
                      AppText.primary(
                        'Filter',
                        fontSize: 18,
                        fontWeight: FontWeightType.semiBold,
                        color: AppColors.textPrimary,
                        fontFamily: FontFamilyType.poppins,
                      ),
                      gapH20,
                      // Preferred Time multi-select
                      _buildTimeMultiSelect(),
                      gapH20,
                      // Select a Day multi-select
                      _buildDayMultiSelect(),
                      gapH20,
                      // Language multi-select
                      _buildLanguageMultiSelect(),
                      gapH20,
                    ],
                  ),
                ),
              ),
              // Fixed button at bottom
              Padding(
                padding: const EdgeInsets.all(16),
                child: PrimaryButton(
                    title: 'Apply Filter',
                    onPressed: () {
                      Get.back();
                    }),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }
}
