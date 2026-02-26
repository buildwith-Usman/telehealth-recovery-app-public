/// BaseEntity: common fields for all entities
abstract class BaseEntity {
  final int id;
  final String? createdAt;
  final String? updatedAt;

  const BaseEntity({
    required this.id,
    this.createdAt,
    this.updatedAt,
  });
}
