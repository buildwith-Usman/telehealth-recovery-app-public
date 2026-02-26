import 'package:flutter/material.dart';
import 'app_image.dart';

// Use this class for import any icon or image in the application
abstract class AppIcon {
  AppIcon._();

  static const String _assetPath = "assets/icons/";

  // Navigation Icons - USED
  static AppIconBuilder get leftArrowIcon =>
      AppIconBuilder('${_assetPath}recovery_ic_left_arrow.svg');

  static AppIconBuilder get rightArrowIcon =>
      AppIconBuilder('${_assetPath}recovery_ic_right_arrow.svg');

  static AppIconBuilder get forwardIcon =>
      AppIconBuilder('${_assetPath}recovery_ic_forward.svg');

  // Form Icons - USED
  static AppIconBuilder get emailIcon =>
      AppIconBuilder('${_assetPath}recovery_ic_email.svg');

  static AppIconBuilder get userIcon =>
      AppIconBuilder('${_assetPath}recovery_ic_user.svg');

  static AppIconBuilder get phoneIcon =>
      AppIconBuilder('${_assetPath}recovery_ic_phone.svg');

  static AppIconBuilder get videoCallIcon =>
      AppIconBuilder('${_assetPath}recovery_ic_video_call.svg');

  static AppIconBuilder get passwordToggleIcon =>
      AppIconBuilder('${_assetPath}recovery_ic_password_toggle.svg');

  static AppIconBuilder get appintmentReminderSetting =>
      AppIconBuilder('${_assetPath}recovery_ic_appointment_reminder.svg');

  static AppIconBuilder get helpSetting =>
      AppIconBuilder('${_assetPath}recovery_ic_help.svg');

  static AppIconBuilder get editIcon =>
      AppIconBuilder('${_assetPath}recovery_ic_edit.svg');

  static AppIconBuilder get sessionIcon =>
      AppIconBuilder('${_assetPath}recovery_ic_sessions.svg');    

  // Specialist Dashboard Icons
  static AppIconBuilder get navPatients =>
      AppIconBuilder('${_assetPath}recovery_ic_patients_dashboard.svg');

  static AppIconBuilder get navAppointments =>
      AppIconBuilder('${_assetPath}recovery_ic_appointment_dashboard.svg');

  static AppIconBuilder get sessionClock =>
      AppIconBuilder('${_assetPath}recovery_ic_session_clock.svg');

  static AppIconBuilder get questionnaireIcon =>
      AppIconBuilder('${_assetPath}recovery_ic_questionnaire.svg');

  static AppIconBuilder get pharmacyIcon =>
      AppIconBuilder('${_assetPath}recovery_ic_pharmacy.png');

  static AppIconBuilder get pharmacyGroupIcon =>
      AppIconBuilder('${_assetPath}recovery_ic_pharmacy_group.png');

  static AppIconBuilder get cartIcon =>
      AppIconBuilder('${_assetPath}recovery_ic_cart.svg');

  static AppIconBuilder get viewPrescriptionIcon =>
      AppIconBuilder('${_assetPath}recovery_ic_view_prescription.svg');

  static AppIconBuilder get facebookIcon =>
      AppIconBuilder('${_assetPath}recovery_ic_facebook.svg');

  static AppIconBuilder get xTwitterIcon =>
      AppIconBuilder('${_assetPath}recovery_ic_x.svg');

  static AppIconBuilder get instagramIcon =>
      AppIconBuilder('${_assetPath}recovery_ic_instagram.svg');   

  static AppIconBuilder get estimatedDeliveryIcon =>
      AppIconBuilder('${_assetPath}recovery_ic_estimated_delivery.svg');

  // Native Flutter Icons for missing assets
  static Widget genderIcon({double? size, Color? color}) => Icon(
        Icons.person_outline,
        size: size ?? 20,
        color: color,
      );

  static Widget ageIcon({double? size, Color? color}) => Icon(
        Icons.cake_outlined,
        size: size ?? 20,
        color: color,
      );

  static Widget lockFlutterIcon({double? size, Color? color}) => Icon(
        Icons.lock_outline,
        size: size ?? 20,
        color: color,
      );

  static AppIconBuilder get uploadIcon =>
      AppIconBuilder('${_assetPath}recovery_ic_upload.svg');

  static AppIconBuilder get datePickerIcon =>
      AppIconBuilder('${_assetPath}recovery_ic_date_picker.svg');

  static AppIconBuilder get dropdownIcon =>
      AppIconBuilder('${_assetPath}recovery_ic_dropdown.svg');

  static AppIconBuilder get itemExpand =>
      AppIconBuilder('${_assetPath}recovery_ic_item_expand.svg');

  static AppIconBuilder get durationIcon =>
      AppIconBuilder('${_assetPath}recovery_ic_duration.svg');

  // Social & Authentication - USED
  static AppIconBuilder get googleIcon =>
      AppIconBuilder('${_assetPath}recovery_ic_google.svg');

  static AppIconBuilder get successIcon =>
      AppIconBuilder('${_assetPath}recovery_ic_success.svg');

  static AppIconBuilder get approvalIcon =>
      AppIconBuilder('${_assetPath}recovery_ic_approval.svg');

  static AppIconBuilder get editProfileIcon =>
      AppIconBuilder('${_assetPath}recovery_ic_edit_profile_img.svg');

  // Rating & Feedback - USED
  static AppIconBuilder get starIcon =>
      AppIconBuilder('${_assetPath}recovery_ic_star.svg');

  // Filter & Search - USED
  static AppIconBuilder get filterIcon =>
      AppIconBuilder('${_assetPath}recovery_ic_filter.svg');

  static AppIconBuilder get searchIcon =>
      AppIconBuilder('${_assetPath}recovery_ic_search.svg');

  // Navigation Bottom Bar - USED
  static AppIconBuilder get navHome =>
      AppIconBuilder('${_assetPath}recovery_ic_home.svg');

  static AppIconBuilder get navAppointment =>
      AppIconBuilder('${_assetPath}recovery_ic_appointment.svg');

  static AppIconBuilder get navDoctors =>
      AppIconBuilder('${_assetPath}recovery_ic_doctors.svg');

  static AppIconBuilder get navPayment =>
      AppIconBuilder('${_assetPath}recovery_ic_payment.svg');

  static AppIconBuilder get navSetting =>
      AppIconBuilder('${_assetPath}recovery_ic_setting.svg');

  // Payment Method Icons - USED
  static AppIconBuilder get jazzCashIcon =>
      AppIconBuilder('${_assetPath}recovery_ic_jazzcash.png');

  static AppIconBuilder get easyPaisaIcon =>
      AppIconBuilder('${_assetPath}recovery_ic_easypaisa.png');

  static AppIconBuilder get cardPaymentIcon =>
      AppIconBuilder('${_assetPath}recovery_ic_card.svg');

  // Native Flutter Payment Icons (fallback options)
  static Widget defaultPaymentIcon({double? size, Color? color}) => Icon(
        Icons.payment,
        size: size ?? 24,
        color: color,
      );

  // Legacy Navigation Icons (keeping for compatibility)
  static AppIconBuilder get navBookAppointment =>
      AppIconBuilder('${_assetPath}recovery_ic_nav_calendar.svg');

  static AppIconBuilder get navHomeAlt =>
      AppIconBuilder('${_assetPath}recovery_ic_nav_home.svg');

  static AppIconBuilder get navSettingAlt =>
      AppIconBuilder('${_assetPath}recovery_ic_nav_setting.svg');

  // UI Elements - USED
  static AppIconBuilder get swipe =>
      AppIconBuilder('${_assetPath}recovery_ic_bottom_sheet_swipe.svg');

  static AppIconBuilder get notification =>
      AppIconBuilder('${_assetPath}recovery_ic_notification.svg');

  static AppIconBuilder get clock =>
      AppIconBuilder('${_assetPath}recovery_ic_clock.svg');

  // Statistics Icons
  static AppIconBuilder get patientIcon =>
      AppIconBuilder('${_assetPath}recovery_ic_patients.svg');

  static AppIconBuilder get experienceIcon =>
      AppIconBuilder('${_assetPath}recovery_ic_experience.svg');

  static AppIconBuilder get ratingIcon =>
      AppIconBuilder('${_assetPath}recovery_ic_rating.svg');

  static AppIconBuilder get confirmedIcon =>
      AppIconBuilder('${_assetPath}recovery_ic_confirmed.svg');

  static AppIconBuilder get orderConfirmation =>
      AppIconBuilder('${_assetPath}recovery_ic_order_confirm.svg'); 

  static AppIconBuilder get orderStatus =>
      AppIconBuilder('${_assetPath}recovery_ic_order_status.svg'); 

  static AppIconBuilder get medicineIcon =>
      AppIconBuilder('${_assetPath}recovery_ic_medicine.svg'); 

  static AppIconBuilder get dosageIcon =>
      AppIconBuilder('${_assetPath}recovery_ic_dosage.svg'); 

  static AppIconBuilder get orderPlaced =>
      AppIconBuilder('${_assetPath}recovery_ic_placed.svg'); 

  static AppIconBuilder get orderDispatched =>
      AppIconBuilder('${_assetPath}recovery_ic_dispatched.svg'); 

  static AppIconBuilder get orderDelivered =>
      AppIconBuilder('${_assetPath}recovery_ic_delivered.svg'); 

  static AppIconBuilder get orderCompleted =>
      AppIconBuilder('${_assetPath}recovery_ic_completed.svg'); 

  static AppIconBuilder get myOrderInProgress =>
      AppIconBuilder('${_assetPath}recovery_ic_order_in_progress.svg'); 

  static AppIconBuilder get myOrderDelivered =>
      AppIconBuilder('${_assetPath}recovery_ic_order_delivered.svg');

  static AppIconBuilder get recoveryAdd =>
      AppIconBuilder('${_assetPath}recovery_ic_add.svg');

  static AppIconBuilder get icAddBannerImage =>
      AppIconBuilder('${_assetPath}ic_add_image.svg');

  static AppIconBuilder get icPreviewBanner =>
      AppIconBuilder('${_assetPath}ic_preview_banner.svg');

  static AppIconBuilder get icDeleteProduct =>
      AppIconBuilder('${_assetPath}ic_delete_product.svg');

  static AppIconBuilder get icParacetamol =>
      AppIconBuilder('${_assetPath}ic_paracetamol.svg');

  static AppIconBuilder get icFever =>
      AppIconBuilder('${_assetPath}ic_dr_fever.svg');

  static AppIconBuilder get icWalutPrice =>
      AppIconBuilder('${_assetPath}ic_price_valut.svg');

  static AppIconBuilder get icVisibilty =>
      AppIconBuilder('${_assetPath}ic_visibilty.svg');

  static AppIconBuilder get icSupplementDrug =>
      AppIconBuilder('${_assetPath}ic_supplement_drug.svg');

  static AppIconBuilder get icSupplementMedicen =>
      AppIconBuilder('${_assetPath}ic_supplement_medicen.svg');

  static AppIconBuilder get icStockMedicen =>
      AppIconBuilder('${_assetPath}ic_stock_medicen.svg');

  static AppIconBuilder get icRemoveProduct =>
      AppIconBuilder('${_assetPath}ic_remove_product.svg');

  static AppIconBuilder get icProductVisibilty =>
      AppIconBuilder('${_assetPath}ic_product_visibilty.svg');

  static AppIconBuilder get icOrderLocation =>
      AppIconBuilder('${_assetPath}ic_order_location.svg');


 static AppIconBuilder get icPrescription =>
      AppIconBuilder('${_assetPath}ic_prescription.svg');


}

class AppIconBuilder {
  final String assetPath;

  AppIconBuilder(this.assetPath);

  Widget widget({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
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
