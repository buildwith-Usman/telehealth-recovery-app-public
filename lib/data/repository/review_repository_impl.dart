import 'package:recovery_consultation_app/data/api/request/add_review_request.dart';
import 'package:recovery_consultation_app/data/datasource/review/review_datasource.dart';
import 'package:recovery_consultation_app/data/mapper/review_mapper.dart';
import 'package:recovery_consultation_app/domain/entity/doctor_review_entity.dart';
import 'package:recovery_consultation_app/domain/repositories/review_repository.dart';
import '../api/response/error_response.dart';
import '../../domain/entity/error_entity.dart';
import '../mapper/exception_mapper.dart';

class ReviewRepositoryImpl extends ReviewRepository {
  ReviewRepositoryImpl({required this.reviewDatasource});

  final ReviewDatasource reviewDatasource;

  @override
  Future<DoctorReviewEntity?> addReview(AddReviewRequest request) async {
    try {
      final response = await reviewDatasource.addReview(request);
      if (response == null) {
        throw BaseErrorEntity.noData();
      } else {
        final reviewEntity = ReviewMapper.toReviewEntity(response);
        return reviewEntity;
      }
    } on BaseErrorResponse catch (error) {
      throw ExceptionMapper.toBaseErrorEntity(error);
    }
  }
}
