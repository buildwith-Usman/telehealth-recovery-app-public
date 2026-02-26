import 'base_entity.dart';

class DoctorLanguageEntity extends BaseEntity {
  final int userId;
  final String language;

  const DoctorLanguageEntity({
    required super.id,
    required this.userId,
    required this.language,
    super.createdAt,
    super.updatedAt,
  });
}
