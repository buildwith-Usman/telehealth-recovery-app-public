import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/config/app_colors.dart';
import '../../app/config/app_icon.dart';
import '../../app/config/app_enum.dart';
import '../../app/services/base_stateful_page.dart';
import '../../app/utils/sizes.dart';
import '../widgets/app_text.dart';
import '../widgets/button/custom_navigation_button.dart';
import '../widgets/textfield/form_textfield.dart';
import '../widgets/dropdown/custom_dropdown_field.dart';
import '../widgets/button/primary_button.dart';
import '../../generated/locales.g.dart';
import 'specialist_signup_controller.dart';

class SpecialistSignupPage
    extends BaseStatefulPage<SpecialistSignupController> {
  const SpecialistSignupPage({super.key});

  @override
  BaseStatefulPageState<SpecialistSignupController> createState() => _SpecialistSignupPageState();
}

class _SpecialistSignupPageState extends BaseStatefulPageState<SpecialistSignupController> {
  @override
  Widget buildPageContent(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
          child: Column(
            children: [
              _buildHeader(),
              gapH20,
              // _buildProgressIndicator(),
              // gapH24,
              Expanded(
                child: _buildCurrentStep(),
              ),
              gapH20,
              _buildNavigationButtons(),
              // Only show login section, or section, and Google button on step 1
              Obx(() {
                if (widget.controller.currentStep.value == 0) {
                  return Column(
                    children: [
                      gapH8,
                      _buildLoginSection(),
                      gapH16,
                      _buildOrSection(),
                      gapH16,
                      _buildGoogleLoginButton(),
                    ],
                  );
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CustomNavigationButton(
          type: NavigationButtonType.previous,
          onPressed: () {
            if (widget.controller.currentStep.value == 0) {
              // If on first step, go back to previous screen
              Get.back();
            } else {
              // Otherwise go to previous step
              widget.controller.goToPreviousStep();
            }
          },
          isFilled: true,
          filledColor: AppColors.whiteLight,
          iconColor: AppColors.accent,
        ),
      ],
    );
  }

  // Widget _buildSignupImageSection() {
  //   return Center(
  //     child: SizedBox(
  //       height: 180,
  //       child: AppImage.loginSignUpImg.widget(
  //         fit: BoxFit.contain,
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildProgressIndicator() {
  //   return Obx(() {
  //     int currentStep = widget.controller.currentStep.value;
  //     int totalSteps = widget.controller.totalSteps;

  //     return Column(
  //       children: [
  //         Row(
  //           children: [
  //             AppText.primary(
  //               LocaleKeys.specialistSignupScreen_stepIndicator.trParams(
  //                   {'step': '${currentStep + 1}', 'total': '$totalSteps'}),
  //               fontSize: 14,
  //               fontWeight: FontWeightType.medium,
  //               color: AppColors.textSecondary,
  //             ),
  //             const Spacer(),
  //             AppText.primary(
  //               "${((currentStep + 1) / totalSteps * 100).round()}%",
  //               fontSize: 14,
  //               fontWeight: FontWeightType.medium,
  //               color: AppColors.primary,
  //             ),
  //           ],
  //         ),
  //         gapH8,
  //         LinearProgressIndicator(
  //           value: (currentStep + 1) / totalSteps,
  //           backgroundColor: AppColors.lightGrey,
  //           valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
  //           minHeight: 4,
  //         ),
  //       ],
  //     );
  //   });
  // }

  Widget _buildCurrentStep() {
    return Obx(() {
      switch (widget.controller.currentStep.value) {
        case 0:
          return _buildStep1BasicInformation();
        case 1:
          return _buildStep2PersonalDetails();
        case 2:
          return _buildStep3ProfessionalInformation();
        case 3:
          return _buildStep4Preferences();
        default:
          return _buildStep1BasicInformation();
      }
    });
  }

  Widget _buildStep1BasicInformation() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepTitle(LocaleKeys.specialistSignupScreen_basicInformation.tr,
              LocaleKeys.specialistSignupScreen_basicInformationSubtitle.tr),
          gapH16,
          _buildProfileImageUpload(),
          gapH24,
          _buildFullNameField(),
          gapH16,
          _buildEmailField(),
          gapH16,
          _buildPhoneField(),
          gapH16,
          _buildPasswordField(),
          gapH16,
          _buildConfirmPasswordField(),
        ],
      ),
    );
  }

  Widget _buildStep2PersonalDetails() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepTitle(LocaleKeys.specialistSignupScreen_personalDetails.tr,
              LocaleKeys.specialistSignupScreen_personalDetailsSubtitle.tr),
          gapH30,
          _buildDateOfBirthField(),
          gapH24,
          _buildGenderSelection(),
          gapH24,
          _buildLanguagesSelection(),
        ],
      ),
    );
  }

  Widget _buildStep3ProfessionalInformation() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepTitle(
              LocaleKeys.specialistSignupScreen_professionalInformation.tr,
              LocaleKeys
                  .specialistSignupScreen_professionalInformationSubtitle.tr),
          gapH30,
          _buildProfessionField(),
          gapH16,
          _buildExperienceField(),
          gapH16,
          _buildDegreeField(),
          gapH16,
          // Show license field for all professionals, but make it required only for psychiatrists
          _buildLicenseField(),
          gapH16,
          _buildBioField(),
        ],
      ),
    );
  }

  Widget _buildStep4Preferences() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepTitle('Preferences',
              'Please select your preferred client age groups and areas of expertise'),
          gapH30,
          _buildAgeGroupSelection(),
          gapH24,
          _buildAreasOfExpertiseSelection(),
        ],
      ),
    );
  }

  Widget _buildStepTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.primary(
          title,
          fontSize: 24,
          fontWeight: FontWeightType.bold,
          color: AppColors.black,
        ),
        gapH8,
        AppText.primary(
          subtitle,
          fontSize: 16,
          fontWeight: FontWeightType.regular,
          color: AppColors.grey99,
        ),
      ],
    );
  }

  Widget _buildProfileImageUpload() {
    return Obx(() {
      return Column(
        children: [
          GestureDetector(
            onTap: () => widget.controller.pickProfileImage(),
            child: Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: AppColors.whiteLight,
                  shape: BoxShape.circle,
                ),
                child: widget.controller.selectedImagePath.value.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: SizedBox(
                              height: 20,
                              child: AppIcon.uploadIcon.widget(
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          gapH8,
                          AppText.primary(
                            LocaleKeys
                                .specialistSignupScreen_uploadProfilePhoto.tr,
                            fontSize: 12,
                            fontWeight: FontWeightType.medium,
                            color: AppColors.primary,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )
                    : Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: Image.asset(
                              widget.controller.selectedImagePath.value,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                size: 16,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
          gapH8,
          if (widget.controller.selectedImagePath.value.isNotEmpty)
            AppText.primary(
              LocaleKeys.specialistSignupScreen_photoSelected.tr,
              fontSize: 14,
              fontWeight: FontWeightType.medium,
              color: AppColors.primary,
            ),
        ],
      );
    });
  }

  Widget _buildFullNameField() {
    return Obx(() => FormTextField(
          titleText: LocaleKeys.specialistSignupScreen_fullName.tr,
          isRequired: true,
          hintText: LocaleKeys.specialistSignupScreen_fullNameHint.tr,
          backgroundColor: AppColors.whiteLight,
          borderRadius: 8,
          height: 55,
          isInvalid: widget.controller.nameError.value != null,
          invalidText: widget.controller.nameError.value ?? '',
          suffixIcon: AppIcon.userIcon.widget(
            height: 20,
            width: 20,
            color: AppColors.accent,
          ),
          controller: widget.controller.nameController,
          onChanged: (value) {
            // Clear error when user starts typing
            if (widget.controller.nameError.value != null) {
              widget.controller.clearFieldError('name');
            }
          },
        ));
  }

  Widget _buildEmailField() {
    return Obx(() => FormTextField(
          titleText: LocaleKeys.specialistSignupScreen_email.tr,
          isRequired: true,
          hintText: LocaleKeys.specialistSignupScreen_emailHint.tr,
          backgroundColor: AppColors.whiteLight,
          borderRadius: 8,
          height: 55,
          isInvalid: widget.controller.emailError.value != null,
          invalidText: widget.controller.emailError.value ?? '',
          suffixIcon: AppIcon.emailIcon.widget(
            height: 20,
            width: 20,
            color: AppColors.accent,
          ),
          controller: widget.controller.emailController,
          onChanged: (value) {
            // Clear error when user starts typing
            if (widget.controller.emailError.value != null) {
              widget.controller.clearFieldError('email');
            }
          },
        ));
  }

  Widget _buildPhoneField() {
    return Obx(() => FormTextField(
          titleText: LocaleKeys.specialistSignupScreen_phoneNumber.tr,
          isRequired: true,
          hintText: LocaleKeys.specialistSignupScreen_phoneNumberHint.tr,
          backgroundColor: AppColors.whiteLight,
          borderRadius: 8,
          height: 55,
          textInputType: TextInputType.phone,
          isInvalid: widget.controller.phoneError.value != null,
          invalidText: widget.controller.phoneError.value ?? '',
          suffixIcon: AppIcon.phoneIcon.widget(
            height: 20,
            width: 20,
            color: AppColors.accent,
          ),
          controller: widget.controller.phoneController,
          onChanged: (value) {
            // Clear error when user starts typing
            if (widget.controller.phoneError.value != null) {
              widget.controller.clearFieldError('phone');
            }
          },
        ));
  }

  Widget _buildPasswordField() {
    return Obx(() => FormTextField(
          titleText: LocaleKeys.specialistSignupScreen_password.tr,
          isRequired: true,
          hintText: "*************",
          backgroundColor: AppColors.whiteLight,
          borderRadius: 8,
          height: 60,
          isPasswordField: true,
          isInvalid: widget.controller.passwordError.value != null,
          invalidText: widget.controller.passwordError.value ?? '',
          controller: widget.controller.passwordController,
          onChanged: (value) {
            // Clear error when user starts typing
            if (widget.controller.passwordError.value != null) {
              widget.controller.clearFieldError('password');
            }
          },
        ));
  }

  Widget _buildConfirmPasswordField() {
    return Obx(() => FormTextField(
          titleText: LocaleKeys.specialistSignupScreen_confirmPassword.tr,
          isRequired: true,
          hintText: "*************",
          backgroundColor: AppColors.whiteLight,
          borderRadius: 8,
          height: 60,
          isPasswordField: true,
          isInvalid: widget.controller.confirmPasswordError.value != null,
          invalidText: widget.controller.confirmPasswordError.value ?? '',
          controller: widget.controller.confirmPasswordController,
          onChanged: (value) {
            // Clear error when user starts typing
            if (widget.controller.confirmPasswordError.value != null) {
              widget.controller.clearFieldError('confirmPassword');
            }
          },
        ));
  }

  Widget _buildLoginSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppText.primary(
          LocaleKeys.signupScreen_alreadyHaveAccount.tr,
          fontSize: 14,
          fontWeight: FontWeightType.regular,
          color: AppColors.grey99,
        ),
        gapW4,
        InkWell(
          child: AppText.primary(
            LocaleKeys.signupScreen_login.tr,
            color: AppColors.primary,
            fontWeight: FontWeightType.semiBold,
          ),
          onTap: () => Get.back(),
        ),
      ],
    );
  }

  Widget _buildOrSection() {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: AppColors.black0E0,
            thickness: 1.5,
            height: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AppText.primary(
            LocaleKeys.specialistSignupScreen_or.tr,
            fontSize: 14,
            fontWeight: FontWeightType.regular,
            color: AppColors.grey99,
          ),
        ),
        const Expanded(
          child: Divider(
            color: AppColors.black0E0,
            thickness: 1.5,
            height: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleLoginButton() {
    return PrimaryButton(
      title: LocaleKeys.loginScreen_continueWithGoogle.tr,
      height: 55,
      color: AppColors.whiteLight,
      radius: 8,
      fontWeight: FontWeightType.semiBold,
      textColor: AppColors.black,
      showIcon: true,
      iconPosition: IconPosition.left,
      iconWidget: AppIcon.googleIcon.widget(
        width: 20,
        height: 20,
      ),
      onPressed: () {
        // Handle Google login logic here
      },
    );
  }

  Widget _buildDateOfBirthField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AppText.primary(
              LocaleKeys.specialistSignupScreen_dateOfBirth.tr,
              fontSize: 14,
              fontWeight: FontWeightType.medium,
              color: AppColors.black,
            ),
          ],
        ),
        gapH8,
        Obx(() => Row(
              children: [
                // Day Dropdown
                Expanded(
                  child: _buildDateDropdown(
                    hintText: "12",
                    value: widget.controller.selectedDay.value.isEmpty
                        ? null
                        : widget.controller.selectedDay.value,
                    items: List.generate(
                        31, (index) => (index + 1).toString().padLeft(2, '0')),
                    onChanged: (value) {
                      widget.controller.selectedDay.value = value ?? '';
                      widget.controller.dayController.text = value ?? '';
                      widget.controller.dayError.value = null;
                    },
                    errorText: widget.controller.dayError.value
                  ),
                ),
                gapW16,
                // Month Dropdown
                Expanded(
                  child: _buildDateDropdown(
                    hintText: "04",
                    value: widget.controller.selectedMonth.value.isEmpty
                        ? null
                        : widget.controller.selectedMonth.value,
                    items: List.generate(
                        12, (index) => (index + 1).toString().padLeft(2, '0')),
                    onChanged: (value) {
                      widget.controller.selectedMonth.value = value ?? '';
                      widget.controller.monthController.text = value ?? '';
                      widget.controller.monthError.value = null;
                    },
                      errorText: widget.controller.monthError.value
                  ),
                ),
                gapW16,
                // Year Dropdown
                Expanded(
                  child: _buildDateDropdown(
                    hintText: "1984",
                    value: widget.controller.selectedYear.value.isEmpty
                        ? null
                        : widget.controller.selectedYear.value,
                    items: List.generate(80,
                        (index) => (DateTime.now().year - index).toString()),
                    onChanged: (value) {
                      widget.controller.selectedYear.value = value ?? '';
                      widget.controller.yearController.text = value ?? '';
                      widget.controller.yearError.value = null;
                    },
                      errorText: widget.controller.yearError.value
                  ),
                ),
                gapW16,
                // Calendar Icon
                GestureDetector(
                  onTap: () => _showDatePicker(),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: AppColors.whiteLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: AppIcon.datePickerIcon.widget(
                        height: 20,
                        width: 20,
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ],
    );
  }

  Widget _buildDateDropdown({
    required String hintText,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    String? errorText, // Add error parameter
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.whiteLight,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: errorText != null ? AppColors.red513 : AppColors.lightGrey, // Dynamic border color
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              hint: AppText.primary(
                hintText,
                fontSize: 16,
                color: AppColors.grey99,
              ),
              value: value,
              isExpanded: true,
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: AppText.primary(
                    item,
                    fontSize: 16,
                    color: AppColors.black,
                  ),
                );
              }).toList(),
              onChanged: onChanged,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.grey99,
                size: 20,
              ),
            ),
          ),
        ),
        // Error text display
        if (errorText != null && errorText.isNotEmpty) ...[
          gapH4,
          AppText.primary(
            errorText,
            fontSize: 12,
            fontWeight: FontWeightType.regular,
            color: AppColors.red513,
          ),
        ],
      ],
    );
  }

  void _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _getInitialDate(),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.white,
              surface: AppColors.whiteLight,
              onSurface: AppColors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      widget.controller.selectedDay.value =
          picked.day.toString().padLeft(2, '0');
      widget.controller.selectedMonth.value =
          picked.month.toString().padLeft(2, '0');
      widget.controller.selectedYear.value = picked.year.toString();

      widget.controller.dayController.text =
          widget.controller.selectedDay.value;
      widget.controller.monthController.text =
          widget.controller.selectedMonth.value;
      widget.controller.yearController.text =
          widget.controller.selectedYear.value;
    }
  }

  DateTime _getInitialDate() {
    try {
      int day = int.tryParse(widget.controller.selectedDay.value) ?? 1;
      int month = int.tryParse(widget.controller.selectedMonth.value) ?? 1;
      int year = int.tryParse(widget.controller.selectedYear.value) ?? 1990;
      return DateTime(year, month, day);
    } catch (e) {
      return DateTime(1990, 1, 1);
    }
  }

  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.primary(
          LocaleKeys.specialistSignupScreen_gender.tr,
          fontSize: 14,
          fontWeight: FontWeightType.medium,
          color: AppColors.black,
        ),
        gapH8,
        Obx(() => Column(
              children: [
                _buildGenderCheckbox(
                  title: LocaleKeys.specialistSignupScreen_male.tr,
                  value: 'male',
                ),
                gapH12,
                _buildGenderCheckbox(
                  title: LocaleKeys.specialistSignupScreen_female.tr,
                  value: 'female',
                ),
              ],
            )),
      ],
    );
  }

  Widget _buildGenderCheckbox({
    required String title,
    required String value,
  }) {
    bool isSelected = widget.controller.selectedGender.value == value;

    return GestureDetector(
      onTap: () {
        // Single selection logic - toggle if same value, otherwise select new value
        if (widget.controller.selectedGender.value == value) {
          widget.controller.selectedGender.value = '';
        } else {
          widget.controller.selectedGender.value = value;
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.whiteLight,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.lightGrey,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.accent : AppColors.whiteLight,
                border: Border.all(
                  color: isSelected ? AppColors.accent : AppColors.lightGrey,
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
            AppText.primary(
              title,
              fontSize: 14,
              fontWeight: FontWeightType.medium,
              color: isSelected ? AppColors.primary : AppColors.black,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguagesSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.primary(
          LocaleKeys.specialistSignupScreen_languages.tr,
          fontSize: 14,
          fontWeight: FontWeightType.medium,
          color: AppColors.black,
        ),
        gapH8,
        Obx(() {
          List<String> languages = widget.controller.availableLanguages;
          List<Widget> rows = [];

          for (int i = 0; i < languages.length; i += 2) {
            List<Widget> rowChildren = [];

            // First language in the row
            rowChildren.add(
              Expanded(
                child: _buildLanguageCheckbox(
                  title: languages[i],
                  value: languages[i],
                ),
              ),
            );

            // Second language in the row (if exists)
            if (i + 1 < languages.length) {
              rowChildren.add(gapW12);
              rowChildren.add(
                Expanded(
                  child: _buildLanguageCheckbox(
                    title: languages[i + 1],
                    value: languages[i + 1],
                  ),
                ),
              );
            } else {
              // If odd number of languages, add spacer for the second slot
              rowChildren.add(gapW12);
              rowChildren.add(const Expanded(child: SizedBox()));
            }

            rows.add(
              Row(children: rowChildren),
            );

            // Add gap between rows (except for last row)
            if (i + 2 < languages.length) {
              rows.add(gapH12);
            }
          }

          return Column(children: rows);
        }),
      ],
    );
  }

  Widget _buildLanguageCheckbox({
    required String title,
    required String value,
  }) {
    bool isSelected = widget.controller.selectedLanguages.contains(value);

    return GestureDetector(
      onTap: () {
        // Multiple selection logic
        if (isSelected) {
          widget.controller.selectedLanguages.remove(value);
        } else {
          widget.controller.selectedLanguages.add(value);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.whiteLight,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.lightGrey,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.accent : AppColors.whiteLight,
                border: Border.all(
                  color: isSelected ? AppColors.accent : AppColors.lightGrey,
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
                title,
                fontSize: 14,
                fontWeight: FontWeightType.medium,
                color: isSelected ? AppColors.primary : AppColors.black,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfessionField() {
    return Obx(() => CustomDropdownField<SpecialistType>(
          titleText: LocaleKeys.specialistSignupScreen_profession.tr,
          hintText: LocaleKeys.specialistSignupScreen_selectProfession.tr,
          isRequired: true,
          value: widget.controller.selectedProfession.value,
          items: widget.controller.availableProfessions,
          getDisplayText: (profession) =>
              widget.controller.getProfessionDisplayName(profession),
          onChanged: (value) {
            widget.controller.selectedProfession.value = value;
            widget.controller.professionController.text = value != null
                ? widget.controller.getProfessionDisplayName(value)
                : '';
            widget.controller.clearFieldError('profession');
          },
          isInvalid: widget.controller.professionError.value != null,
          invalidText: widget.controller.professionError.value ?? '',
          backgroundColor: AppColors.whiteLight,
          borderRadius: 8,
          height: 55,
          alignment: AlignmentDirectional.centerStart,
        ));
  }

  Widget _buildExperienceField() {
    return Obx(() => FormTextField(
          titleText: LocaleKeys.specialistSignupScreen_yearsOfExperience.tr,
          isRequired: true,
          hintText: LocaleKeys.specialistSignupScreen_yearsOfExperienceHint.tr,
          backgroundColor: AppColors.whiteLight,
          borderRadius: 8,
          height: 55,
          textInputType: TextInputType.number,
          isInvalid: widget.controller.experienceError.value != null,
          invalidText: widget.controller.experienceError.value ?? '',
          controller: widget.controller.experienceController,
          onChanged: (value) {
            // Clear error when user starts typing
            if (widget.controller.experienceError.value != null) {
              widget.controller.clearFieldError('experience');
            }
          },
        ));
  }

  Widget _buildDegreeField() {
    return Obx(() => FormTextField(
          titleText: LocaleKeys.specialistSignupScreen_degree.tr,
          isRequired: true,
          hintText: LocaleKeys.specialistSignupScreen_degreeHint.tr,
          backgroundColor: AppColors.whiteLight,
          borderRadius: 8,
          height: 55,
          isInvalid: widget.controller.degreeError.value != null,
          invalidText: widget.controller.degreeError.value ?? '',
          controller: widget.controller.degreeController,
          onChanged: (value) {
            // Clear error when user starts typing
            if (widget.controller.degreeError.value != null) {
              widget.controller.clearFieldError('degree');
            }
          },
        ));
  }

  Widget _buildLicenseField() {
    return Obx(() => FormTextField(
          titleText: widget.controller.selectedProfession.value == SpecialistType.psychiatrist
              ? LocaleKeys.specialistSignupScreen_licenseNumber.tr
              : LocaleKeys.specialistSignupScreen_registrationNumber.tr,
          isRequired: widget.controller.selectedProfession.value ==
              SpecialistType.psychiatrist,
          hintText: widget.controller.selectedProfession.value == SpecialistType.psychiatrist
              ? LocaleKeys.specialistSignupScreen_licenseNumberHint.tr
              : LocaleKeys.specialistSignupScreen_registrationNumberHint.tr,
          backgroundColor: AppColors.whiteLight,
          borderRadius: 8,
          height: 55,
          isInvalid: widget.controller.licenseError.value != null,
          invalidText: widget.controller.licenseError.value ?? '',
          controller: widget.controller.licenseController,
          onChanged: (value) {
            // Clear error when user starts typing
            if (widget.controller.licenseError.value != null) {
              widget.controller.clearFieldError('license');
            }
          },
        ));
  }

  Widget _buildBioField() {
    return FormTextField(
      titleText: LocaleKeys.specialistSignupScreen_bio.tr,
      hintText: LocaleKeys.specialistSignupScreen_bioHint.tr,
      backgroundColor: AppColors.whiteLight,
      borderRadius: 8,
      height: 120,
      maxLines: 4,
      isInvalid: widget.controller.bioError.value != null,
      invalidText: widget.controller.bioError.value ?? '',
      isRequired: true,
      controller: widget.controller.bioController,
      onChanged: (value) {
        // Clear error when user starts typing
        if (widget.controller.bioError.value != null) {
          widget.controller.clearFieldError('bio');
        }
      },
    );
  }

  Widget _buildAgeGroupSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.primary(
          'What age group(s) do you prefer your clients to belong to?',
          fontSize: 14,
          fontWeight: FontWeightType.medium,
          color: AppColors.black,
        ),
        gapH4,
        AppText.primary(
          '(Multiple selections allowed)',
          fontSize: 12,
          fontWeight: FontWeightType.regular,
          color: AppColors.grey99,
        ),
        gapH12,
        Obx(() {
          return Column(
            children: [
              Column(
                children: widget.controller.availableAgeGroups.map((ageGroup) {
                  return Column(
                    children: [
                      _buildAgeGroupCheckbox(
                        title:
                            widget.controller.getAgeGroupDisplayName(ageGroup),
                        value: ageGroup,
                      ),
                      gapH12,
                    ],
                  );
                }).toList(),
              ),
              // Error message for age groups
              if (widget.controller.ageGroupError.value != null) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: AppText.primary(
                    widget.controller.ageGroupError.value ?? '',
                    fontSize: 12,
                    fontWeight: FontWeightType.regular,
                    color: AppColors.red513,
                  ),
                ),
                gapH8,
              ],
            ],
          );
        }),
      ],
    );
  }

  Widget _buildAgeGroupCheckbox({
    required String title,
    required AgeGroup value,
  }) {
    bool isSelected = widget.controller.selectedAgeGroups.contains(value);

    return GestureDetector(
      onTap: () {
        // Multiple selection logic
        if (isSelected) {
          widget.controller.selectedAgeGroups.remove(value);
        } else {
          widget.controller.selectedAgeGroups.add(value);
        }
        // Clear error when user makes a selection
        widget.controller.clearFieldError('ageGroup');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.whiteLight,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.lightGrey,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.accent : AppColors.whiteLight,
                border: Border.all(
                  color: isSelected ? AppColors.accent : AppColors.lightGrey,
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
            AppText.primary(
              title,
              fontSize: 14,
              fontWeight: FontWeightType.medium,
              color: isSelected ? AppColors.primary : AppColors.black,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAreasOfExpertiseSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.primary(
          'Which areas of expertise would you like to provide assistance in?',
          fontSize: 14,
          fontWeight: FontWeightType.medium,
          color: AppColors.black,
        ),
        gapH4,
        AppText.primary(
          '(Multiple selections allowed)',
          fontSize: 12,
          fontWeight: FontWeightType.regular,
          color: AppColors.grey99,
        ),
        gapH12,
        Obx(() {
          return Column(
            children: [
              Column(
                children:
                    widget.controller.availableAreasOfExpertise.map((area) {
                  return Column(
                    children: [
                      _buildAreaOfExpertiseCheckbox(
                        title: widget.controller
                            .getAreaOfExpertiseDisplayName(area),
                        value: area,
                      ),
                      gapH12,
                    ],
                  );
                }).toList(),
              ),
              // Error message for areas of expertise
              if (widget.controller.expertiseError.value != null) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: AppText.primary(
                    widget.controller.expertiseError.value ?? '',
                    fontSize: 12,
                    fontWeight: FontWeightType.regular,
                    color: AppColors.red513,
                  ),
                ),
                gapH8,
              ],
            ],
          );
        }),
      ],
    );
  }

  Widget _buildAreaOfExpertiseCheckbox({
    required String title,
    required AreaOfExpertise value,
  }) {
    bool isSelected =
        widget.controller.selectedAreasOfExpertise.contains(value);

    return GestureDetector(
      onTap: () {
        // Multiple selection logic
        if (isSelected) {
          widget.controller.selectedAreasOfExpertise.remove(value);
        } else {
          widget.controller.selectedAreasOfExpertise.add(value);
        }
        // Clear error when user makes a selection
        widget.controller.clearFieldError('expertise');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.whiteLight,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.lightGrey,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.accent : AppColors.whiteLight,
                border: Border.all(
                  color: isSelected ? AppColors.accent : AppColors.lightGrey,
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
                title,
                fontSize: 14,
                fontWeight: FontWeightType.medium,
                color: isSelected ? AppColors.primary : AppColors.black,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Obx(() {
      int currentStep = widget.controller.currentStep.value;
      int totalSteps = widget.controller.totalSteps;
      bool isLastStep = currentStep == totalSteps - 1;

      return Row(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                PrimaryButton(
                  title: isLastStep
                      ? LocaleKeys.specialistSignupScreen_createAccount.tr
                      : LocaleKeys.specialistSignupScreen_next.tr,
                  color: AppColors.primary,
                  textColor: AppColors.whiteLight,
                  height: 55,
                  radius: 8,
                  fontWeight: FontWeightType.semiBold,
                  showIcon: true,
                  iconWidget: AppIcon.rightArrowIcon.widget(
                    width: 10,
                    height: 10,
                    color: AppColors.white,
                  ),
                  // onPressed: (isLastStep
                  //         ? () => widget.controller.handleSpecialistSignup()
                  //         : () => widget.controller.goToNextStep()),
                  onPressed: () {
                    widget.controller.goToNextStep();
                  }
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
