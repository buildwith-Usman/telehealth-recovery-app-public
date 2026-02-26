import 'package:json_annotation/json_annotation.dart';

part 'review_response.g.dart';

@JsonSerializable()
class ReviewResponse {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'sender_id')
  final int? senderId;

  @JsonKey(name: 'receiver_id')
  final int? receiverId;

  @JsonKey(name: 'appointment_id')
  final int? appointmentId;

  @JsonKey(name: 'rating')
  final int? rating;

  @JsonKey(name: 'message')
  final String? message;

  @JsonKey(name: 'deleted_at')
  final String? deletedAt;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  ReviewResponse({
    required this.id,
    this.senderId,
    this.receiverId,
    this.appointmentId,
    this.rating,
    this.message,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory ReviewResponse.fromJson(Map<String, dynamic> json) =>
      _$ReviewResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewResponseToJson(this);
}