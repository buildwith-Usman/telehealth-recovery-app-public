import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/config/app_icon.dart';
import 'package:recovery_consultation_app/presentation/widgets/button/primary_button.dart';
import 'package:recovery_consultation_app/presentation/widgets/common/prescription_image.dart';
import 'package:recovery_consultation_app/presentation/widgets/textfield/form_textfield.dart';
import '../../app/config/app_colors.dart';
import '../../app/utils/sizes.dart';
import '../widgets/app_text.dart';

enum NotesTabType { addNote, prescriptionDetails }

class PrescribedMedicine {
  final String id;
  final String name;
  final String? additionalNotes;

  PrescribedMedicine({
    required this.id,
    required this.name,
    this.additionalNotes,
  });
}

class NotesBottomSheet extends StatefulWidget {
  final String patientName;
  final String? patientImageUrl;
  final String appointmentId;
  final Function({String? notes, List<PrescribedMedicine>? medicines}) onSave;
  final String? specialization; // e.g., 'psychiatrist', 'therapist'

  const NotesBottomSheet({
    super.key,
    required this.patientName,
    this.patientImageUrl,
    required this.appointmentId,
    required this.onSave,
    this.specialization,
  });

  @override
  State<NotesBottomSheet> createState() => _NotesBottomSheetState();
}

class _NotesBottomSheetState extends State<NotesBottomSheet> {
  final TextEditingController notesController = TextEditingController();
  final TextEditingController additionalNotesController = TextEditingController();
  bool isSaving = false;
  NotesTabType selectedTab = NotesTabType.addNote;

  // Prescription details
  String? selectedMedicine;
  List<PrescribedMedicine> prescribedMedicines = [];

  // Check if prescription tab should be shown (only for psychiatrists)
  bool get _showPrescriptionTab {
    if (widget.specialization == null) return false;
    return widget.specialization!.toLowerCase().contains('psychiatrist');
  }

  // Sample medicine list - Replace with actual data from API
  final List<String> medicineList = [
    'Paracetamol 500mg',
    'Ibuprofen 400mg',
    'Amoxicillin 250mg',
    'Aspirin 75mg',
    'Metformin 500mg',
    'Atorvastatin 10mg',
    'Omeprazole 20mg',
    'Cetirizine 10mg',
  ];

  @override
  void dispose() {
    notesController.dispose();
    additionalNotesController.dispose();
    super.dispose();
  }

  void _addToPrescription() {
    if (selectedMedicine == null || selectedMedicine!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a medicine before adding'),
          backgroundColor: AppColors.red513,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final newMedicine = PrescribedMedicine(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: selectedMedicine!,
      additionalNotes: additionalNotesController.text.trim().isEmpty
          ? null
          : additionalNotesController.text.trim(),
    );

    setState(() {
      prescribedMedicines.add(newMedicine);
      selectedMedicine = null;
      additionalNotesController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Medicine has been added to prescription'),
        backgroundColor: AppColors.checkedColor,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _removeMedicine(String id) {
    setState(() {
      prescribedMedicines.removeWhere((medicine) => medicine.id == id);
    });
  }

  void _editMedicine(PrescribedMedicine medicine) {
    setState(() {
      selectedMedicine = medicine.name;
      additionalNotesController.text = medicine.additionalNotes ?? '';
      prescribedMedicines.removeWhere((m) => m.id == medicine.id);
    });
  }


  void _handleButtonPress() {
    // For psychiatrists on Add Note tab, "Next" button navigates to Prescription tab
    if (_showPrescriptionTab && selectedTab == NotesTabType.addNote) {
      // Validate that notes are entered before moving to prescription
      if (notesController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please add consultation notes before proceeding to prescription'),
            backgroundColor: AppColors.red513,
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      // Switch to Prescription Details tab
      setState(() {
        selectedTab = NotesTabType.prescriptionDetails;
      });
      return;
    }

    // Otherwise, handle the submit
    _handleUnifiedSubmit();
  }

  void _handleUnifiedSubmit() async {
    final hasNotes = notesController.text.trim().isNotEmpty;
    final hasMedicines = prescribedMedicines.isNotEmpty;
    final isPsychiatrist = _showPrescriptionTab;

    // Validation based on specialization
    if (isPsychiatrist) {
      // Psychiatrist: Both notes AND prescription are required
      if (!hasNotes || !hasMedicines) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Both consultation notes and prescription details are required for psychiatrist consultations'),
            backgroundColor: AppColors.red513,
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }
    } else {
      // Therapist: Only consultation notes are required
      if (!hasNotes) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Consultation notes are required'),
            backgroundColor: AppColors.red513,
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }
    }

    setState(() {
      isSaving = true;
    });

    bool saveSuccessful = false;
    String? errorMessage;

    try {
      // Call unified save method with both notes and medicines
      await widget.onSave(
        notes: hasNotes ? notesController.text.trim() : null,
        medicines: hasMedicines ? prescribedMedicines : null,
      );
      saveSuccessful = true;
    } catch (e) {
      saveSuccessful = false;
      errorMessage = 'Failed to save details. Data has been cleared.';
      if (kDebugMode) {
        print('NotesBottomSheet: Error during save: $e');
      }
    } finally {
      // Always close the sheet
      if (mounted) {
        setState(() {
          isSaving = false;
        });
        Navigator.pop(context);
      }

      // Show message after sheet is closed
      await Future.delayed(const Duration(milliseconds: 300));

      if (saveSuccessful) {
        // Show success message
        String successMessage = '';
        if (hasNotes && hasMedicines) {
          successMessage =
              'Consultation notes and prescription saved successfully';
        } else if (hasNotes) {
          successMessage = 'Consultation notes saved successfully';
        } else {
          successMessage =
              'Prescription saved successfully with ${prescribedMedicines.length} medicine(s)';
        }

        Get.snackbar(
          'Success',
          successMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.checkedColor,
          colorText: AppColors.white,
        );
      } else {
        // Show error message
        Get.snackbar(
          'Error',
          errorMessage ?? 'Failed to save details',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.red513,
          colorText: AppColors.white,
          duration: const Duration(seconds: 3),
        );
      }
    }
  }

  String _getSubmitButtonLabel() {
    // For psychiatrists on Add Note tab, show "Next"
    if (_showPrescriptionTab && selectedTab == NotesTabType.addNote) {
      return 'Next';
    }

    final hasNotes = notesController.text.trim().isNotEmpty;
    final hasMedicines = prescribedMedicines.isNotEmpty;

    if (hasNotes && hasMedicines) {
      return 'Save All Details';
    } else if (hasNotes) {
      return 'Save Notes';
    } else if (hasMedicines) {
      return 'Save Prescription';
    }
    return 'Submit';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: 0
            ),
            child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grey80,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              gapH24,
              // Title
              Center(
                child: AppText.primary(
                  'Consultation Details',
                  fontSize: 18,
                  fontWeight: FontWeightType.semiBold,
                  color: AppColors.black333,
                ),
              ),
              gapH20,
              // Patient info section
              Row(
                children: [
                  // Patient avatar
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                      image: widget.patientImageUrl != null
                          ? DecorationImage(
                              image: NetworkImage(widget.patientImageUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: widget.patientImageUrl == null
                        ? const Icon(
                            Icons.person,
                            color: AppColors.white,
                            size: 30,
                          )
                        : null,
                  ),
                  gapW16,
                  // Patient name and consultation info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.primary(
                          'Consultation Notes for',
                          fontSize: 14,
                          color: AppColors.grey60,
                        ),
                        gapH4,
                        AppText.primary(
                          widget.patientName,
                          fontSize: 18,
                          fontWeight: FontWeightType.semiBold,
                          color: AppColors.black333,
                        ),
                        gapH2,
                        Row(
                          children: [
                            AppIcon.durationIcon.widget(width: 14,height: 14),
                            gapW4,
                            AppText.primary(
                              'May 28, 2025 - 01:30 PM',
                              fontSize: 12,
                              fontWeight: FontWeightType.regular,
                              color: AppColors.textSecondary,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              gapH20,
              // Tab buttons
              _buildToggleButtons(),
              gapH20,
              // Tab content
              _buildTabContent(),
              gapH20,
              // Unified Submit Button
              PrimaryButton(
                color: AppColors.primary,
                textColor: AppColors.white,
                title: _getSubmitButtonLabel(),
                height: 44,
                radius: 8,
                fontSize: 14,
                fontWeight: FontWeightType.semiBold,
                showIcon: true,
                iconWidget: AppIcon.rightArrowIcon.widget(
                  width: 8,
                  height: 8,
                  color: AppColors.white,
                ),
                onPressed: () {
                  if (!isSaving) _handleButtonPress();
                },
              ),
              gapH16,
            ],
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildToggleButtons() {
    // If prescription tab is not shown, return empty widget
    if (!_showPrescriptionTab) {
      return const SizedBox.shrink();
    }
    
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildToggleButton(
              title: 'Add Note',
              type: NotesTabType.addNote,
              isSelected: selectedTab == NotesTabType.addNote,
            ),
          ),
          Expanded(
            child: _buildToggleButton(
              title: 'Prescription Details',
              type: NotesTabType.prescriptionDetails,
              isSelected: selectedTab == NotesTabType.prescriptionDetails,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required String title,
    required NotesTabType type,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = type;
        });
      },
      child: Container(
        height: 45,
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

  Widget _buildTabContent() {
    switch (selectedTab) {
      case NotesTabType.addNote:
        return _buildAddNoteSection();
      case NotesTabType.prescriptionDetails:
        return _buildPrescriptionDetailsSection();
    }
  }

  Widget _buildAddNoteSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.primary(
          'Consultation Notes',
          color: AppColors.black,
          fontSize: 14,
          fontWeight: FontWeightType.semiBold,
        ),
        gapH10,
        _buildNotesField(),
      ],
    );
  }

  Widget _buildPrescriptionDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Prescription Image
        AppText.primary(
          'Prescription Image',
          color: AppColors.black,
          fontSize: 14,
          fontWeight: FontWeightType.semiBold,
        ),
        gapH10,
        PrescriptionImage(
          imageUrl: '',
          height: 350,
          onTap: () {},
          showPicker: true,
        ),
        gapH20,
        // Medicine Name Dropdown
        AppText.primary(
          'Medicine Name',
          color: AppColors.black,
          fontSize: 14,
          fontWeight: FontWeightType.semiBold,
        ),
        gapH10,
        _buildMedicineDropdown(),
        gapH20,
        // Additional Notes
        AppText.primary(
          'Additional Notes',
          color: AppColors.black,
          fontSize: 14,
          fontWeight: FontWeightType.semiBold,
        ),
        gapH10,
        _buildAdditionalNotesField(),
        gapH20,
        // Add to Prescription Button
        PrimaryButton(
          color: AppColors.primary,
          textColor: AppColors.white,
          title: 'Add to Prescription',
          height: 40,
          radius: 6,
          fontSize: 12,
          fontWeight: FontWeightType.semiBold,
          showIcon: true,
          iconWidget: const Icon(
            Icons.add,
            size: 16,
            color: AppColors.white,
          ),
          onPressed: _addToPrescription,
        ),
        gapH20,
        // Prescribed Medicines Section
        if (prescribedMedicines.isNotEmpty) ...[
          AppText.primary(
            'Prescribed Medicines',
            color: AppColors.black,
            fontSize: 16,
            fontWeight: FontWeightType.semiBold,
          ),
          gapH12,
          _buildPrescribedMedicinesList(),
        ],
      ],
    );
  }

  Widget _buildNotesField() {
    return FormTextField(
      hintText: 'Type here ...',
      backgroundColor: AppColors.white,
      borderRadius: 8,
      height: 180,
      maxLines: 10,
      showBorder: true,
      controller: notesController,
      onChanged: (value) {
        notesController.text = value;
        // Clear error when user starts typing
      },
    );
  }

  Widget _buildMedicineDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.grey80),
      ),
      child: DropdownButtonFormField<String>(
        initialValue: selectedMedicine,
        decoration: const InputDecoration(
          hintText: 'Select medicine',
          hintStyle: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: InputBorder.none,
        ),
        dropdownColor: AppColors.white,
        icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
        items: medicineList.map((String medicine) {
          return DropdownMenuItem<String>(
            value: medicine,
            child: AppText.primary(
              medicine,
              fontSize: 14,
              color: AppColors.black,
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedMedicine = newValue;
          });
        },
      ),
    );
  }

  Widget _buildAdditionalNotesField() {
    return FormTextField(
      hintText: 'Type additional notes here ...',
      backgroundColor: AppColors.white,
      borderRadius: 8,
      height: 100,
      maxLines: 5,
      showBorder: true,
      controller: additionalNotesController,
      onChanged: (value) {
        additionalNotesController.text = value;
      },
    );
  }

  Widget _buildPrescribedMedicinesList() {
    return Column(
      children: prescribedMedicines.map((medicine) {
        return _buildMedicineListItem(medicine);
      }).toList(),
    );
  }

  Widget _buildMedicineListItem(PrescribedMedicine medicine) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.grey80),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Medicine Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: AppIcon.medicineIcon.widget(
                  width: 24,
                  height: 24,
                  color: AppColors.primary,
                ),
              ),
              gapW12,
              // Medicine Name
              Expanded(
                child: AppText.primary(
                  medicine.name,
                  fontSize: 14,
                  fontWeight: FontWeightType.semiBold,
                  color: AppColors.black,
                ),
              ),
              gapW8,
              // Edit Button
              GestureDetector(
                onTap: () => _editMedicine(medicine),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.edit,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      gapW4,
                      AppText.primary(
                        'Edit',
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeightType.medium,
                      ),
                    ],
                  ),
                ),
              ),
              gapW4,
              // Remove Button
              GestureDetector(
                onTap: () => _removeMedicine(medicine.id),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.delete_outline,
                        size: 16,
                        color: AppColors.red513,
                      ),
                      gapW4,
                      AppText.primary(
                        'Remove',
                        fontSize: 12,
                        color: AppColors.red513,
                        fontWeight: FontWeightType.medium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Additional Notes (if any)
          if (medicine.additionalNotes != null &&
              medicine.additionalNotes!.isNotEmpty) ...[
            gapH8,
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.grey80.withOpacity(0.3),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.notes,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                  gapW6,
                  Expanded(
                    child: AppText.primary(
                      medicine.additionalNotes!,
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

}

/// Helper function to show the notes bottom sheet
Future<void> showNotesBottomSheet(
  BuildContext context, {
  required String patientName,
  String? patientImageUrl,
  required String appointmentId,
  String? specialization,
  required Function({String? notes, List<PrescribedMedicine>? medicines}) onSave,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    isDismissible: false, // Prevent dismissing by tapping outside
    enableDrag: false, // Prevent dismissing by dragging down
    builder: (context) => PopScope(
      canPop: false, // Prevent back button from closing
      child: NotesBottomSheet(
        patientName: patientName,
        patientImageUrl: patientImageUrl,
        appointmentId: appointmentId,
        specialization: specialization,
        onSave: onSave,
      ),
    ),
  );
}