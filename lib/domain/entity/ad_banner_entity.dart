import 'package:recovery_consultation_app/domain/entity/base_entity.dart';
import 'package:recovery_consultation_app/domain/entity/user_entity.dart';

/// Ad Banner Entity - Represents admin ad banner data from API
class AdBannerEntity extends BaseEntity {
  final String title;
  final int imageId;
  final String startDate;
  final String? endDate;
  final String status;
  final int createdBy;
  final String? imageUrl;
  final UserEntity? creator;

  const AdBannerEntity({
    required super.id,
    required this.title,
    required this.imageId,
    required this.startDate,
    this.endDate,
    required this.status,
    required this.createdBy,
    this.imageUrl,
    this.creator,
    super.createdAt,
    super.updatedAt,
  });

  /// Helper method to check if banner is active
  bool get isActive => status.toLowerCase() == 'active';

  /// Helper method to check if banner is inactive
  bool get isInactive => status.toLowerCase() == 'inactive';
}
