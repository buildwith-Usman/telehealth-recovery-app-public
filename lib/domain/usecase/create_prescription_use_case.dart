import 'package:recovery_consultation_app/domain/repositories/specialist_repository.dart';

class CreatePrescriptionUseCase {
  final SpecialistRepository repository;

  CreatePrescriptionUseCase({required this.repository});

  Future<bool> execute({
    required int appointmentId,
    required String prescriptionDate,
    required String notes,
  }) async {
    return await repository.createPrescription(
      appointmentId: appointmentId,
      prescriptionDate: prescriptionDate,
      notes: notes,
    );
  }
}
