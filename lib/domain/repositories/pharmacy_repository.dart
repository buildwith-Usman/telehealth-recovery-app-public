import 'package:recovery_consultation_app/domain/entity/featured_product_entity.dart';
import 'package:recovery_consultation_app/domain/entity/medicine_entity.dart';
import 'package:recovery_consultation_app/domain/entity/pharmacy_banner_entity.dart';
import 'package:recovery_consultation_app/domain/entity/product_entity.dart';

/// Pharmacy Repository - Handles all pharmacy module data operations
/// This follows the same pattern as AdminRepository and SpecialistRepository
abstract class PharmacyRepository {
  // ==================== BANNER OPERATIONS ====================

  /// Get promotional banners for pharmacy home page
  Future<List<PharmacyBannerEntity>> getPromotionalBanners();

  // ==================== FEATURED PRODUCTS OPERATIONS ====================

  /// Get featured products for pharmacy home page
  Future<List<FeaturedProductEntity>> getFeaturedProducts();

  // ==================== MEDICINE OPERATIONS ====================

  /// Get medicines list for pharmacy home page
  Future<List<MedicineEntity>> getMedicines();

  /// Get products list with optional filters, search, and sorting
  Future<List<ProductEntity>> getProducts({
    int? limit,
    int? categoryId,
    String? search,
    String? sortBy,
    String? sortOrder,
  });

  /// Get product by ID
  Future<ProductEntity?> getProductById(int id);

  /// Add product to features (favorites)
  Future<bool> addProductToFeatures(int productId);

  // TODO: Add more medicine-related methods as needed
  // Future<List<MedicineEntity>> searchMedicines(String query);

  // ==================== CATEGORY OPERATIONS ====================
  // TODO: Add category-related methods as needed
  // Future<List<CategoryEntity>> getCategories();

  // ==================== CART OPERATIONS ====================
  // TODO: Add cart-related methods as needed
  // Future<CartEntity?> getCart();
  // Future<void> addToCart(String medicineId, int quantity);
  // Future<void> removeFromCart(String itemId);

  // ==================== PRESCRIPTION OPERATIONS ====================
  // TODO: Add prescription-related methods as needed
  // Future<List<PrescriptionEntity>> getPrescriptions();
}
