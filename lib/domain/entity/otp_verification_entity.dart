import 'user_entity.dart';

class OtpVerificationEntity {
  const OtpVerificationEntity({
    required this.user,
    required this.accessToken,
    required this.tokenType,
    required this.isVerified,
  });

  final UserEntity user;
  final String accessToken;
  final String tokenType;
  final bool isVerified;
}
