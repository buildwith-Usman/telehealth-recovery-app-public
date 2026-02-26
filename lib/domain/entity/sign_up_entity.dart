class SignUpEntity {
  const SignUpEntity({
    required this.verificationRequired,
    required this.user,
  });

  final bool verificationRequired;
  final SignUpUserEntity user;
}

class SignUpUserEntity {
  const SignUpUserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.type,
    required this.phone,
    required this.isVerified,
  });

  final int id;
  final String name;
  final String email;
  final String type;
  final String phone;
  final bool isVerified;
}
