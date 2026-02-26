import 'package:json_annotation/json_annotation.dart';

part 'prescription_response.g.dart';

@JsonSerializable(explicitToJson: true)
class PrescriptionResponse {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'appointment_id')
  final int appointmentId;

  @JsonKey(name: 'prescription_date')
  final String prescriptionDate;

  @JsonKey(name: 'notes')
  final String notes;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  PrescriptionResponse({
    required this.id,
    required this.appointmentId,
    required this.prescriptionDate,
    required this.notes,
    this.createdAt,
    this.updatedAt,
  });

  // Factory method for JSON deserialization
  factory PrescriptionResponse.fromJson(Map<String, dynamic> json) =>
      _$PrescriptionResponseFromJson(json);

  // Method for JSON serialization
  Map<String, dynamic> toJson() => _$PrescriptionResponseToJson(this);
}
