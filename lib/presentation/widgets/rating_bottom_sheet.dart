import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/config/app_colors.dart';
import '../../app/utils/sizes.dart';
import '../widgets/app_text.dart';

class RatingBottomSheet extends StatefulWidget {
  final String doctorName;
  final String? doctorImageUrl;
  final Function(int rating, String review) onSubmitRating;

  const RatingBottomSheet({
    super.key,
    required this.doctorName,
    this.doctorImageUrl,
    required this.onSubmitRating,
  });

  @override
  State<RatingBottomSheet> createState() => _RatingBottomSheetState();
}

class _RatingBottomSheetState extends State<RatingBottomSheet> {
  int selectedRating = 0;
  final TextEditingController reviewController = TextEditingController();
  bool isSubmitting = false;
  bool hasSubmitted = false;

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  void _submitReview() async {
    if (selectedRating == 0) {
      Get.snackbar(
        'Rating Required',
        'Please select a rating before submitting',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.red513,
        colorText: AppColors.white,
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      await widget.onSubmitRating(selectedRating, reviewController.text);
      hasSubmitted = true;

      // Close the bottom sheet using Navigator after submission completes
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to submit review. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.red513,
        colorText: AppColors.white,
      );
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedRating = index + 1;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: IconButton(
              onPressed: () {
                setState(() {
                  selectedRating = index + 1;
                });
              },
              icon: Icon(
                Icons.star,
                size: 40,
                color: index < selectedRating 
                    ? AppColors.pendingColor // Golden color for selected stars
                    : AppColors.black.withOpacity(0.3),  // Grey for unselected stars
              ),
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => hasSubmitted,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: SafeArea(
          top: false,
          bottom: true,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grey80,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                
                gapH24,
                
                // Doctor info section
                Row(
                  children: [
                    // Doctor avatar
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                        image: widget.doctorImageUrl != null
                            ? DecorationImage(
                                image: NetworkImage(widget.doctorImageUrl!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: widget.doctorImageUrl == null
                          ? const Icon(
                              Icons.person,
                              color: AppColors.white,
                              size: 30,
                            )
                          : null,
                    ),
                    
                    gapW16,
                    
                    // Doctor name and title
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText.primary(
                            'How was your experience with',
                            fontSize: 14,
                            fontWeight: FontWeightType.medium,
                            color: AppColors.black,
                          ),
                          gapH4,
                          AppText.primary(
                            widget.doctorName,
                            fontSize: 18,
                            fontWeight: FontWeightType.semiBold,
                            color: AppColors.black,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                gapH12,
                // Rating title
                AppText.primary(
                  'Your Overall Rating',
                  fontSize: 16,
                  fontWeight: FontWeightType.medium,
                  color: AppColors.black.withOpacity(0.3),
                ),
                gapH12,
                // Star rating
                _buildStarRating(),
                gapH12,
                // Review section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.primary(
                      'Add a Review',
                      fontSize: 16,
                      fontWeight: FontWeightType.medium,
                      color: AppColors.black,
                    ),
                    gapH12,
                    // Review text field
                    Container(
                      height: 160,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.black.withOpacity(0.1)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: reviewController,
                        maxLines: 4,
                        maxLength: 500,
                        decoration:  InputDecoration(
                          hintText: 'Enter here',
                          hintStyle: TextStyle(
                            color: AppColors.black.withOpacity(0.3),
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                          counterText: '', // Hide character counter
                        ),
                        style: const TextStyle(
                          color: AppColors.black,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                
                gapH32,
                
                // Submit button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isSubmitting ? null : _submitReview,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      disabledBackgroundColor: AppColors.grey80,
                    ),
                    child: isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppText.primary(
                                'Submit Review',
                                fontSize: 16,
                                fontWeight: FontWeightType.medium,
                                color: AppColors.white,
                              ),
                              gapW8,
                              const Icon(
                                Icons.arrow_forward,
                                color: AppColors.white,
                                size: 20,
                              ),
                            ],
                          ),
                  ),
                ),
                
                  gapH16,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Helper function to show the rating bottom sheet
Future<void> showRatingBottomSheet(BuildContext context, {
  required String doctorName,
  String? doctorImageUrl,
  required Function(int rating, String review) onSubmitRating,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isDismissible: false,
    enableDrag: false,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => RatingBottomSheet(
      doctorName: doctorName,
      doctorImageUrl: doctorImageUrl,
      onSubmitRating: onSubmitRating,
    ),
  );
}