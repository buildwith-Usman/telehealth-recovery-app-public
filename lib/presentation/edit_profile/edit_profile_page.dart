import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/config/app_colors.dart';
import '../../app/config/app_icon.dart';
import '../../app/services/base_stateful_page.dart';
import '../../app/utils/sizes.dart';
import '../../generated/locales.g.dart';
import '../widgets/app_text.dart';
import '../widgets/button/custom_navigation_button.dart';
import '../widgets/button/primary_button.dart';
import '../widgets/textfield/form_textfield.dart';
import '../widgets/dropdown/custom_dropdown_field.dart';
import '../../app/config/app_enum.dart';
import 'edit_profile_controller.dart';

class EditProfilePage extends BaseStatefulPage<EditProfileController> {
  const EditProfilePage({super.key});

  @override
  BaseStatefulPageState<EditProfileController> createState() =>
      _EditProfilePageState();
}

//Full Name ,Email, Phone Number,date of birth field, gender selection, build language selection,build professional field, build experience field, build degree field, build license field, build bio field

class _EditProfilePageState
    extends BaseStatefulPageState<EditProfileController> {

  @override
  Widget buildPageContent(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteLight,
      body: _buildEditProfileContent(context),
    );
  }

  Widget _buildEditProfileContent(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(),
                  gapH20,
                  Obx(() {
                    if (!widget.controller.showHeaderTitles.value) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildPageTitle(),
                          gapH32,
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                  _buildProfileImageSection(),
                  gapH32,
                  _buildNameField(),
                  gapH16,
                  _buildEmailField(),
                  gapH16,
                  _buildPhoneField(),
                  gapH16,
                  // Hide gender and DOB for admin users (they don't have patientInfo or doctorInfo)
                  Obx(() {
                    if (widget.controller.userEntity.value?.patientInfo != null ||
                        widget.controller.userEntity.value?.doctorInfo != null) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildGenderSelection(),
                          gapH16,
                          _buildDateOfBirthField(),
                          gapH24,
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                  // Professional Information Section - Only visible for specialist editing own profile or admin viewing specialist
                  Obx(() {
                    if (widget.controller.editSpecialist.value) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildProfessionalSectionTitle(),
                          gapH16,
                          _buildLanguagesSelection(),
                          gapH16,
                          _buildProfessionField(),
                          gapH16,
                          _buildExperienceField(),
                          gapH16,
                          _buildDegreeField(),
                          gapH16,
                          _buildLicenseField(),
                          gapH16,
                          _buildBioField(),
                          Obx(() {
                            if (widget.controller.showGroupAdminEditFields.value) {
                              return _buildCommissionFields();
                            }
                            return const SizedBox.shrink();
                          }),
                          _buildStepTitle('Preferences',
                              'Please select your preferred client age groups and areas of expertise'),
                          gapH16,
                          _buildAgeGroupSelection(),
                          gapH16,
                          _buildAreasOfExpertiseSelection(),
                          gapH16,
                          Obx(() {
                            if (widget.controller.showScheduleSection.value) {
                              return _buildScheduleSection();
                            }
                            return const SizedBox.shrink();
                          }),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                  gapH20,
                ],
              ),
            ),
          ),
          // Fixed button at bottom
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            decoration: BoxDecoration(
              color: AppColors.whiteLight,
              border: Border(
                top: BorderSide(
                  color: AppColors.grey90.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: Obx(() => widget.controller.openFromApproval.value
                ? _buildEditProfileActionButtons()
                : _buildSaveButton()),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CustomNavigationButton(
          type: NavigationButtonType.previous,
          onPressed: () => Get.back(),
          isFilled: true,
          filledColor: AppColors.whiteLight,
          iconColor: AppColors.accent,
          backgroundColor: AppColors.white,
        ),
        Expanded(
          child: Center(
            child: AppText.primary(
              widget.controller.pageTitle.value,
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

  Widget _buildPageTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.primary(
          'Update Your Profile',
          fontFamily: FontFamilyType.poppins,
          fontSize: 24,
          fontWeight: FontWeightType.bold,
          color: AppColors.black,
          textAlign: TextAlign.left,
        ),
        gapH6,
        AppText.primary(
          'Keep your information up to date',
          fontFamily: FontFamilyType.inter,
          fontSize: 16,
          fontWeight: FontWeightType.regular,
          color: AppColors.textSecondary,
          textAlign: TextAlign.left,
        ),
      ],
    );
  }

  Widget _buildProfileImageSection() {
    return Center(
      child: GestureDetector(
        onTap: () => widget.controller.onChangeProfileImage(),
        child: Stack(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.grey80.withValues(alpha: 0.3),
              ),
              child: ClipOval(
                child: Obx(() {
                  // Show selected image file first, then network image, then placeholder
                  if (widget.controller.selectedImageFile.value != null) {
                    return Image.file(
                      widget.controller.selectedImageFile.value!,
                      fit: BoxFit.fill,
                      width: double.infinity,
                      height: double.infinity,
                    );
                  } else if (widget
                      .controller.profileImageUrl.value.isNotEmpty) {
                    return Image.network(
                      widget.controller.profileImageUrl.value,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildPlaceholderImage();
                      },
                    );
                  } else {
                    return _buildPlaceholderImage();
                  }
                }),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: AppIcon.editProfileIcon.widget(
                width: 36,
                height: 36,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.whiteLight,
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Icon(
          Icons.person,
          color: AppColors.primary,
          size: 50,
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return Obx(() => FormTextField(
          titleText: 'Full Name',
          isRequired: true,
          hintText: "Enter your full name",
          backgroundColor: AppColors.white,
          borderRadius: 8,
          height: 55,
          isInvalid: widget.controller.nameError.value != null,
          invalidText: widget.controller.nameError.value ?? '',
          suffixIcon: AppIcon.userIcon.widget(
            height: 20,
            width: 20,
            color: AppColors.accent,
          ),
          controller: widget.controller.nameTextEditingController,
          onChanged: (value) {
            if (widget.controller.nameError.value != null) {
              widget.controller.clearNameError();
            }
          },
        ));
  }

  Widget _buildEmailField() {
    return Obx(() => FormTextField(
          titleText: 'Email Address',
          isRequired: true,
          hintText: "Enter your email address",
          backgroundColor: AppColors.white,
          borderRadius: 8,
          height: 55,
          textInputType: TextInputType.emailAddress,
          isInvalid: widget.controller.emailError.value != null,
          invalidText: widget.controller.emailError.value ?? '',
          suffixIcon: AppIcon.emailIcon.widget(
            height: 20,
            width: 20,
            color: AppColors.accent,
          ),
          controller: widget.controller.emailTextEditingController,
          onChanged: (value) {
            if (widget.controller.emailError.value != null) {
              widget.controller.clearEmailError();
            }
          },
        ));
  }

  Widget _buildPhoneField() {
    return Obx(() => FormTextField(
          titleText: 'Phone Number',
          isRequired: true,
          hintText: "Enter your phone number",
          backgroundColor: AppColors.white,
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
          controller: widget.controller.phoneTextEditingController,
          onChanged: (value) {
            if (widget.controller.phoneError.value != null) {
              widget.controller.clearPhoneError();
            }
          },
        ));
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
                _buildSelectionCheckbox(
                  title: LocaleKeys.specialistSignupScreen_male.tr,
                  value: 'male',
                  isMultiSelect: false,
                  selectedSingle: widget.controller.selectedGender.value,
                  onTap: () {
                    if (widget.controller.selectedGender.value.toLowerCase() ==
                        'male') {
                      widget.controller.selectedGender.value = '';
                      widget.controller.genderTextEditingController.text = '';
                    } else {
                      widget.controller.selectedGender.value = 'male';
                      widget.controller.genderTextEditingController.text =
                          'male';
                    }
                  },
                ),
                gapH12,
                _buildSelectionCheckbox(
                  title: LocaleKeys.specialistSignupScreen_female.tr,
                  value: 'female',
                  isMultiSelect: false,
                  selectedSingle: widget.controller.selectedGender.value,
                  onTap: () {
                    if (widget.controller.selectedGender.value.toLowerCase() ==
                        'female') {
                      widget.controller.selectedGender.value = '';
                      widget.controller.genderTextEditingController.text = '';
                    } else {
                      widget.controller.selectedGender.value = 'female';
                      widget.controller.genderTextEditingController.text =
                          'female';
                    }
                  },
                ),
              ],
            )),
        // Show gender validation error if any
        Obx(() => widget.controller.genderError.value != null
            ? Padding(
                padding: const EdgeInsets.only(top: 8),
                child: AppText.primary(
                  widget.controller.genderError.value!,
                  fontSize: 12,
                  color: AppColors.red513,
                ),
              )
            : const SizedBox.shrink()),
      ],
    );
  }

  Widget _buildSelectionCheckbox({
    required String title,
    required String value,
    required bool isMultiSelect,
    List<String>? selectedList,
    String? selectedSingle,
    required VoidCallback? onTap,
  }) {
    bool isSelected = isMultiSelect
        ? selectedList?.contains(value) ?? false
        : selectedSingle?.toLowerCase() == value.toLowerCase();
    bool isDisabled = onTap == null;

    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: isDisabled ? 0.6 : 1.0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isDisabled ? AppColors.grey80.withValues(alpha: 0.3) : AppColors.white,
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
      ),
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
            Obx(() => widget.controller.selectedDay.value.isNotEmpty &&
                    widget.controller.selectedMonth.value.isNotEmpty &&
                    widget.controller.selectedYear.value.isNotEmpty
                ? Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.accent.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          size: 12,
                          color: AppColors.accent,
                        ),
                        const SizedBox(width: 4),
                        AppText.primary(
                          'Selected',
                          fontSize: 10,
                          fontWeight: FontWeightType.medium,
                          color: AppColors.accent,
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink()),
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
                    },
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
                    },
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
                    },
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
        // Show date of birth validation error if any
        Obx(() => widget.controller.dobError.value != null
            ? Padding(
                padding: const EdgeInsets.only(top: 8),
                child: AppText.primary(
                  widget.controller.dobError.value!,
                  fontSize: 12,
                  color: AppColors.red513,
                ),
              )
            : const SizedBox.shrink()),
      ],
    );
  }

  Widget _buildSaveButton() {
    return PrimaryButton(
      title: 'Save Changes',
      onPressed: () {
        widget.controller.onSaveProfile();
      },
      width: double.infinity,
      height: 50,
      color: AppColors.primary,
      textColor: AppColors.white,
      fontWeight: FontWeightType.semiBold,
      radius: 8,
    );
  }

  Widget _buildDateDropdown({
    required String hintText,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? value,
  }) {
    bool hasValue = value != null && value.isNotEmpty;

    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: hasValue
            ? AppColors.accent.withValues(alpha: 0.05)
            : AppColors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: hasValue
              ? AppColors.accent.withValues(alpha: 0.5)
              : AppColors.textSecondary.withOpacity(0.3),
          width: hasValue ? 1.5 : 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: AppText.primary(
              hintText,
              fontSize: 14,
              fontWeight: FontWeightType.regular,
              color: AppColors.textSecondary,
            ),
          ),
          value: value,
          items: items
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: AppText.primary(
                        item,
                        fontSize: 14,
                        fontWeight: item == value
                            ? FontWeightType.semiBold
                            : FontWeightType.regular,
                        color: item == value
                            ? AppColors.accent
                            : AppColors.black,
                      ),
                    ),
                  ))
              .toList(),
          onChanged: (String? newValue) {
            onChanged(newValue);
            // Clear DOB error when user selects a date component
            if (widget.controller.dobError.value != null) {
              widget.controller.clearDobError();
            }
          },
          icon: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Icon(
              Icons.keyboard_arrow_down,
              color: hasValue ? AppColors.accent : AppColors.textSecondary,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  void _showDatePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.white,
              onSurface: AppColors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      widget.controller.selectedDay.value =
          pickedDate.day.toString().padLeft(2, '0');
      widget.controller.selectedMonth.value =
          pickedDate.month.toString().padLeft(2, '0');
      widget.controller.selectedYear.value = pickedDate.year.toString();

      widget.controller.dayController.text =
          widget.controller.selectedDay.value;
      widget.controller.monthController.text =
          widget.controller.selectedMonth.value;
      widget.controller.yearController.text =
          widget.controller.selectedYear.value;
    }
  }

  // ==================== PROFESSIONAL INFORMATION FIELDS ====================

  Widget _buildProfessionalSectionTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.primary(
          'Professional Information',
          fontFamily: FontFamilyType.poppins,
          fontSize: 20,
          fontWeight: FontWeightType.semiBold,
          color: AppColors.black,
          textAlign: TextAlign.left,
        ),
        gapH6,
        AppText.primary(
          'Update professional details',
          fontFamily: FontFamilyType.inter,
          fontSize: 14,
          fontWeight: FontWeightType.regular,
          color: AppColors.textSecondary,
          textAlign: TextAlign.left,
        ),
      ],
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
          bool canEdit = widget.controller.canEditProfessionalFields.value;

          for (int i = 0; i < languages.length; i += 2) {
            List<Widget> rowChildren = [];

            // First language in the row
            rowChildren.add(
              Expanded(
                child: _buildSelectionCheckbox(
                  title: languages[i],
                  value: languages[i],
                  isMultiSelect: true,
                  selectedList: widget.controller.selectedLanguages,
                  onTap: canEdit ? () {
                    if (widget.controller.selectedLanguages
                        .contains(languages[i])) {
                      widget.controller.selectedLanguages.remove(languages[i]);
                    } else {
                      widget.controller.selectedLanguages.add(languages[i]);
                    }
                  } : null,
                ),
              ),
            );

            // Second language in the row (if exists)
            if (i + 1 < languages.length) {
              rowChildren.add(gapW12);
              rowChildren.add(
                Expanded(
                  child: _buildSelectionCheckbox(
                    title: languages[i + 1],
                    value: languages[i + 1],
                    isMultiSelect: true,
                    selectedList: widget.controller.selectedLanguages,
                    onTap: canEdit ? () {
                      if (widget.controller.selectedLanguages
                          .contains(languages[i + 1])) {
                        widget.controller.selectedLanguages
                            .remove(languages[i + 1]);
                      } else {
                        widget.controller.selectedLanguages
                            .add(languages[i + 1]);
                      }
                    } : null,
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

  Widget _buildProfessionField() {
    return Obx(() {
      bool canEdit = widget.controller.canEditProfessionalFields.value;
      return IgnorePointer(
        ignoring: !canEdit,
        child: Opacity(
          opacity: canEdit ? 1.0 : 0.6,
          child: CustomDropdownField<SpecialistType>(
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
            backgroundColor: canEdit
                ? AppColors.white
                : AppColors.grey80.withValues(alpha: 0.3),
            borderRadius: 8,
            height: 55,
            alignment: AlignmentDirectional.centerStart,
          ),
        ),
      );
    });
  }

  Widget _buildExperienceField() {
    return Obx(() {
      bool canEdit = widget.controller.canEditProfessionalFields.value;
      return FormTextField(
        titleText: LocaleKeys.specialistSignupScreen_yearsOfExperience.tr,
        isRequired: true,
        hintText: LocaleKeys.specialistSignupScreen_yearsOfExperienceHint.tr,
        backgroundColor: canEdit ? AppColors.white : AppColors.grey80.withValues(alpha: 0.3),
        borderRadius: 8,
        height: 55,
        textInputType: TextInputType.number,
        readOnly: !canEdit,
        isInvalid: widget.controller.experienceError.value != null,
        invalidText: widget.controller.experienceError.value ?? '',
        controller: widget.controller.experienceController,
        onChanged: (value) {
          // Clear error when user starts typing
          if (widget.controller.experienceError.value != null) {
            widget.controller.clearFieldError('experience');
          }
        },
      );
    });
  }

  Widget _buildDegreeField() {
    return Obx(() {
      bool canEdit = widget.controller.canEditProfessionalFields.value;
      return FormTextField(
        titleText: LocaleKeys.specialistSignupScreen_degree.tr,
        isRequired: true,
        hintText: LocaleKeys.specialistSignupScreen_degreeHint.tr,
        backgroundColor: canEdit ? AppColors.white : AppColors.grey80.withValues(alpha: 0.3),
        borderRadius: 8,
        height: 55,
        readOnly: !canEdit,
        isInvalid: widget.controller.degreeError.value != null,
        invalidText: widget.controller.degreeError.value ?? '',
        controller: widget.controller.degreeController,
        onChanged: (value) {
          // Clear error when user starts typing
          if (widget.controller.degreeError.value != null) {
            widget.controller.clearFieldError('degree');
          }
        },
      );
    });
  }

  Widget _buildLicenseField() {
    return Obx(() {
      bool canEdit = widget.controller.canEditProfessionalFields.value;
      return FormTextField(
        titleText: widget.controller.selectedProfession.value ==
                SpecialistType.psychiatrist
            ? LocaleKeys.specialistSignupScreen_licenseNumber.tr
            : LocaleKeys.specialistSignupScreen_registrationNumber.tr,
        isRequired: widget.controller.selectedProfession.value ==
            SpecialistType.psychiatrist,
        hintText: widget.controller.selectedProfession.value ==
                SpecialistType.psychiatrist
            ? LocaleKeys.specialistSignupScreen_licenseNumberHint.tr
            : LocaleKeys.specialistSignupScreen_registrationNumberHint.tr,
        backgroundColor: canEdit ? AppColors.white : AppColors.grey80.withValues(alpha: 0.3),
        borderRadius: 8,
        height: 55,
        readOnly: !canEdit,
        isInvalid: widget.controller.licenseError.value != null,
        invalidText: widget.controller.licenseError.value ?? '',
        controller: widget.controller.licenseController,
        onChanged: (value) {
          // Clear error when user starts typing
          if (widget.controller.licenseError.value != null) {
            widget.controller.clearFieldError('license');
          }
        },
      );
    });
  }

  Widget _buildBioField() {
    return FormTextField(
      titleText: LocaleKeys.specialistSignupScreen_bio.tr,
      hintText: LocaleKeys.specialistSignupScreen_bioHint.tr,
      backgroundColor: AppColors.white,
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
          bool canEdit = widget.controller.canEditProfessionalFields.value;
          return Column(
            children: [
              Column(
                children: widget.controller.availableAgeGroups.map((ageGroup) {
                  return Column(
                    children: [
                      _buildSelectionCheckbox(
                        title:
                            widget.controller.getAgeGroupDisplayName(ageGroup),
                        value: ageGroup.toString(),
                        isMultiSelect: true,
                        selectedList: widget.controller.selectedAgeGroups
                            .map((e) => e.toString())
                            .toList(),
                        onTap: canEdit ? () {
                          if (widget.controller.selectedAgeGroups
                              .contains(ageGroup)) {
                            widget.controller.selectedAgeGroups
                                .remove(ageGroup);
                          } else {
                            widget.controller.selectedAgeGroups.add(ageGroup);
                          }
                        } : null,
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
          bool canEdit = widget.controller.canEditProfessionalFields.value;
          return Column(
            children: [
              Column(
                children:
                    widget.controller.availableAreasOfExpertise.map((area) {
                  return Column(
                    children: [
                      _buildSelectionCheckbox(
                        title: widget.controller
                            .getAreaOfExpertiseDisplayName(area),
                        value: area.toString(),
                        isMultiSelect: true,
                        selectedList: widget.controller.selectedAreasOfExpertise
                            .map((e) => e.toString())
                            .toList(),
                        onTap: canEdit ? () {
                          if (widget.controller.selectedAreasOfExpertise
                              .contains(area)) {
                            widget.controller.selectedAreasOfExpertise
                                .remove(area);
                          } else {
                            widget.controller.selectedAreasOfExpertise
                                .add(area);
                          }
                        } : null,
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

  Widget _buildCommissionFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.primary(
          'Commission Details',
          fontSize: 18,
          fontWeight: FontWeightType.semiBold,
          color: AppColors.black,
        ),
        gapH16,
        Row(
          children: [
            // Commission Type Dropdown
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.primary(
                    'Commission Type',
                    fontSize: 14,
                    fontWeight: FontWeightType.medium,
                    color: AppColors.black,
                  ),
                  gapH8,
                  Obx(() => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.lightGrey,
                            width: 1,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value:
                                widget.controller.selectedCommissionType.value,
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down,
                                color: AppColors.grey99),
                            items: widget.controller.availableCommissionTypes
                                .map((String type) {
                              return DropdownMenuItem<String>(
                                value: type,
                                child: AppText.primary(
                                  type,
                                  fontSize: 14,
                                  fontWeight: FontWeightType.regular,
                                  color: AppColors.black,
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                widget.controller.selectedCommissionType.value =
                                    newValue;
                                // Clear error when user makes selection
                                if (widget.controller.commissionError.value !=
                                    null) {
                                  widget.controller
                                      .clearFieldError('commission');
                                }
                              }
                            },
                          ),
                        ),
                      )),
                ],
              ),
            ),
            gapW16,
            // Commission Value Input
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.primary(
                    'Commission Value',
                    fontSize: 14,
                    fontWeight: FontWeightType.medium,
                    color: AppColors.black,
                  ),
                  gapH8,
                  Obx(() => FormTextField(
                        titleText: '',
                        hintText:
                            widget.controller.selectedCommissionType.value ==
                                    'Percentage (%)'
                                ? '5% or Rs. 15'
                                : 'Enter amount',
                        backgroundColor: AppColors.white,
                        borderRadius: 8,
                        height: 55,
                        isInvalid:
                            widget.controller.commissionError.value != null,
                        invalidText:
                            widget.controller.commissionError.value ?? '',
                        controller: widget.controller.commissionValueController,
                        onChanged: (value) {
                          // Clear error when user starts typing
                          if (widget.controller.commissionError.value != null) {
                            widget.controller.clearFieldError('commission');
                          }
                        },
                      )),
                ],
              ),
            ),
          ],
        ),
        // Show commission validation error if any
        Obx(() => widget.controller.commissionError.value != null
            ? Padding(
                padding: const EdgeInsets.only(top: 8),
                child: AppText.primary(
                  widget.controller.commissionError.value!,
                  fontSize: 12,
                  color: AppColors.red513,
                ),
              )
            : const SizedBox()),
      ],
    );
  }

Widget _buildScheduleSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Header Row
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: AppText.primary(
              'Available Time',
              fontSize: 18,
              fontWeight: FontWeightType.semiBold,
              color: AppColors.black,
            ),
          ),
          gapW8,
          // Only show "Edit Schedule" button if user can edit schedule (admin only)
          Obx(() {
            if (widget.controller.canEditSchedule.value) {
              bool hasSchedule = widget.controller.scheduleData.isNotEmpty;
              return GestureDetector(
                onTap: _showAddTimeDialog,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText.primary(
                      hasSchedule ? 'Edit Schedule' : 'Add Time',
                      fontSize: 14,
                      fontWeight: FontWeightType.medium,
                      color: AppColors.accent,
                    ),
                    gapW8,
                    AppIcon.editIcon
                        .widget(height: 16, width: 16, color: AppColors.accent),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      gapH16,

      // Schedule content
      Obx(() {
        if (widget.controller.scheduleData.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.lightGrey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.lightGrey),
            ),
            child: Center(
              child: AppText.primary(
                'No schedule added yet. Tap "Add Time" to get started.',
                fontSize: 14,
                fontWeight: FontWeightType.regular,
                color: AppColors.grey99,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        // List of schedule rows - iterate through actual schedule data
        // Sort entries by day order (Monday, Tuesday, etc.)
        final sortedEntries = widget.controller.scheduleData.entries.toList()
          ..sort((a, b) {
            final dayOrder = widget.controller.availableDays;
            return dayOrder.indexOf(a.key).compareTo(dayOrder.indexOf(b.key));
          });

        return Column(
          children: sortedEntries
              .map((entry) {
                String day = entry.key;
                List<String> timeSlots = entry.value;

                // Skip if no time slots for this day
                if (timeSlots.isEmpty) return const SizedBox.shrink();

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.lightGrey),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Day Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Day icon
                          AppIcon.datePickerIcon.widget(
                            width: 16,
                            height: 16,
                            color: AppColors.accent,
                          ),
                          gapW12,
                          // Day text
                          Flexible(
                            child: AppText.primary(
                              day,
                              fontSize: 14,
                              fontWeight: FontWeightType.medium,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                      gapH8,
                      // Time slots
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: timeSlots.map((timeSlot) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AppIcon.durationIcon.widget(
                                    width: 12,
                                    height: 12,
                                    color: AppColors.white),
                                gapW4,
                                AppText.primary(
                                  timeSlot,
                                  fontSize: 12,
                                  fontWeight: FontWeightType.medium,
                                  color: AppColors.white,
                                ),
                                // Only show remove button if user can edit schedule (admin only)
                                Obx(() {
                                  if (widget.controller.canEditSchedule.value) {
                                    return Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        gapW4,
                                        GestureDetector(
                                          onTap: () {
                                            widget.controller
                                                .removeTimeSlot(day, timeSlot);
                                          },
                                          child: const Icon(
                                            Icons.close,
                                            size: 12,
                                            color: AppColors.white,
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                  return const SizedBox.shrink();
                                }),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              })
              .where((w) => w is! SizedBox)
              .toList(),
        );
      }),

      // Schedule validation error
      Obx(() => widget.controller.scheduleError.value != null
          ? Padding(
              padding: const EdgeInsets.only(top: 8),
              child: AppText.primary(
                widget.controller.scheduleError.value!,
                fontSize: 12,
                color: AppColors.red513,
              ),
            )
          : const SizedBox()),
    ],
  );
}


  //Used by Admin to approve/reject profile edits
  Widget _buildEditProfileActionButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.grey90.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              title: 'Reject',
              color: AppColors.red513,
              textColor: AppColors.white,
              onPressed: () => {
                Get.back()
                // widget.controller.onStatusUpdate(SpecialistStatus.rejected.name)
              },
            ),
          ),
          gapW12,
          Expanded(
            child: _buildActionButton(
              title: 'Approve',
              color: AppColors.primary,
              textColor: AppColors.white,
              onPressed: () => {
                // Get.back()
                // Navigator.canPop(context)
                widget.controller.onStatusUpdate(SpecialistStatus.approved.name)
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String title,
    required Color color,
    required Color textColor,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      height: 36,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          elevation: 0,
        ),
        child: AppText.primary(
          title,
          fontFamily: FontFamilyType.inter,
          fontSize: 12,
          fontWeight: FontWeightType.medium,
          color: textColor,
        ),
      ),
    );
  }

  void _showAddTimeDialog() {
    print('🔵 Opening _showAddTimeDialog');
    print('🔵 Current scheduleData: ${widget.controller.scheduleData}');

    // Initialize local state for the dialog
    RxList<String> selectedDays = <String>[].obs;
    RxMap<String, String> startTimes = <String, String>{}.obs;
    RxMap<String, String> endTimes = <String, String>{}.obs;

    // Initialize session duration from controller or default
    RxString sessionDuration = (widget.controller.sessionDuration.value.isNotEmpty
        ? widget.controller.sessionDuration.value
        : '30 min').obs;

    print('🔵 Initial session duration: ${sessionDuration.value}');

    // Initialize default times for all days first
    for (String day in widget.controller.availableDays) {
      startTimes[day] = '10:00 AM';
      endTimes[day] = '10:00 AM';
    }

    // Pre-populate with existing schedule data from API/previous edits
    if (widget.controller.scheduleData.isNotEmpty) {
      print('📅 Pre-populating dialog with ${widget.controller.scheduleData.length} days');
      print('📅 scheduleData keys: ${widget.controller.scheduleData.keys.toList()}');

      widget.controller.scheduleData.forEach((day, timeSlots) {
        if (timeSlots.isNotEmpty) {
          print('📅 Processing day: $day with ${timeSlots.length} time slots');

          // Add day to selected days
          selectedDays.add(day);

          // Parse the first time slot for this day (format: "10:00 AM - 2:00 PM")
          String firstTimeSlot = timeSlots.first;
          print('📅 First time slot: $firstTimeSlot');

          List<String> times = firstTimeSlot.split(' - ');

          if (times.length == 2) {
            startTimes[day] = times[0].trim();
            endTimes[day] = times[1].trim();
            print('📅 Set times for $day: ${startTimes[day]} - ${endTimes[day]}');
          } else {
            print('⚠️ Failed to parse time slot: $firstTimeSlot');
            startTimes[day] = '10:00 AM';
            endTimes[day] = '10:00 AM';
          }
        }
      });

      print('📅 Selected days after pre-population: ${selectedDays.toList()}');
      print('📅 Start times: ${startTimes.entries.where((e) => selectedDays.contains(e.key)).map((e) => '${e.key}: ${e.value}').toList()}');
      print('📅 End times: ${endTimes.entries.where((e) => selectedDays.contains(e.key)).map((e) => '${e.key}: ${e.value}').toList()}');
    } else {
      print('📅 No existing schedule data to pre-populate');
    }

    // Helper function to show time picker
    Future<void> selectTime(String day, bool isStartTime) async {
      TimeOfDay initialTime = const TimeOfDay(hour: 10, minute: 0);

      // Parse current time if available
      String currentTime = isStartTime
          ? (startTimes[day] ?? '10:00AM')
          : (endTimes[day] ?? '10:00AM');
      try {
        String timeStr = currentTime.replaceAll(RegExp(r'[AP]M'), '');
        List<String> parts = timeStr.split(':');
        int hour = int.parse(parts[0]);
        int minute = int.parse(parts[1]);

        if (currentTime.contains('PM') && hour != 12) hour += 12;
        if (currentTime.contains('AM') && hour == 12) hour = 0;

        initialTime = TimeOfDay(hour: hour, minute: minute);
      } catch (e) {
        // Use default if parsing fails
      }

      final TimeOfDay? picked = await showTimePicker(
        context: Get.context!,
        initialTime: initialTime,
      );

      if (picked != null) {
        // Format time in 12-hour format: "2:00 PM"
        int hour = picked.hourOfPeriod == 0 ? 12 : picked.hourOfPeriod;
        String minute = picked.minute.toString().padLeft(2, '0');
        String period = picked.period == DayPeriod.am ? 'AM' : 'PM';
        String formattedTime = '$hour:$minute $period';

        if (isStartTime) {
          startTimes[day] = formattedTime;
        } else {
          endTimes[day] = formattedTime;
        }
      }
    }

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: Get.width * 0.9,
          constraints: BoxConstraints(maxHeight: Get.height * 0.85),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title - dynamic based on whether editing or adding
              AppText.primary(
                selectedDays.isEmpty ? 'Select Date & Time' : 'Edit Schedule',
                fontSize: 20,
                fontWeight: FontWeightType.bold,
                color: AppColors.black,
              ),
              gapH16,

              // Current Schedule Preview (if exists)
              Obx(() {
                if (selectedDays.isNotEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.primary(
                        'Current Schedule:',
                        fontSize: 14,
                        fontWeight: FontWeightType.semiBold,
                        color: AppColors.grey99,
                      ),
                      gapH8,
                      Container(
                        constraints: const BoxConstraints(maxHeight: 150),
                        child: SingleChildScrollView(
                          child: Column(
                            children: selectedDays.map((day) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.accent.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppColors.accent.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    // Day icon
                                    AppIcon.datePickerIcon.widget(
                                      width: 14,
                                      height: 14,
                                      color: AppColors.accent,
                                    ),
                                    gapW8,
                                    // Day name
                                    Expanded(
                                      child: AppText.primary(
                                        day,
                                        fontSize: 13,
                                        fontWeight: FontWeightType.medium,
                                        color: AppColors.black,
                                      ),
                                    ),
                                    gapW8,
                                    // Time slot
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.accent,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Obx(() => Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          AppIcon.durationIcon.widget(
                                            width: 10,
                                            height: 10,
                                            color: AppColors.white,
                                          ),
                                          gapW4,
                                          AppText.primary(
                                            '${startTimes[day]} - ${endTimes[day]}',
                                            fontSize: 11,
                                            fontWeight: FontWeightType.medium,
                                            color: AppColors.white,
                                          ),
                                        ],
                                      )),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      gapH16,
                      const Divider(color: AppColors.lightGrey),
                      gapH16,
                    ],
                  );
                }
                return const SizedBox.shrink();
              }),

              // Edit Section Title
              AppText.primary(
                'Edit Schedule:',
                fontSize: 16,
                fontWeight: FontWeightType.semiBold,
                color: AppColors.black,
              ),
              gapH12,
              Obx(() => GestureDetector(
                    onTap: () {
                      Get.bottomSheet(
                        Container(
                          decoration: const BoxDecoration(
                            color: AppColors.white,
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 8),
                                width: 40,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: AppColors.lightGrey,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    AppText.primary(
                                      'Select Session Duration',
                                      fontSize: 18,
                                      fontWeight: FontWeightType.semiBold,
                                      color: AppColors.black,
                                    ),
                                    gapH20,
                                    ...['15 min', '30 min', '45 min', '60 min']
                                        .map((duration) {
                                      return GestureDetector(
                                        onTap: () {
                                          sessionDuration.value = duration;
                                          Get.back();
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          margin:
                                              const EdgeInsets.only(bottom: 12),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16, horizontal: 20),
                                          decoration: BoxDecoration(
                                            color: sessionDuration.value ==
                                                    duration
                                                ? AppColors.accent
                                                    .withValues(alpha: 0.1)
                                                : AppColors.lightGrey
                                                    .withValues(alpha: 0.1),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                              color: sessionDuration.value ==
                                                      duration
                                                  ? AppColors.accent
                                                  : AppColors.lightGrey,
                                            ),
                                          ),
                                          child: AppText.primary(
                                            duration,
                                            fontSize: 16,
                                            fontWeight: FontWeightType.medium,
                                            color: sessionDuration.value ==
                                                    duration
                                                ? AppColors.accent
                                                : AppColors.black,
                                          ),
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.lightGrey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.lightGrey),
                      ),
                      child: Row(
                        children: [
                          AppText.primary(
                            sessionDuration.value,
                            fontSize: 14,
                            fontWeight: FontWeightType.medium,
                            color: AppColors.black,
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.access_time,
                              size: 16,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
              gapH24,

              // Days List
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: widget.controller.availableDays.map((day) {
                      String shortDay = day.substring(0, 3);
                      return Obx(() {
                        bool isSelected = selectedDays.contains(day);
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              // Checkbox
                              GestureDetector(
                                onTap: () {
                                  if (isSelected) {
                                    selectedDays.remove(day);
                                  } else {
                                    selectedDays.add(day);
                                  }
                                },
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.accent
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.accent
                                          : AppColors.lightGrey,
                                      width: 2,
                                    ),
                                  ),
                                  child: isSelected
                                      ? const Icon(
                                          Icons.check,
                                          size: 16,
                                          color: AppColors.white,
                                        )
                                      : null,
                                ),
                              ),
                              gapW12,

                              // Day name
                              SizedBox(
                                width: 35,
                                child: AppText.primary(
                                  shortDay,
                                  fontSize: 14,
                                  fontWeight: FontWeightType.medium,
                                  color: AppColors.grey99,
                                ),
                              ),
                              gapW8,

                              // Available/Unavailable status
                              Container(
                                width: 75,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 6),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.lightGrey
                                      : AppColors.lightGrey.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Center(
                                  child: AppText.primary(
                                    isSelected ? 'Available' : 'Unavailable',
                                    fontSize: 11,
                                    fontWeight: FontWeightType.medium,
                                    color: AppColors.black,
                                  ),
                                ),
                              ),
                              gapW8,

                              // Time slots section - use Expanded to take remaining space
                              Expanded(
                                child: Row(
                                  children: [
                                    if (isSelected) ...[
                                      // Start Time
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () => selectTime(day, true),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: AppColors.lightGrey
                                                  .withValues(alpha: 0.3),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Column(
                                              children: [
                                                AppText.primary(
                                                  'Start',
                                                  fontSize: 9,
                                                  fontWeight:
                                                      FontWeightType.regular,
                                                  color: AppColors.accent,
                                                ),
                                                Obx(() => AppText.primary(
                                                  startTimes[day] ?? '10:00 AM',
                                                  fontSize: 11,
                                                  fontWeight:
                                                      FontWeightType.medium,
                                                  color: AppColors.black,
                                                )),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      gapW6,

                                      // End Time
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () => selectTime(day, false),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: AppColors.lightGrey
                                                  .withValues(alpha: 0.3),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Column(
                                              children: [
                                                AppText.primary(
                                                  'End',
                                                  fontSize: 9,
                                                  fontWeight:
                                                      FontWeightType.regular,
                                                  color: AppColors.accent,
                                                ),
                                                Obx(() => AppText.primary(
                                                  endTimes[day] ?? '10:00 AM',
                                                  fontSize: 11,
                                                  fontWeight:
                                                      FontWeightType.medium,
                                                  color: AppColors.black,
                                                )),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ] else ...[
                                      // Empty space for unavailable days
                                      const SizedBox(),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                    }).toList(),
                  ),
                ),
              ),
              gapH24,

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    print('🔄 ========== SUBMIT CLICKED ==========');
                    print('📋 selectedDays: ${selectedDays.toList()}');
                    print('📋 selectedDays types: ${selectedDays.map((d) => '$d (${d.length} chars)').toList()}');
                    print('📋 Current scheduleData BEFORE clear:');
                    widget.controller.scheduleData.forEach((key, value) {
                      print('   "$key" (${key.length} chars): $value');
                    });

                    // Step 1: Clear existing schedule completely (including any corrupt data)
                    widget.controller.scheduleData.clear();
                    print('🗑️ After .clear(), scheduleData isEmpty: ${widget.controller.scheduleData.isEmpty}');

                    // Step 2: Build new schedule data with FULL day names only
                    print('➕ Building new schedule data...');
                    Map<String, List<String>> cleanScheduleData = {};

                    for (String day in selectedDays) {
                      // Ensure we're using the full day name from availableDays
                      // This guarantees consistency (Monday, Tuesday, etc.)
                      String fullDayName = day;

                      // Safety check: Verify it's in the official availableDays list
                      if (!widget.controller.availableDays.contains(fullDayName)) {
                        print('⚠️ WARNING: "$fullDayName" not in availableDays, skipping');
                        continue;
                      }

                      String timeSlot = '${startTimes[day]} - ${endTimes[day]}';
                      print('   Adding: "$fullDayName" (${fullDayName.length} chars) → $timeSlot');

                      cleanScheduleData[fullDayName] = [timeSlot];
                    }

                    // Step 3: Replace the entire map with clean data
                    widget.controller.scheduleData.value = cleanScheduleData;
                    widget.controller.scheduleData.refresh();

                    // Step 4: Update session duration in controller
                    widget.controller.sessionDuration.value = sessionDuration.value;

                    print('✅ Final scheduleData AFTER update:');
                    widget.controller.scheduleData.forEach((key, value) {
                      print('   "$key" (${key.length} chars): $value');
                    });
                    print('✅ Session duration: ${widget.controller.sessionDuration.value}');
                    print('🔄 ========== END SUBMIT ==========');

                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText.primary(
                        'Submit',
                        fontSize: 16,
                        fontWeight: FontWeightType.semiBold,
                        color: AppColors.white,
                      ),
                      gapW8,
                      const Icon(
                        Icons.arrow_forward,
                        size: 18,
                        color: AppColors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
