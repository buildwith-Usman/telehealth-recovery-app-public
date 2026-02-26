class ConsultationNotes {
  final String appointmentId;
  final String doctorId;
  final String patientId;
  final String patientName;
  final String notes;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const ConsultationNotes({
    required this.appointmentId,
    required this.doctorId,
    required this.patientId,
    required this.patientName,
    required this.notes,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'appointmentId': appointmentId,
      'doctorId': doctorId,
      'patientId': patientId,
      'patientName': patientName,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory ConsultationNotes.fromJson(Map<String, dynamic> json) {
    return ConsultationNotes(
      appointmentId: json['appointmentId'] ?? '',
      doctorId: json['doctorId'] ?? '',
      patientId: json['patientId'] ?? '',
      patientName: json['patientName'] ?? '',
      notes: json['notes'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
    );
  }

  ConsultationNotes copyWith({
    String? appointmentId,
    String? doctorId,
    String? patientId,
    String? patientName,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ConsultationNotes(
      appointmentId: appointmentId ?? this.appointmentId,
      doctorId: doctorId ?? this.doctorId,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'ConsultationNotes(appointmentId: $appointmentId, doctorId: $doctorId, patientName: $patientName, notes: ${notes.length} chars, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is ConsultationNotes &&
        other.appointmentId == appointmentId &&
        other.doctorId == doctorId &&
        other.patientId == patientId &&
        other.patientName == patientName &&
        other.notes == notes &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return appointmentId.hashCode ^
        doctorId.hashCode ^
        patientId.hashCode ^
        patientName.hashCode ^
        notes.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}