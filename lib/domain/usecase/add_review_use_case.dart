import 'package:recovery_consultation_app/data/api/request/add_review_request.dart';
import 'package:recovery_consultation_app/domain/entity/doctor_review_entity.dart';
import 'package:recovery_consultation_app/domain/repositories/review_repository.dart';
import 'package:recovery_consultation_app/domain/usecase/base_usecase.dart';

class AddReviewUseCase
    implements ParamUseCase<DoctorReviewEntity?, AddReviewRequest> {
  final ReviewRepository repository;

  AddReviewUseCase({required this.repository});

  @override
  Future<DoctorReviewEntity?> execute(AddReviewRequest request) async {
    return await repository.addReview(request);
  }
}
