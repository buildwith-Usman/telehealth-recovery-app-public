import 'base_entity.dart';

class DoctorReviewEntity extends BaseEntity {
  final int? userId;
  final int? reviewerId;
  final int? rating;
  final String? review; // Review comment text
  final String? appointmentId;

  const DoctorReviewEntity({
    required super.id,
    required this.userId,
    required this.reviewerId,
    required this.rating,
    this.review,
    this.appointmentId,
    super.createdAt,
    super.updatedAt,
  });

}
