class RatingStatistics {
  final double averageRating;
  final int totalReviews;
  final int fiveStarCount;
  final int fourStarCount;
  final int threeStarCount;
  final int twoStarCount;
  final int oneStarCount;

  const RatingStatistics({
    required this.averageRating,
    required this.totalReviews,
    required this.fiveStarCount,
    required this.fourStarCount,
    required this.threeStarCount,
    required this.twoStarCount,
    required this.oneStarCount,
  });

  /// Calculate percentage for each star rating
  double getFiveStarPercentage() =>
      totalReviews > 0 ? (fiveStarCount / totalReviews) : 0.0;
  double getFourStarPercentage() =>
      totalReviews > 0 ? (fourStarCount / totalReviews) : 0.0;
  double getThreeStarPercentage() =>
      totalReviews > 0 ? (threeStarCount / totalReviews) : 0.0;
  double getTwoStarPercentage() =>
      totalReviews > 0 ? (twoStarCount / totalReviews) : 0.0;
  double getOneStarPercentage() =>
      totalReviews > 0 ? (oneStarCount / totalReviews) : 0.0;

  factory RatingStatistics.fromJson(Map<String, dynamic> json) {
    return RatingStatistics(
      averageRating: (json['averageRating'] ?? 0.0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      fiveStarCount: json['fiveStarCount'] ?? 0,
      fourStarCount: json['fourStarCount'] ?? 0,
      threeStarCount: json['threeStarCount'] ?? 0,
      twoStarCount: json['twoStarCount'] ?? 0,
      oneStarCount: json['oneStarCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'averageRating': averageRating,
      'totalReviews': totalReviews,
      'fiveStarCount': fiveStarCount,
      'fourStarCount': fourStarCount,
      'threeStarCount': threeStarCount,
      'twoStarCount': twoStarCount,
      'oneStarCount': oneStarCount,
    };
  }

  @override
  String toString() {
    return 'RatingStatistics(averageRating: $averageRating, totalReviews: $totalReviews)';
  }
}
