import 'package:json_annotation/json_annotation.dart';

part 'add_review_request.g.dart';

@JsonSerializable()
class AddReviewRequest {
  @JsonKey(name: 'receiver_id')
  final int receiverId;

  @JsonKey(name: 'rating')
  final int rating;

  @JsonKey(name: 'appointment_id')
  final int appointmentId;

  @JsonKey(name: 'message')
  final String? message;

  AddReviewRequest({
    required this.receiverId,
    required this.rating,
    required this.appointmentId,
    this.message,
  });

  factory AddReviewRequest.fromJson(Map<String, dynamic> json) => _$AddReviewRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AddReviewRequestToJson(this);
}
