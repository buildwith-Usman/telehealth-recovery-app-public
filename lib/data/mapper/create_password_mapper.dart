import 'package:recovery_consultation_app/data/api/response/create_password_response.dart';
import 'package:recovery_consultation_app/domain/entity/create_password_entity.dart';


class CreatePasswordMapper {
  static CreatePasswordEntity toCreateNewPasswordEntity(CreatePasswordResponse createPassword) {
    return CreatePasswordEntity(
      id: createPassword.id ?? 0, // `id` should be an `int?` (default to 0 if null)
      name: createPassword.name ?? '', // `name` as `String?`
      email: createPassword.email ?? '', // `email` as `String?`
      status: createPassword.status ?? '', // `status` as `String?`
      level: createPassword.level ?? '', // `level` as `String?`
      phone: createPassword.phone ?? '', // `phone` as `String?`
    );
  }
}


