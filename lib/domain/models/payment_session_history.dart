class PaymentSessionHistoryData {
  final String? id; // Optional unique ID for database or navigation
  final String? therapistName;
  final DateTime? sessionDate;
  final String? sessionDuration;
  final int? amount;
  final String? paymentStatus; // 'completed', 'pending', 'failed', etc.

  /// Optional additional metadata
  final String? patientName;
  final String? sessionType; // e.g. "Online", "In-Person"
  final String? notes;
  final String? status;

  const PaymentSessionHistoryData({
    this.id = '',
    this.therapistName,
    this.sessionDate,
    this.sessionDuration,
    this.amount,
    this.paymentStatus,
    this.patientName,
    this.sessionType,
    this.notes,
    this.status
  });
}
