import 'package:recovery_consultation_app/data/datasource/pharmacy/pharmacy_datasource.dart';
import 'package:recovery_consultation_app/data/mapper/product_mapper.dart';
import 'package:recovery_consultation_app/domain/entity/featured_product_entity.dart';
import 'package:recovery_consultation_app/domain/entity/medicine_entity.dart';
import 'package:recovery_consultation_app/domain/entity/pharmacy_banner_entity.dart';
import 'package:recovery_consultation_app/domain/entity/product_entity.dart';
import 'package:recovery_consultation_app/domain/repositories/pharmacy_repository.dart';
import '../../data/api/response/error_response.dart';
import '../../data/mapper/exception_mapper.dart';

/// Pharmacy Repository Implementation
/// This follows the same pattern as AdminRepositoryImpl, SpecialistRepositoryImpl
class PharmacyRepositoryImpl implements PharmacyRepository {
  final PharmacyDatasource pharmacyDatasource;

  PharmacyRepositoryImpl({required this.pharmacyDatasource});

  @override
  Future<List<PharmacyBannerEntity>> getPromotionalBanners() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Return mock banner data as entities
    // In real implementation, this would come from pharmacyDatasource
    // Widget uses static AppColors (primary for active, accent for inactive)
    return [
      const PharmacyBannerEntity(
        id: 1,
        title: 'Summer Sale',
        description: 'Get up to 50% off on all pain relief medicines',
        productName: 'Pain Relief Kit',
        bannerType: PharmacyBannerType.flashSale,
        imageUrl: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=400',
      ),
      const PharmacyBannerEntity(
        id: 2,
        title: 'New Arrivals',
        description: 'Check out our latest collection of vitamins and supplements',
        productName: 'Vitamin Complex',
        bannerType: PharmacyBannerType.newArrival,
        imageUrl: 'https://images.unsplash.com/photo-1471864190281-a93a3070b6de?w=400',
      ),
      const PharmacyBannerEntity(
        id: 3,
        title: 'Featured Products',
        description: 'Top-rated medicines recommended by healthcare professionals',
        productName: 'Premium Antibiotics',
        bannerType: PharmacyBannerType.featured,
        imageUrl: 'https://images.unsplash.com/photo-1587854692152-cbe660dbde88?w=400',
      ),
    ];
  }

  @override
  Future<List<FeaturedProductEntity>> getFeaturedProducts() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Return mock featured product data
    // In real implementation, this would come from pharmacyDatasource
    return [
      const FeaturedProductEntity(
        id: 1,
        name: 'Paracetamol 500mg',
        imageUrl: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=200',
        price: 4.99,
        originalPrice: 24.99,
        discountPercentage: 80,
        category: 'Pain Relief',
        description: 'Effective pain relief tablets',
        isInStock: true,
        stockCount: 150,
      ),
      const FeaturedProductEntity(
        id: 2,
        name: 'Vitamin D3 1000 IU',
        imageUrl: 'https://images.unsplash.com/photo-1471864190281-a93a3070b6de?w=200',
        price: 12.99,
        originalPrice: 19.99,
        discountPercentage: 35,
        category: 'Vitamins',
        description: 'Essential vitamin D supplement',
        isInStock: true,
        stockCount: 200,
      ),
      const FeaturedProductEntity(
        id: 3,
        name: 'Cough Syrup 100ml',
        imageUrl: 'https://images.unsplash.com/photo-1587854692152-cbe660dbde88?w=200',
        price: 6.99,
        originalPrice: 13.99,
        discountPercentage: 50,
        category: 'Cold & Flu',
        description: 'Fast-acting cough relief',
        isInStock: true,
        stockCount: 80,
      ),
      const FeaturedProductEntity(
        id: 4,
        name: 'Multivitamin Complex',
        imageUrl: 'https://images.unsplash.com/photo-1550572017-4fade83e0d30?w=200',
        price: 15.99,
        originalPrice: 29.99,
        discountPercentage: 47,
        category: 'Supplements',
        description: 'Complete daily multivitamin',
        isInStock: true,
        stockCount: 120,
      ),
      const FeaturedProductEntity(
        id: 5,
        name: 'Antibiotic Ointment',
        imageUrl: 'https://images.unsplash.com/photo-1585435557343-3b092031a831?w=200',
        price: 8.99,
        originalPrice: 14.99,
        discountPercentage: 40,
        category: 'First Aid',
        description: 'Triple antibiotic ointment',
        isInStock: true,
        stockCount: 95,
      ),
    ];
  }

  @override
  Future<List<MedicineEntity>> getMedicines() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Return mock medicine data
    // In real implementation, this would come from pharmacyDatasource
    return [
      const MedicineEntity(
        id: 1,
        name: 'Aspirin 100mg',
        description: 'Pain reliever and fever reducer',
        category: 'Pain Relief',
        price: 5.99,
        imageUrl: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=200',
        stockQuantity: 100,
        manufacturer: 'PharmaCorp',
        requiresPrescription: false,
        tags: ['Pain Relief', 'Fever'],
      ),
      const MedicineEntity(
        id: 2,
        name: 'Amoxicillin 500mg',
        description: 'Antibiotic for bacterial infections',
        category: 'Antibiotics',
        price: 12.99,
        imageUrl: 'https://images.unsplash.com/photo-1587854692152-cbe660dbde88?w=200',
        stockQuantity: 50,
        manufacturer: 'MediTech',
        requiresPrescription: true,
        tags: ['Antibiotics', 'Prescription'],
      ),
      const MedicineEntity(
        id: 3,
        name: 'Ibuprofen 200mg',
        description: 'Anti-inflammatory and pain relief',
        category: 'Pain Relief',
        price: 7.99,
        imageUrl: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=200',
        stockQuantity: 150,
        manufacturer: 'HealthPlus',
        requiresPrescription: false,
        tags: ['Pain Relief', 'Anti-inflammatory'],
      ),
      const MedicineEntity(
        id: 4,
        name: 'Cetirizine 10mg',
        description: 'Antihistamine for allergies',
        category: 'Allergy',
        price: 8.99,
        imageUrl: 'https://images.unsplash.com/photo-1471864190281-a93a3070b6de?w=200',
        stockQuantity: 75,
        manufacturer: 'AllergyFree',
        requiresPrescription: false,
        tags: ['Allergy', 'Antihistamine'],
      ),
      const MedicineEntity(
        id: 5,
        name: 'Omeprazole 20mg',
        description: 'Proton pump inhibitor for acid reflux',
        category: 'Digestive',
        price: 10.99,
        imageUrl: 'https://images.unsplash.com/photo-1585435557343-3b092031a831?w=200',
        stockQuantity: 60,
        manufacturer: 'GastroHealth',
        requiresPrescription: false,
        tags: ['Digestive', 'Acid Reflux'],
      ),
    ];
  }

  @override
  Future<List<ProductEntity>> getProducts({
    int? limit,
    int? categoryId,
    String? search,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      final response = await pharmacyDatasource.getProducts(
        limit: limit,
        categoryId: categoryId,
        search: search,
        sortBy: sortBy,
        sortOrder: sortOrder,
      );

      if (response == null || response.isEmpty) {
        return [];
      } else {
        return response
            .map((productResponse) => ProductMapper.toProductEntity(productResponse))
            .toList();
      }
    } on BaseErrorResponse catch (error) {
      throw ExceptionMapper.toBaseErrorEntity(error);
    }
  }

  @override
  Future<ProductEntity?> getProductById(int id) async {
    try {
      final response = await pharmacyDatasource.getProductById(id);

      if (response == null) {
        return null;
      } else {
        return ProductMapper.toProductEntity(response);
      }
    } on BaseErrorResponse catch (error) {
      throw ExceptionMapper.toBaseErrorEntity(error);
    }
  }

  @override
  Future<bool> addProductToFeatures(int productId) async {
    try {
      return await pharmacyDatasource.addToFeatures(productId);
    } on BaseErrorResponse catch (error) {
      throw ExceptionMapper.toBaseErrorEntity(error);
    }
  }

  // ==================== FUTURE METHODS ====================
  // Uncomment and implement when needed

  // @override
  // Future<List<CategoryEntity>> getCategories() async {
  //   return await pharmacyDatasource.getCategories();
  // }
}
