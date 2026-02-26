import 'dart:io';

import 'package:dio/dio.dart';
import 'package:recovery_consultation_app/data/api/request/add_questionnaires_request.dart';
import 'package:recovery_consultation_app/data/api/request/add_review_request.dart';
import 'package:recovery_consultation_app/data/api/request/appointment_booking_request.dart';
import 'package:recovery_consultation_app/data/api/request/appointment_update_request.dart';
import 'package:recovery_consultation_app/data/api/request/forgot_password_request.dart';
import 'package:recovery_consultation_app/data/api/request/login_request.dart';
import 'package:recovery_consultation_app/data/api/request/otp_verification_request.dart';
import 'package:recovery_consultation_app/data/api/request/resend_otp_request.dart';
import 'package:recovery_consultation_app/data/api/request/reset_password_request.dart';
import 'package:recovery_consultation_app/data/api/request/sign_up_request.dart';
import 'package:recovery_consultation_app/data/api/request/update_profile_request.dart';
import 'package:recovery_consultation_app/data/api/request/create_prescription_request.dart';
import 'package:recovery_consultation_app/data/api/request/create_ad_banner_request.dart';
import 'package:recovery_consultation_app/data/api/request/update_ad_banner_request.dart';
import 'package:recovery_consultation_app/data/api/request/create_product_request.dart';
import 'package:recovery_consultation_app/data/api/request/update_product_request.dart';
import 'package:recovery_consultation_app/data/api/response/add_questionnaires_response.dart';
import 'package:recovery_consultation_app/data/api/response/prescription_response.dart';
import 'package:recovery_consultation_app/data/api/response/review_response.dart';
import 'package:recovery_consultation_app/data/api/response/ad_banner_response.dart';
import 'package:recovery_consultation_app/data/api/response/product_response.dart';
import 'package:recovery_consultation_app/data/api/response/appointment_booking_response.dart';
import 'package:recovery_consultation_app/data/api/response/forgot_password_response.dart';
import 'package:recovery_consultation_app/data/api/response/get_user_response.dart';
import 'package:recovery_consultation_app/data/api/response/login_response.dart';
import 'package:recovery_consultation_app/data/api/response/match_doctors_list_response.dart';
import 'package:recovery_consultation_app/data/api/response/otp_verification_response.dart';
import 'package:recovery_consultation_app/data/api/response/resend_otp_response.dart';
import 'package:recovery_consultation_app/data/api/response/reset_password_response.dart';
import 'package:recovery_consultation_app/data/api/response/sign_up_response.dart';
import 'package:recovery_consultation_app/data/api/response/update_profile_response.dart';
import 'package:recovery_consultation_app/data/api/response/file_response.dart';
import 'package:recovery_consultation_app/data/api/response/user_response.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/retrofit.dart' as retrofit;
import '../response/base_response.dart';
import '../response/appointment_response.dart';

part 'api_client_type.g.dart';

@retrofit.RestApi()
abstract class APIClientType {
  factory APIClientType(Dio dio, {String baseUrl}) = _APIClientType;

  @retrofit.POST('/api/register')
  Future<BaseResponse<SignUpResponse>> signUp(
    @retrofit.Body() SignUpRequest request,
  );

  @retrofit.POST('/api/email/verify')
  Future<BaseResponse<OTPVerificationResponse>> verifyEmail(
    @retrofit.Body() OPTVerificationRequest request,
  );

  @retrofit.POST('/api/email/resend')
  Future<ResendOtpResponse> resendOtp(
    @retrofit.Body() ResendOtpRequest request,
  );

  @retrofit.POST('/api/login')
  Future<BaseResponse<LoginResponse>> login(
    @retrofit.Body() LoginRequest request,
  );

  @retrofit.POST('/api/forgot-password')
  Future<ForgotPasswordResponse> forgotPassword(
    @retrofit.Body() ForgotPasswordRequest request,
  );

  @retrofit.POST('/api/reset-password')
  Future<ResetPasswordResponse> resetPassword(
    @retrofit.Body() ResetPasswordRequest request,
  );

  @retrofit.POST('/api/update-profile')
  Future<BaseResponse<UpdateProfileResponse>> updateProfile(
    @retrofit.Body() UpdateProfileRequest request,
  );

  @retrofit.GET('/api/user')
  Future<BaseResponse<GetUserResponse>> getUser();

  @retrofit.POST('/api/add-questionnaires')
  Future<BaseResponse<AddQuestionnairesResponse>> addQuestionnaires(
    @retrofit.Body() AddQuestionnairesRequest request,
  );

  @retrofit.POST('/api/add-reviews')
  Future<BaseResponse<ReviewResponse>> addReview(
    @retrofit.Body() AddReviewRequest request,
  );

  @retrofit.GET('/api/match-doctors-list')
  Future<BaseResponse<MatchDoctorsListResponse?>> getMatchDoctorsList();

  @retrofit.GET('/api/doctors-list')
  Future<BasePagingResponse<UserResponse>> getDoctorsList({
    @retrofit.Query('specialization') String? specialization,
    @retrofit.Query('page') int? page,
    @retrofit.Query('limit') int? limit,
  });

  @retrofit.GET('/api/user-detail')
  Future<BaseResponse<UserResponse?>> getUserDetailById({
    @retrofit.Query('id') required int userId,
  });

  @retrofit.POST('/api/appointment-booking')
  Future<BaseResponse<AppointmentBookingResponse>> bookAppointment(
    @retrofit.Body() AppointmentBookingRequest request,
  );

  @retrofit.GET('/api/appointments')
  Future<BasePagingResponse<AppointmentResponse>> getAppointmentsList({
    @retrofit.Query('type') String? type,
    @retrofit.Query('status') String? status,
    @retrofit.Query('doc_user_id') int? doctorUserId,
    @retrofit.Query('pat_user_id') int? patientUserId,
    @retrofit.Query('date_from') String? dateFrom,
    @retrofit.Query('date_to') String? dateTo,
    @retrofit.Query('page') int? page,
    @retrofit.Query('limit') int? limit,
  });

  @retrofit.GET('/api/appointment-detail')
  Future<BaseResponse<AppointmentResponse>> getAppointmentDetail({
    @retrofit.Query('appointment_id') required int appointmentId,
  });

  @retrofit.POST('/api/appointment-update')
  Future<BaseResponse<AppointmentResponse>> updateAppointment(
    @retrofit.Body() AppointmentUpdateRequest request,
  );

  @retrofit.GET('/api/admin/users-list')
  Future<BasePagingResponse<GetUserResponse>> getUserListForAdmin({
    @retrofit.Query('specialization') String? specialization,
    @retrofit.Query('type') String? type,
    @retrofit.Query('page') int? page,
    @retrofit.Query('limit') int? limit,
  });

  @retrofit.GET('/api/patients')
  Future<BasePagingResponse<AppointmentResponse>> getPatientsList({
    @retrofit.Query('page') int? page,
    @retrofit.Query('limit') int? limit,
  });

  @retrofit.GET('/api/patient-history')
  Future<BasePagingResponse<AppointmentResponse>> getPatientHistory({
    @retrofit.Query('patient_id') required int patientId,
    @retrofit.Query('page') int? page,
    @retrofit.Query('limit') int? limit,
  });

  @retrofit.POST('/api/admin/update-user')
  Future<BaseResponse<UserResponse>> updateUser(
    @retrofit.Body() UpdateProfileRequest request,
  );

  @retrofit.MultiPart()
  @retrofit.POST('/api/upload-file')
  Future<BaseResponse<FileResponse>> uploadFile(
    @retrofit.Part(name: 'file') File file,
    @retrofit.Part(name: 'directory') String directory,
  );

  @retrofit.POST('/api/doctor/prescriptions')
  Future<BaseResponse<PrescriptionResponse>> createPrescription(
    @retrofit.Body() CreatePrescriptionRequest request,
  );

  @retrofit.POST('/api/admin/ad-banners')
  Future<BaseResponse<AdBannerResponse>> createAdBanner(
    @retrofit.Body() CreateAdBannerRequest request,
  );

  @retrofit.GET('/api/admin/ad-banners')
  Future<BasePagingResponse<AdBannerResponse>> getAdBannersList({
    @retrofit.Query('limit') int? limit,
    @retrofit.Query('page') int? page,
    @retrofit.Query('date_from') String? dateFrom,
    @retrofit.Query('date_to') String? dateTo,
  });

  @retrofit.PUT('/api/admin/ad-banners/{id}')
  Future<BaseResponse<AdBannerResponse>> updateAdBanner(
    @retrofit.Path('id') int id,
    @retrofit.Body() UpdateAdBannerRequest request,
  );

  @retrofit.POST('/api/admin/products')
  Future<BaseResponse<ProductResponse>> createProduct(
    @retrofit.Body() CreateProductRequest request,
  );

  @retrofit.GET('/api/admin/products')
  Future<BasePagingResponse<ProductResponse>> getProductsList({
    @retrofit.Query('limit') int? limit,
    @retrofit.Query('page') int? page,
    @retrofit.Query('category_id') int? categoryId,
    @retrofit.Query('availability_status') String? availabilityStatus,
  });

  @retrofit.PUT('/api/admin/products/{id}')
  Future<BaseResponse<ProductResponse>> updateProduct(
    @retrofit.Path('id') int id,
    @retrofit.Body() UpdateProductRequest request,
  );

  @retrofit.DELETE('/api/admin/products/{id}')
  Future<BaseResponse<dynamic>> deleteProduct(
    @retrofit.Path('id') int id,
  );

  @retrofit.GET('/api/features')
  Future<BaseListResponse<ProductResponse>> getFavorites();

  @retrofit.GET('/api/products')
  Future<BasePagingResponse<ProductResponse>> getProducts({
    @retrofit.Query('limit') int? limit,
    @retrofit.Query('category_id') int? categoryId,
    @retrofit.Query('search') String? search,
    @retrofit.Query('sort_by') String? sortBy,
    @retrofit.Query('sort_order') String? sortOrder,
  });

  @retrofit.GET('/api/products/{id}')
  Future<BaseResponse<ProductResponse>> getProductById(
    @retrofit.Path('id') int id,
  );

  @retrofit.POST('/api/features/{id}')
  Future<BaseResponse<dynamic>> addToFeatures(
    @retrofit.Path('id') int productId,
  );
}
