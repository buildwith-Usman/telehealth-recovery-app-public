import 'dart:math';


import 'package:recovery_consultation_app/app/utils/sizes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';


import '../../presentation/widgets/app_text.dart';
import '../../presentation/widgets/indicator/loading_indicator_widget.dart';
import '../config/app_colors.dart';

class Util {
  static void debugPrint(String message) {
    if (kDebugMode) {
      print(message);
    }
  }

  /// Generates a random string of the given [length].
  ///
  /// The string is composed of uppercase letters and numbers.
  static String getRandomString(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
    // Create a random number generator
    Random rnd = Random();
    // Generate the string
    final result = String.fromCharCodes(
        Iterable.generate(length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
    return result;
  }

  static showSuccessToast({
    required String message,
    required BuildContext context,
  }) {
    FToast fToast = FToast();
    fToast.init(context);
    Widget toast = Material(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        width: Get.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.toastSuccessBorder, width: 1),
          color: AppColors.toastSuccessBg,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: AppColors.toastSuccessMessage,
              size: 17,
            ),
            gapW12,
            Expanded(
              child: AppText.primary(
                message,
                color: AppColors.toastSuccessMessage,
                fontSize: 14,
                textAlign: TextAlign.left,
                fontWeight: FontWeightType.semiBold,
              ),
            ),
            Container(
              height: 20,
              margin: const EdgeInsets.symmetric(horizontal: 10).copyWith(right: 15),
              width: 1,
              color: AppColors.toastSuccessBorder,
            ),
            InkWell(
              onTap: () {
                fToast.removeCustomToast();
              },
              child: const Padding(
                padding: EdgeInsets.all(5.0),
                child: Icon(
                  Icons.clear_rounded,
                  color: AppColors.toastSuccessMessage,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    fToast.showToast(
      child: toast,
      toastDuration: const Duration(milliseconds: 2500),
        positionedToastBuilder: (context, child, toastGravity) {
          return Positioned(
            top: 48,
            left: 12,
            right: 12,
            child: child,
          );
        },
    );
  }

  static showErrorToast({
    required String message,
    required BuildContext context,
  }) {
    FToast fToast = FToast();
    fToast.init(context);
    Widget toast = Material(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        width: Get.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.toastFailedBorder, width: 1),
          color: AppColors.toastFailedMessage,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.warning,
              color: AppColors.toastFailedMessage,
              size: 17,
            ),
            gapW12,
            Expanded(
              child: AppText.primary(
                message,
                color: AppColors.white,
                fontSize: 14,
                textAlign: TextAlign.left,
                fontWeight: FontWeightType.semiBold,
              ),
            ),
            Container(
              height: 20,
              margin: const EdgeInsets.symmetric(horizontal: 10).copyWith(right: 15),
              width: 1,
              color: AppColors.toastFailedBorder,
            ),
            InkWell(
              onTap: () {
                fToast.removeCustomToast();
              },
              child: const Padding(
                padding: EdgeInsets.all(5.0),
                child: Icon(
                  Icons.clear_rounded,
                  color: AppColors.white,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    fToast.showToast(
      child: toast,
      toastDuration: const Duration(milliseconds: 2500),
      positionedToastBuilder: (context, child, toastGravity) {
        return Positioned(
          top: 48,
          left: 12,
          right: 12,
          child: child,
        );
      },
    );
  }

  static String getInitials(String name) {
    List<String> parts = name.trim().split(' ');
    if (parts.length == 1) {
      String first = parts[0][0].toUpperCase();
      String last = parts[0].length > 1 ? parts[0][parts[0].length - 1].toUpperCase() : '';
      return first + last;
    } else {
      return parts[0][0].toUpperCase() + parts[1][0].toUpperCase();
    }
  }


  static void showLoadingIndicator() {
    if (!(Get.isDialogOpen ?? false)) {
      Get.dialog(
        const LoadingIndicatorWidget(),
        barrierDismissible: false,
      );
    }
  }



  static void hideLoadingIndicator() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  static String formatDate(String? dateString) {
    try {
      // Parse the string into a DateTime object
      DateTime date = DateTime.parse(dateString!);

      // Format the DateTime into the desired format (e.g., "12/02/2025")
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      // Handle parsing errors
      return 'Invalid date';
    }
  }



}
