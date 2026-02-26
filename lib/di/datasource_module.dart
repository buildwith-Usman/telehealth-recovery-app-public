import 'package:recovery_consultation_app/data/datasource/admin/admin_datasource.dart';
import 'package:recovery_consultation_app/data/datasource/admin/admin_datasource_impl.dart';
import 'package:recovery_consultation_app/data/datasource/appointment/appointment_datasource.dart';
import 'package:recovery_consultation_app/data/datasource/auth/auth_datasource.dart';
import 'package:recovery_consultation_app/data/datasource/auth/auth_datasource_impl.dart';
import 'package:recovery_consultation_app/data/datasource/payment/payment_datasource.dart';
import 'package:recovery_consultation_app/data/datasource/payment/payment_datasource_impl.dart';
import 'package:recovery_consultation_app/data/datasource/patient/patient_datasource.dart';
import 'package:recovery_consultation_app/data/datasource/patient/patient_datasource_impl.dart';
import 'package:recovery_consultation_app/data/datasource/pharmacy/pharmacy_datasource.dart';
import 'package:recovery_consultation_app/data/datasource/pharmacy/pharmacy_datasource_impl.dart';
import 'package:recovery_consultation_app/data/datasource/questioniare/questioniare_datasource.dart';
import 'package:recovery_consultation_app/data/datasource/questioniare/questioniare_datasource_impl.dart';
import 'package:recovery_consultation_app/data/datasource/review/review_datasource.dart';
import 'package:recovery_consultation_app/data/datasource/review/review_datasource_impl.dart';
import 'package:recovery_consultation_app/data/datasource/specialist/specialist_datasource.dart';
import 'package:recovery_consultation_app/data/datasource/specialist/specialist_datasource_impl.dart';
import 'package:recovery_consultation_app/data/datasource/user/user_datasource.dart';
import 'package:recovery_consultation_app/data/datasource/user/user_datasource_impl.dart';
import '../data/datasource/appointment/appointment_datasource_impl.dart';
import 'client_module.dart';

mixin DatasourceModule on ClientModule {

  AuthDatasource get authDatasource {
    return AuthDatasourceImpl(
      unauthenticatedClient: unauthenticatedClient,
      apiClient: apiClient,
    );
  }

  UserDatasource get userDataSource {
    return UserDatasourceImpl(apiClient: apiClient);
  }

  AppointmentDatasource get appointmentDatasource {
    return AppointmentDatasourceImpl(apiClient: apiClient);
  }

  PaymentDatasource get paymentDatasource {
    return PaymentDatasourceImpl(apiClient: apiClient);
  }

  SpecialistDatasource get specialistDatasource {
    return SpecialistDatasourceImpl(apiClient: apiClient);
  }

  QuestioniareDatasource get questioniareDataSource {
    return QuestioniareDataSourceImpl(apiClient: apiClient);
  }

  AdminDatasource get adminDataSource {
    return AdminDatasourceImpl(apiClient: apiClient);
  }

  PatientDatasource get patientDatasource {
    return PatientDatasourceImpl(apiClient: apiClient);
  }

  ReviewDatasource get reviewDatasource {
    return ReviewDatasourceImpl(apiClient: apiClient);
  }

  PharmacyDatasource get pharmacyDatasource {
    return PharmacyDatasourceImpl(apiClient: apiClient);
  }

}
