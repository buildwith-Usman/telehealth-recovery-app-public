import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Use this class for import any image in the application
abstract class AppImage {
  AppImage._();

  static const String _assetPath = "assets/images/";

  // Splash Screen - USED
  static AppImageBuilder get splashIcon =>
      AppImageBuilder('${_assetPath}recovery_ic_splash.png');

  // Onboarding flow images - USED
  static AppImageBuilder get onBoardingFlowOne =>
      AppImageBuilder('${_assetPath}recovery_ic_on_boarding_flow_one.svg');

  static AppImageBuilder get onBoardingFlowTwo =>
      AppImageBuilder('${_assetPath}recovery_ic_on_boarding_flow_two.svg');

  static AppImageBuilder get onBoardingFlowThree =>
      AppImageBuilder('${_assetPath}recovery_ic_on_boarding_flow_three.svg');

  // Auth Screens - USED
  static AppImageBuilder get loginSignUpImg =>
      AppImageBuilder('${_assetPath}recovery_ic_login_sign_up_img.svg');

  static AppImageBuilder get otpImg =>
      AppImageBuilder('${_assetPath}recovery_ic_otp_img.svg');

  // Specialist Selection - USED
  static AppImageBuilder get lookingForTherapist =>
      AppImageBuilder('${_assetPath}recovery_ic_looking _for_therapist.png');

  static AppImageBuilder get lookingForPsychiatrist =>
      AppImageBuilder('${_assetPath}recovery_ic_looking _for_psychatrist.png');

  // Questionnaire - USED
  static AppImageBuilder get fillQuestionnaire =>
      AppImageBuilder('${_assetPath}recovery_ic_fill_questionnaire.png');

  // Approval - USED
  static AppImageBuilder get recoveryForApproval =>
      AppImageBuilder('${_assetPath}recovery_ic_waiting_for_approval.png');

  // Doctor Images - USED
  static AppImageBuilder get recoveryDr =>
      AppImageBuilder('${_assetPath}recovery_dr_image.png');

  static AppImageBuilder get dummyDr =>
      AppImageBuilder('${_assetPath}dummy_dr_img.png');    

  static AppImageBuilder get dummyPt =>
      AppImageBuilder('${_assetPath}dummy_patient_img.png');    
  
  static AppImageBuilder get prescriptionImage =>
      AppImageBuilder('${_assetPath}recovery_ic_prescription_image.png'); 

  static AppImageBuilder get dummyMedicineImg =>
      AppImageBuilder('${_assetPath}recovery_ic_dummy_medicine_img.png'); 

  static AppImageBuilder get orderConfirmation =>
      AppImageBuilder('${_assetPath}recovery_ic_order_confirm.png');

  static AppImageBuilder get dummyMedicen =>
      AppImageBuilder('${_assetPath}dummy_medicen.png');
}

class AppImageBuilder {
  final String assetPath;

  AppImageBuilder(this.assetPath);

  Widget widget({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit? fit = BoxFit.contain,
    Alignment alignment = Alignment.center,
    Color? color,
    BorderRadius? borderRadius,
    Widget? placeholder,
    String? errorImageUrl,
    int? memCacheHeight,
  }) {
    return ImageBuilder(
      assetPath,
      key: key,
      width: width,
      height: height,
      fit: fit,
      color: color,
      alignment: alignment,
      placeholder: placeholder,
      errorImageUrl: errorImageUrl,
      memCacheHeight: memCacheHeight,
    );
  }
}

class ImageBuilder extends StatelessWidget {
  final dynamic input;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final Color? color;
  final BorderRadius? borderRadius;
  final Alignment alignment;
  final Widget? placeholder;

  /// This url handle this case can not get image from local
  final String? errorImageUrl;
  final int? memCacheHeight;

  const ImageBuilder(
    this.input, {
    super.key,
    this.height,
    this.width,
    this.color,
    this.fit,
    this.memCacheHeight,
    this.alignment = Alignment.center,
    this.borderRadius,
    this.placeholder,
    this.errorImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: _image(),
      );
    }
    return _image();
  }

  Widget _placeholder() {
    return placeholder ?? Container(color: Colors.white);
  }

  Widget _image() {
    try {
      if (input?.isEmpty ?? true) {
        return _placeholder();
      }
      if (input is Uint8List) {
        return Image.memory(input as Uint8List,
            height: height,
            color: color,
            width: width,
            fit: fit,
            alignment: alignment);
      }
      if (input is! String) {
        return Container();
      }
      bool isNetworkMedia = input.startsWith("http");
      if (input.endsWith('svg')) {
        if (isNetworkMedia) {
          return SvgPicture.network(input,
              colorFilter: color != null
                  ? ColorFilter.mode(color!, BlendMode.srcIn)
                  : null,
              height: height,
              width: width,
              fit: fit ?? BoxFit.contain,
              alignment: alignment);
        }
        return SvgPicture.asset(input,
            colorFilter: color != null
                ? ColorFilter.mode(color!, BlendMode.srcIn)
                : null,
            height: height,
            width: width,
            fit: fit ?? BoxFit.contain,
            alignment: alignment);
      }
      if (isNetworkMedia) {
        return SizedBox(
          width: width,
          height: height,
          child: Image.network(
            input,
            fit: BoxFit.cover,
          ),
        );
      }
      return Image(
        image: AssetImage(input),
        height: height,
        color: color,
        width: width,
        fit: fit,
        alignment: alignment,
      );
    } catch (_) {
      return Container();
    }
  }
}
