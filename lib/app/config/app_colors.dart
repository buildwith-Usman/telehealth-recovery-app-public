import 'package:flutter/material.dart';

// 🎨 CLEANED & ORGANIZED APP COLORS
// This file contains only the colors that are actually used in the app
//
// 🆕 NEW DESIGN SYSTEM COLORS (August 2025):
// - FFFFFF → background (App Background Color)
// - 00424E → primary & textPrimary (App Primary Color & Text Color)
// - 5A5A5A → textSecondary (Light Text Color)
// - 0094B8 → accent (Accent Color)
// - F7F7F9 → whiteLight (White Light)
// - D8D8DA → textOnContainer (Text Color Inside Boxes)
//
class AppColors {
  // ========================================
  // 🏥 PRIMARY BRAND COLORS
  // ========================================

  /// Main primary color - App brand blue (Updated to new design)
  static const primary = Color(0xFF00424E);
  static const shadePrimary = Color(0x4D0094B8);

  /// Main accent color for highlights and interactions
  static const accent = Color(0xFF0094B8);

  /// Dark green brand color
  static const darkGreen = Color(0xFF141D3E);

  // ========================================
  // 🌫️ NEUTRAL COLORS (Basic Colors)
  // ========================================

  /// Pure colors
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);

  /// Main backgrounds
  static const background =
      Color(0xFFFFFFFF); // Updated to new design background
  static const offWhite =
      Color(0xFFF9F9F9); // Also used as settingScreenBgColor

  /// Light background variations
  static const whiteLight = Color(0xFFF4F6F8);
  static const whiteLightAlt = Color(0xFFF7F7F9); // Light background for cards/containers
  static const greyF7 = Color(0xFFF7F7F9); // Light grey background

  /// Navigation colors
  static const navUnselected = Color(0xFFF1F1F1); // Unselected nav item color

  // ========================================
  // 📊 GRAY SCALE (Most Used)
  // ========================================

  /// Main text colors (New Design System)
  static const textPrimary =
      Color(0xFF00424E); // Primary text color - same as primary brand
  static const textSecondary =
      Color(0xFF5A5A5A); // Light text color for secondary content
  static const textOnContainer =
      Color(0xFFD8D8DA); // Text color inside boxes/containers

  /// Gray variations (commonly used)
  static const grey50 = Color(0xFF808080);
  static const grey60 = Color(0xFF8E8E8E);
  static const grey80 = Color(0xFFCCCCCC); // Also used as greyCCC, pickFileDotColor
  static const grey90 = Color(0xFFE0E0E0);
  static const grey95 = Color(0xFFF2F2F2);
  static const grey96 = Color(0xFFF5F5F5);
  static const grey97 = Color(0xFFF7F7F7);
  static const grey99 = Color(0xFF999999);
  static const greyA8 = Color(0xFFA8A4A4); // Light gray for borders/dividers
  static const grey777 = Color(0xFF777777); // Also used as settingScreenDrAppointmentLabelColor
  static const darkGrey = Color(0xFF848484);
  static const lightGrey = Color(0xFFEAEDF2);
  static const blackE8E = Color(0xFF8E8E8E);
  static const black0E0 = Color(0xFFE0E0E0);
  static const greyFEF = Color(0xFFEFEFEF);

  // ========================================
  // 🔵 BLUE VARIATIONS (App Theme)
  // ========================================

  /// Blue colors used in the app
  static const blueCA = Color(0xFF428BCA);
  static const green8DB = Color(0xFF3498DB);
  static const green9A5 = Color(0xFF0099A5);
  static const cyanShade30 = Color(0xFF0099A5);

  // ========================================
  // 🟢 STATUS & SEMANTIC COLORS
  // ========================================

  /// Success/Error states
  static const checkedColor = Color(0xFF28A745);
  static const red513 = Color(0xFFE61513);

  /// Toast notifications
  static const toastSuccessMessage = Color(0xFF496E1C);
  static const toastSuccessBg = Color(0xFFE9F8DD);
  static const toastSuccessBorder = Color(0xFF94CD62);
  static const toastFailedMessage = Color(0xFFCA1513);
  static const toastFailedBg = Color(0xFFFFE9E9);
  static const toastFailedBorder = Color(0xFFFF9A99);

  // ========================================
  // 🩺 HEALTHCARE SPECIFIC COLORS
  // ========================================

  /// Patient/Doctor colors
  static const patientColor2 = Color(0xFF255ED4);
  static const brown = Color(0xFFD48E25); // Also used as threePatientsColor
  static const pendingColor = Color(0xFFFFA500);

  /// Token/Appointment colors
  static const receptionCurrentTokenBg = Color(0xFFE3D496);
  static const receptionCurrentTokenBorderWidthColor = Color(0xFFFFFAE5);
  static const bookedTokenBgColor = Color(0xFFEAEBEB);
  static const bookedTokenBoxTextColor = Color(0xFFD5D6D6);
  static const unBookedTokenBoxTextColor = Color(0xFF616161);

  /// Appointment boxes
  static const appointmentBoxColor = Color(0xFFDEE2FF);
  static const appointmentBoxWidthColor = Color(0xFFC1C8FF);
  static const appointmentDetailsBg = Color(0xFFDEF6FD);

  /// Token state backgrounds
  static const checkedTokenBoxColor = Color(0x1A28A745);
  static const twoPatientsBoxColor = Color(0x1A255ED4);
  static const threePatientsBoxColor = Color(0x1AD48E25);

  // ========================================
  // 🎨 COMPONENT SPECIFIC COLORS
  // ========================================

  /// Text colors
  static const todoTitle = Color(0xFF545454);

  /// Prescription and special use
  static const prescriptionColor = Color(0xFFE7C6D6);

  /// Beige (used for snackbars)
  static const beigeShade30 = Color(0xFF997100);
  static const beigeTint90 = Color(0xFFFCF5DF);

  // ========================================
  // 🔄 COMPONENT HELPERS
  // ========================================

  // Note: greyCCC removed - use grey80 instead (same color)

  // ========================================
  // 📱 MISSING COLORS (Re-added for compatibility)
  // ========================================

  /// Navigation colors
  static const navGrey = Color(0xFF9E9E9E);
  static const whiteF6  = Color(0xFFF6F6F6);
  // Note: grey20 removed - use black333 instead (same color)

  /// Text and UI colors
  static const lightBlack = Color(0xFF666666);
  static const linkBlue = Color(0xFF007BFF);
  static const black333 = Color(0xFF333333); // Also used as grey20

  /// OTP and form colors
  static const blueShade50 = Color(0x801F2A7D);

  /// Divider and border colors
  static const lightDivider = Color(0xFFE6E6E6);

  /// File picker colors
  static const initialsListColor = Color(0xFF428BCA);
  // Note: pickFileDotColor removed - use grey80 instead (same color)
  static const pickFileBoxColor = Color(0xFFF8F9FA);
  static const patientInitialColor = Color(0xFF3498DB);

  // Note: settingScreenDrAppointmentLabelColor removed - use grey777 instead (same color)

  /// Gradient colors for time slots
  static const morningTopGradient = Color(0xFFFFDF6B);
  static const morningBottomGradient = Color(0xFFFFC107);
  static const eveningTopGradient = Color(0xFF6A5ACD);
  static const eveningBottomGradient = Color(0xFF4A90E2);
}

// ========================================
// 📝 REMOVED UNUSED COLORS
// ========================================
// The following colors were removed as they are not used anywhere in the codebase:
//
// 🔵 Blues: blueCB7, blueE88, blue04E, blueShade50, blueShade60, blueShade40, 
//          blueShade30, blueShade20, blueShade10, blueBg, linkBlue, initialsListColor,
//          pickFileBoxColor, pickFileDotColor, patientInitialColor, oceanShade11,
//          oceanShade10, oceanTint60, oceanTint70, oceanTint80, oceanTint90, oceanTint95
//
// 🟢 Greens: green257, greenSort, green8AF, greenShade30, greenShade20, greenShade10,
//           greenTint10, greenTint80, greenTint90, greenTint97
//
// 🟡 Yellows: yellow, yellowTint10, yellowTint20, yellow725, yellowActive
//
// 🟠 Oranges: beige20, beigeShade10, beige, beigeTint70, beigeTint80
//
// 🔴 Reds: redShade10, red, redTint10, redTint70, redTint80, redTint90, redTint40, redTint50
//
// 🟣 Others: cyanShade20, cyanShade10, cyanTint80, cyanTint85, cyanTint90, navyBlue,
//           bluishGrey, inProgressColor, lightNavyBlue, lightOrange, todoDesc,
//           disableColor, lightBlack, lightDivider, settingScreenDrAppointmentLabelColor,
//           morningTopGradient, morningBottomGradient, eveningTopGradient, eveningBottomGradient
//
// 🔲 Blacks/Grays: black333, black12, black24, grey20, grey25, grey30, grey50, grey77,
//                 grey65, grey70, grey95, grey96, grey97, grey98, navGrey, whiteF5
//
// Total removed: ~65 unused colors
// This cleanup makes the color system much more maintainable!