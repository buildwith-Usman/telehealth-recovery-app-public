import '../../domain/entity/update_profile_entity.dart';
import '../api/response/update_profile_response.dart';
import 'user_mapper.dart';

class UpdateProfileMapper {
  static UpdateProfileEntity toUpdateProfileEntity(UpdateProfileResponse response) {
    return UpdateProfileEntity(
      user: UserMapper.toUserEntity(response.user),
    );
  }
}
