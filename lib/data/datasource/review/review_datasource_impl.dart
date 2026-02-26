import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:recovery_consultation_app/data/api/api_client/api_client_type.dart';
import 'package:recovery_consultation_app/data/api/request/add_review_request.dart';
import 'package:recovery_consultation_app/data/api/response/error_response.dart';
import 'package:recovery_consultation_app/data/api/response/review_response.dart';
import 'package:recovery_consultation_app/data/datasource/review/review_datasource.dart';

class ReviewDatasourceImpl implements ReviewDatasource {
  ReviewDatasourceImpl({
    required this.apiClient,
  });

  final APIClientType apiClient;

  @override
  Future<ReviewResponse?> addReview(AddReviewRequest request) async {
    try {
      debugPrint('🔍 REVIEW DATASOURCE DEBUG: About to call add review API');
      debugPrint('🔍 REVIEW DATASOURCE DEBUG: Request - receiver_id: ${request.receiverId}');
      debugPrint('🔍 REVIEW DATASOURCE DEBUG: Request - rating: ${request.rating}');
      debugPrint('🔍 REVIEW DATASOURCE DEBUG: Request - appointment_id: ${request.appointmentId}');
      debugPrint('🔍 REVIEW DATASOURCE DEBUG: Request - message: ${request.message}');

      final response = await apiClient.addReview(request);

      debugPrint('🔍 REVIEW DATASOURCE DEBUG: Add review API call completed successfully');
      debugPrint('🔍 REVIEW DATASOURCE DEBUG: Response data: ${response.data != null}');
      return response.data;
    } on DioException catch (error) {
      debugPrint('❌ REVIEW DATASOURCE DEBUG: DioException caught - will be handled by BaseErrorResponse');
      throw BaseErrorResponse.fromDioException(error);
    }
  }
}
