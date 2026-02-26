import 'package:flutter/material.dart';
import 'package:recovery_consultation_app/app/config/app_colors.dart';
import 'package:recovery_consultation_app/app/config/app_image.dart';
import 'package:recovery_consultation_app/app/utils/sizes.dart';
import 'package:recovery_consultation_app/presentation/widgets/app_text.dart';

class ReviewCard extends StatelessWidget {
  final String name;
  final double rating;
  final String date;
  final String comment;

  const ReviewCard({
    super.key,
    required this.name,
    required this.rating,
    required this.date,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Profile Picture
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.grey80.withOpacity(0.3),
                ),
                child: AppImage.dummyPt.widget(
                  width: 20,
                  height: 20,
                ),
              ),
              gapW12,
              // Name and Rating
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.primary(
                      name,
                      fontSize: 16,
                      fontWeight: FontWeightType.semiBold,
                      color: AppColors.textPrimary,
                    ),
                    gapH4,
                    Row(
                      children: [
                        // Star Rating
                        Row(
                          children: [
                            AppText.primary(rating.toString(),fontSize: 12,fontWeight: FontWeightType.medium,),
                            gapW8, // space between text and stars
                            ...List.generate(5, (index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 2),
                                child: Icon(
                                  index < rating.floor()
                                      ? Icons.star
                                      : Icons.star_border,
                                  size: 16,
                                  color: Colors.amber,
                                ),
                              );
                            }),
                          ],
                        ),

                        gapW8,
                        AppText.primary(
                          date,
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          gapH12,
          AppText.primary(
            comment,
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}
