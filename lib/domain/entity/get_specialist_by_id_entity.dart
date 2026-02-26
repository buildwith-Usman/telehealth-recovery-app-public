import 'package:recovery_consultation_app/domain/entity/match_doctors_list_entity.dart';

class GetSpecialistByIdEntity {
  final DoctorUserEntity? doctor;

  const GetSpecialistByIdEntity({
    this.doctor,
  });

  @override
  String toString() {
    return 'GetSpecialistByIdEntity{doctor: $doctor,}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GetSpecialistByIdEntity &&
        other.doctor == doctor;
  }

  @override
  int get hashCode => doctor.hashCode ;
}
