import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../app/config/app_colors.dart';

class LoadingIndicatorWidget extends StatelessWidget {
  const LoadingIndicatorWidget({this.sigma = 3.0, super.key});

  final double sigma;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 55,
              width: 55,
              child: CircularProgressIndicator(
                backgroundColor: AppColors.white.withOpacity(.15),
                color: AppColors.white,
                strokeCap: StrokeCap.round,
                strokeWidth: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
