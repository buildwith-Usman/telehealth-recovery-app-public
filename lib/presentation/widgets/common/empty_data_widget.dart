import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/config/app_colors.dart';
import '../../../generated/locales.g.dart';
import '../app_text.dart';
import '../button/left_icon_button.dart';

class EmptyDataWidget extends StatelessWidget {
  const EmptyDataWidget({
    this.emptyTextDescription,
    this.emptyButtonText,
    required this.callback,
    super.key,
  });

  final String? emptyTextDescription;
  final String? emptyButtonText;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    var emptyTextDesc =
        emptyTextDescription ?? LocaleKeys.emptyData.tr;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 96, bottom: 16),
          height: 80,
          width: 80,
          child: const Icon(
            Icons.inbox_outlined,
            size: 80,
            color: AppColors.grey777,
          ),
        ),
        AppText.primary(
          emptyTextDesc,
          fontSize: 13,
          color: AppColors.grey777,
        ),
        const SizedBox(height: 24),
        if (emptyButtonText != null && emptyButtonText!.trim().isNotEmpty)
          SizedBox(
            width: 158.0,
            child: LeftIconButton(
              height: 32,
              icon: Icons.add,
              title: emptyButtonText!.tr,
              fontSize: 14,
              color: AppColors.cyanShade30,
              textColor: AppColors.grey96,
              iconColor: AppColors.grey96,
              onPressed: () {
                callback();
              },
            ),
          ),
      ],
    );
  }
}
