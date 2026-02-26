import 'package:flutter/material.dart';

import '../../../app/config/app_colors.dart';
import '../../../app/utils/global.dart';
import '../app_text.dart';

Future<void> showSnackBar({
  required String description,
  Duration duration = const Duration(milliseconds: 4500),
}) async {
  final context = navigatorKey.currentContext;
  if (context != null) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    final snackBar = SnackBar(
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 16),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Icon(
            Icons.warning_amber_rounded,
            size: 20,
            color: AppColors.beigeShade30,
          ),
          const SizedBox(width: 7),
          Expanded(
            child: AppText.system(
              description,
              color: AppColors.beigeShade30,
              fontWeight: FontWeightType.semiBold,
            ),
          ),
        ],
      ),
      duration: duration,
      backgroundColor: AppColors.beigeTint90,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
