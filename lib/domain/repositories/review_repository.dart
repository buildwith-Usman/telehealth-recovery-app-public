import 'package:recovery_consultation_app/data/api/request/add_review_request.dart';
import 'package:recovery_consultation_app/domain/entity/doctor_review_entity.dart';

abstract class ReviewRepository {
  Future<DoctorReviewEntity?> addReview(AddReviewRequest request);
}
