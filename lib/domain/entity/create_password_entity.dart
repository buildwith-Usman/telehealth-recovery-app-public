class CreatePasswordEntity {
  const CreatePasswordEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.status,
    required this.level,
    required this.phone,
  });

  final int? id;
  final String? name;
  final String? email;
  final String? status;
  final String? level;
  final String? phone;
}
