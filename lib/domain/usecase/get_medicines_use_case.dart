import 'package:recovery_consultation_app/domain/entity/medicine_entity.dart';
import 'package:recovery_consultation_app/domain/repositories/pharmacy_repository.dart';
import 'package:recovery_consultation_app/domain/usecase/base_usecase.dart';

/// Use Case for fetching medicines from Pharmacy Repository
/// This follows the same pattern as GetPharmacyBannersUseCase, GetFeaturedProductsUseCase
class GetMedicinesUseCase implements NoParamUseCase<List<MedicineEntity>> {
  final PharmacyRepository repository;

  GetMedicinesUseCase({required this.repository});

  @override
  Future<List<MedicineEntity>> execute() async {
    final medicines = await repository.getMedicines();
    return medicines;
  }
}
