import 'package:recovery_consultation_app/data/repository/admin_repository_impl.dart';
import 'package:recovery_consultation_app/data/repository/appointment_repository_impl.dart';
import 'package:recovery_consultation_app/data/repository/auth_repository_impl.dart';
import 'package:recovery_consultation_app/data/repository/pharmacy_repository_impl.dart';
import 'package:recovery_consultation_app/data/repository/preferences_repository_impl.dart';
import 'package:recovery_consultation_app/data/repository/patient_repository_impl.dart';
import 'package:recovery_consultation_app/data/repository/questioniare_repository_impl.dart';
import 'package:recovery_consultation_app/data/repository/review_repository_impl.dart';
import 'package:recovery_consultation_app/data/repository/specialist_repository_impl.dart';
import 'package:recovery_consultation_app/data/repository/user_repository_impl.dart';
import 'package:recovery_consultation_app/domain/repositories/admin_repository.dart';
import 'package:recovery_consultation_app/domain/repositories/appointment_repository.dart';
import 'package:recovery_consultation_app/domain/repositories/auth_repository.dart';
import 'package:recovery_consultation_app/domain/repositories/patient_repository.dart';
import 'package:recovery_consultation_app/domain/repositories/pharmacy_repository.dart';
import 'package:recovery_consultation_app/domain/repositories/preferences_repository.dart';
import 'package:recovery_consultation_app/domain/repositories/questioniare_repository.dart';
import 'package:recovery_consultation_app/domain/repositories/review_repository.dart';
import 'package:recovery_consultation_app/domain/repositories/specialist_repository.dart';
import 'package:recovery_consultation_app/domain/repositories/user_repository.dart';

import 'datasource_module.dart';

mixin RepositoryModule on DatasourceModule {

  AuthRepository get authRepository {
    return AuthRepositoryImpl(authDatasource: authDatasource);
  }

  UserRepository get userRepository {
    return UserRepositoryImpl(userDatasource: userDataSource);
  }

  AppointmentRepository get appointmentRepository {
    return AppointmentRepositoryImpl(appointmentDatasource: appointmentDatasource);
  }

  PreferencesRepository get preferencesRepository {
    return PreferencesRepositoryImpl();
  }

  SpecialistRepository get specialistRepository {
    return SpecialistRepositoryImpl(specialistDatasource: specialistDatasource);
  }

  QuestioniareRepository get questioniareRepository {
    return QuestioniareRepositoryImpl(questioniareDatasource: questioniareDataSource);
  }

  AdminRepository get adminRepository {
    return  AdminRepositoryImpl(adminDatasource: adminDataSource);
  }

  PharmacyRepository get pharmacyRepository {
    return PharmacyRepositoryImpl(pharmacyDatasource: pharmacyDatasource);
  }

  PatientRepository get patientRepository {
    return PatientRepositoryImpl(patientDatasource: patientDatasource);
  }

  ReviewRepository get reviewRepository {
    return ReviewRepositoryImpl(reviewDatasource: reviewDatasource);
  }

}
