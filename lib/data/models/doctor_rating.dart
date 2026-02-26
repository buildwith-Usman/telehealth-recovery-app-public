class DoctorRating {
  final String appointmentId;
  final String doctorId;
  final String doctorName;
  final int rating;
  final String review;
  final DateTime createdAt;

  const DoctorRating({
    required this.appointmentId,
    required this.doctorId,
    required this.doctorName,
    required this.rating,
    required this.review,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'appointmentId': appointmentId,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'rating': rating,
      'review': review,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory DoctorRating.fromJson(Map<String, dynamic> json) {
    return DoctorRating(
      appointmentId: json['appointmentId'] ?? '',
      doctorId: json['doctorId'] ?? '',
      doctorName: json['doctorName'] ?? '',
      rating: json['rating'] ?? 0,
      review: json['review'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  @override
  String toString() {
    return 'DoctorRating(appointmentId: $appointmentId, doctorName: $doctorName, rating: $rating, review: $review)';
  }
}