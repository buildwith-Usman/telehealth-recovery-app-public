// ================================
// DOMAIN USE CASE IMPORTS
// ================================

// Authentication Use Cases
import 'package:recovery_consultation_app/domain/usecase/add_questionnaires_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/add_review_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/admin_update_profile_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/create_ad_banner_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/create_product_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/delete_product_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/get_ad_banners_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/get_favorites_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/get_products_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/update_ad_banner_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/update_product_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/get_featured_products_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/get_medicines_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/get_paginated_admin_user_list_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/get_pharmacy_banners_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/get_pharmacy_products_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/get_product_by_id_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/add_to_features_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/load_questionnaire_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/login_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/login_with_google_usecase.dart';
import 'package:recovery_consultation_app/domain/usecase/sign_up_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/forgot_password_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/otp_verification_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/resend_otp_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/create_password_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/reset_password_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/update_profile_use_case.dart';

// Preferences Use Cases
import 'package:recovery_consultation_app/domain/usecase/get_has_onboarding_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/set_has_onboarding_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/get_access_token_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/set_access_token_use_case.dart';

// Repository Module
import '../domain/usecase/get_user_use_case.dart';
import '../domain/usecase/get_paginated_doctors_list_use_case.dart';
import '../domain/usecase/get_appointments_list_use_case.dart';
import '../domain/usecase/get_paginated_appointments_list_use_case.dart';
import '../domain/usecase/get_paginated_patients_list_use_case.dart';
import '../domain/usecase/get_patient_history_use_case.dart';
import '../domain/usecase/create_prescription_use_case.dart';
import 'repository_module.dart';

/// Use Case Module - Dependency Injection for Domain Use Cases
///
/// This mixin provides access to all domain use cases organized by category.
/// Each use case is lazily instantiated with the appropriate repository dependency.
///
/// Categories:
/// - Authentication Use Cases: login, signup, password management, OTP verification
/// - Preferences Use Cases: onboarding status, token management
///
/// Usage: Mix this into your dependency injection class that extends RepositoryModule
mixin UseCaseModule on RepositoryModule {
  // ================================
  // AUTHENTICATION USE CASES
  // ================================

  /// Handles user login with email and password
  LoginUseCase get loginUseCase {
    return LoginUseCase(repository: authRepository);
  }

  /// Handles Google OAuth login
  LoginWithGoogleUseCase get loginWithGoogleUseCase {
    return LoginWithGoogleUseCase(repository: authRepository);
  }

  /// Handles user registration/signup
  SignUpUseCase get signUpUseCase {
    return SignUpUseCase(repository: authRepository);
  }

  /// Handles forgot password request
  ForgotPasswordUseCase get forgotPasswordUseCase {
    return ForgotPasswordUseCase(repository: authRepository);
  }

  /// Handles OTP verification for various flows
  OtpVerificationUseCase get otpVerificationUseCase {
    return OtpVerificationUseCase(repository: authRepository);
  }

  /// Handles resending OTP codes
  ResendOtpUseCase get resendOtpUseCase {
    return ResendOtpUseCase(repository: authRepository);
  }

  /// Handles creating/updating user password
  CreatePasswordUseCase get createPasswordUseCase {
    return CreatePasswordUseCase(repository: authRepository);
  }

  /// Handles resetting user password with reset code
  ResetPasswordUseCase get resetPasswordUseCase {
    return ResetPasswordUseCase(repository: authRepository);
  }

  /// Handles updating user profile information
  UpdateProfileUseCase get updateProfileUseCase {
    return UpdateProfileUseCase(repository: userRepository);
  }

  /// Handles getting current user information
  GetUserUseCase get getUserUseCase {
    return GetUserUseCase(repository: userRepository);
  }

  /// Handles submitting questionnaire responses
  AddQuestionnairesUseCase get addQuestionnairesUseCase {
    return AddQuestionnairesUseCase(repository: userRepository);
  }

  /// Handles loading questionnaire data
  LoadQuestionnaireUseCase get loadQuestionnaireUseCase {
    return LoadQuestionnaireUseCase(repository: questioniareRepository);
  }

  /// Handles adding review/rating for a doctor after consultation
  AddReviewUseCase get addReviewUseCase {
    return AddReviewUseCase(repository: reviewRepository);
  }

  // ================================
  // PREFERENCES USE CASES
  // ================================

  /// Sets onboarding completion status
  SetHasOnboardingUseCase get setHasOnboardingUseCase {
    return SetHasOnboardingUseCase(repository: preferencesRepository);
  }

  /// Gets onboarding completion status
  GetHasOnboardingUseCase get getHasOnboardingUseCase {
    return GetHasOnboardingUseCase(repository: preferencesRepository);
  }

  /// Gets stored access token
  GetAccessTokenUseCase get getAccessTokenUseCase {
    return GetAccessTokenUseCase(repository: preferencesRepository);
  }

  /// Sets/stores access token
  SetAccessTokenUseCase get setAccessTokenUseCase {
    return SetAccessTokenUseCase(repository: preferencesRepository);
  }

  // ================================
  // SPECIALIST/DOCTOR USE CASES
  // ================================

  /// Gets paginated doctors list with filtering
  GetPaginatedDoctorsListUseCase get getPaginatedDoctorsListUseCase {
    return GetPaginatedDoctorsListUseCase(repository: specialistRepository);
  }

  /// Creates prescription for an appointment
  CreatePrescriptionUseCase get createPrescriptionUseCase {
    return CreatePrescriptionUseCase(repository: specialistRepository);
  }

  // ================================
  // APPOINTMENTS USE CASES
  // ================================

  /// Gets appointments list with filtering
  GetAppointmentsListUseCase get getAppointmentsListUseCase {
    return GetAppointmentsListUseCase(repository: appointmentRepository);
  }

  /// Gets paginated appointments list with filtering and pagination
  GetPaginatedAppointmentsListUseCase get getPaginatedAppointmentsListUseCase {
    return GetPaginatedAppointmentsListUseCase(repository: appointmentRepository);
  }

  // ================================
  // PATIENT USE CASES
  // ================================

  /// Gets paginated patients list with pagination
  GetPaginatedPatientsListUseCase get getPaginatedPatientsListUseCase {
    return GetPaginatedPatientsListUseCase(repository: patientRepository);
  }

  /// Gets patient history (appointments) for a specific patient
  GetPatientHistoryUseCase get getPatientHistoryUseCase {
    return GetPatientHistoryUseCase(repository: patientRepository);
  }

  GetPaginatedAdminUserListUseCase get getPaginatedAdminUserListUseCase {
    return GetPaginatedAdminUserListUseCase(repository: adminRepository);
  }

  AdminUpdateProfileUseCase get adminUpdateProfileUserCase {
    return AdminUpdateProfileUseCase(repository: adminRepository);
  }

  /// Creates ad banner
  CreateAdBannerUseCase get createAdBannerUseCase {
    return CreateAdBannerUseCase(repository: adminRepository);
  }

  CreateProductUseCase get createProductUseCase {
    return CreateProductUseCase(adminRepository: adminRepository);
  }

  /// Gets ad banners list
  GetAdBannersUseCase get getAdBannersUseCase {
    return GetAdBannersUseCase(repository: adminRepository);
  }

  /// Gets products list
  GetProductsUseCase get getProductsUseCase {
    return GetProductsUseCase(repository: adminRepository);
  }

  /// Updates product
  UpdateProductUseCase get updateProductUseCase {
    return UpdateProductUseCase(repository: adminRepository);
  }

  /// Deletes product
  DeleteProductUseCase get deleteProductUseCase {
    return DeleteProductUseCase(repository: adminRepository);
  }

  /// Gets favorites (featured products)
  GetFavoritesUseCase get getFavoritesUseCase {
    return GetFavoritesUseCase(repository: adminRepository);
  }

  /// Updates ad banner
  UpdateAdBannerUseCase get updateAdBannerUseCase {
    return UpdateAdBannerUseCase(repository: adminRepository);
  }

  // ================================
  // PHARMACY USE CASES
  // ================================

  /// Gets pharmacy promotional banners
  GetPharmacyBannersUseCase get getPharmacyBannersUseCase {
    return GetPharmacyBannersUseCase(repository: pharmacyRepository);
  }

  /// Gets featured products from pharmacy
  GetFeaturedProductsUseCase get getFeaturedProductsUseCase {
    return GetFeaturedProductsUseCase(repository: pharmacyRepository);
  }

  /// Gets medicines list from pharmacy
  GetMedicinesUseCase get getMedicinesUseCase {
    return GetMedicinesUseCase(repository: pharmacyRepository);
  }

  /// Gets products list from pharmacy with filters and search
  GetPharmacyProductsUseCase get getPharmacyProductsUseCase {
    return GetPharmacyProductsUseCase(repository: pharmacyRepository);
  }

  /// Gets product detail by ID
  GetProductByIdUseCase get getProductByIdUseCase {
    return GetProductByIdUseCase(repository: pharmacyRepository);
  }

  /// Adds product to features (favorites)
  AddToFeaturesUseCase get addToFeaturesUseCase {
    return AddToFeaturesUseCase(repository: pharmacyRepository);
  }
}
