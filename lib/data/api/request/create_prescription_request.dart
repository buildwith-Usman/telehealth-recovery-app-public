import 'package:json_annotation/json_annotation.dart';

part 'create_prescription_request.g.dart';

@JsonSerializable()
class CreatePrescriptionRequest {
  @JsonKey(name: 'appointment_id')
  final int appointmentId;

  @JsonKey(name: 'prescription_date')
  final String prescriptionDate;

  @JsonKey(name: 'notes')
  final String notes;

  CreatePrescriptionRequest({
    required this.appointmentId,
    required this.prescriptionDate,
    required this.notes,
  });

  // Factory method for JSON deserialization
  factory CreatePrescriptionRequest.fromJson(Map<String, dynamic> json) =>
      _$CreatePrescriptionRequestFromJson(json);

  // Method for JSON serialization
  Map<String, dynamic> toJson() => _$CreatePrescriptionRequestToJson(this);
}
