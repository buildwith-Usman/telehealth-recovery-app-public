import 'package:recovery_consultation_app/data/api/request/add_review_request.dart';
import 'package:recovery_consultation_app/data/api/response/review_response.dart';

abstract class ReviewDatasource {
  Future<ReviewResponse?> addReview(AddReviewRequest request);
}
