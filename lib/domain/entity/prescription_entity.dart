/// Prescription Entity - Represents a medical prescription from a doctor
class PrescriptionEntity {
  final String id;
  final String appointmentId;
  final String doctorId;
  final String doctorName;
  final String? doctorImageUrl;
  final String patientId;
  final String patientName;
  final DateTime prescriptionDate;
  final List<PrescribedMedicineEntity> medicines;
  final String? notes;
  final String? diagnosis;
  final String? prescriptionImageUrl; // For uploaded prescription image

  const PrescriptionEntity({
    required this.id,
    required this.appointmentId,
    required this.doctorId,
    required this.doctorName,
    this.doctorImageUrl,
    required this.patientId,
    required this.patientName,
    required this.prescriptionDate,
    required this.medicines,
    this.notes,
    this.diagnosis,
    this.prescriptionImageUrl,
  });

  /// Get total number of medicines prescribed
  int get totalMedicines => medicines.length;

  /// Check if prescription has any medicines
  bool get hasMedicines => medicines.isNotEmpty;

  /// Get list of medicine IDs for easy lookup
  List<String> get medicineIds => medicines.map((m) => m.medicineId).toList();
}

/// Prescribed Medicine Entity - Represents a medicine in a prescription
class PrescribedMedicineEntity {
  final String id;
  final String medicineId;
  final String medicineName;
  final String? medicineImage;
  final String? manufacturer;
  final double? unitPrice;
  final String dosage; // e.g., "500mg"
  final String frequency; // e.g., "Twice daily", "Three times a day"
  final String duration; // e.g., "7 days", "2 weeks"
  final String? instructions; // e.g., "Take after meals"
  final int quantity; // Number of units/tablets prescribed
  final bool isAvailable; // Whether medicine is available in pharmacy

  const PrescribedMedicineEntity({
    required this.id,
    required this.medicineId,
    required this.medicineName,
    this.medicineImage,
    this.manufacturer,
    this.unitPrice,
    required this.dosage,
    required this.frequency,
    required this.duration,
    this.instructions,
    required this.quantity,
    this.isAvailable = true,
  });

  /// Get total price for this medicine
  double get totalPrice {
    if (unitPrice == null) return 0.0;
    return (unitPrice! * quantity);
  }

  /// Format dosage display
  String get dosageDisplay => dosage;

  /// Format frequency and duration display
  String get scheduleDisplay => '$frequency for $duration';

  /// Get full instruction text
  String get fullInstructions {
    final parts = <String>[];
    parts.add(dosageDisplay);
    parts.add(scheduleDisplay);
    if (instructions != null && instructions!.isNotEmpty) {
      parts.add(instructions!);
    }
    return parts.join(' • ');
  }
}
