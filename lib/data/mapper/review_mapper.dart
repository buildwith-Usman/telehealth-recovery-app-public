import 'package:recovery_consultation_app/data/api/response/review_response.dart';
import 'package:recovery_consultation_app/domain/entity/doctor_review_entity.dart';


class ReviewMapper {

  static DoctorReviewEntity toReviewEntity(
    ReviewResponse response,
  ) {
    return DoctorReviewEntity(
      id: response.id,
      userId: response.receiverId, // receiver_id maps to userId (doctor receiving review)
      reviewerId: response.senderId, // sender_id maps to reviewerId (person writing review)
      rating: response.rating,
      review: response.message, // message maps to review
      appointmentId: response.appointmentId?.toString(), // Convert int to String for entity
      createdAt: response.createdAt,
      updatedAt: response.updatedAt,
    );
  }
}
