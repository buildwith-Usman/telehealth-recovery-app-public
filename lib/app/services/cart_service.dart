import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recovery_consultation_app/domain/entity/cart_item_entity.dart';
import 'package:recovery_consultation_app/domain/entity/medicine_entity.dart';

/// Cart Service - Global cart management with local storage
/// Singleton service accessible throughout the app
class CartService extends GetxService {
  static const String _cartKey = 'shopping_cart';

  // Observable cart items
  final RxList<CartItemEntity> cartItems = <CartItemEntity>[].obs;

  // Cart totals
  final RxDouble subtotal = 0.0.obs;
  final RxDouble deliveryFee = 50.0.obs;
  final RxDouble total = 0.0.obs;

  // Cart item count
  int get itemCount => cartItems.length;
  int get totalQuantity => cartItems.fold(0, (sum, item) => sum + item.quantity);

  @override
  void onInit() {
    super.onInit();
    _loadCartFromStorage();
  }

  /// Load cart from local storage
  Future<void> _loadCartFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = prefs.getString(_cartKey);

      if (cartJson != null) {
        final List<dynamic> decoded = json.decode(cartJson);
        cartItems.value = decoded
            .map((item) => CartItemEntity.fromJson(item as Map<String, dynamic>))
            .toList();
        _calculateTotals();
      }
    } catch (e) {
      print('Error loading cart from storage: $e');
    }
  }

  /// Save cart to local storage
  Future<void> _saveCartToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = json.encode(cartItems.map((item) => item.toJson()).toList());
      await prefs.setString(_cartKey, cartJson);
    } catch (e) {
      print('Error saving cart to storage: $e');
    }
  }

  /// Add item to cart
  Future<bool> addToCart({
    required MedicineEntity medicine,
    int quantity = 1,
  }) async {
    try {
      // Check if item already exists in cart
      final existingIndex = cartItems.indexWhere(
        (item) => item.medicine.id == medicine.id,
      );

      if (existingIndex != -1) {
        // Update quantity of existing item
        final existingItem = cartItems[existingIndex];
        final newQuantity = existingItem.quantity + quantity;

        // Check stock availability
        if (medicine.stockQuantity != null && newQuantity > medicine.stockQuantity!) {
          Get.snackbar(
            'Stock Limit',
            'Only ${medicine.stockQuantity} items available',
            snackPosition: SnackPosition.BOTTOM,
          );
          return false;
        }

        cartItems[existingIndex] = existingItem.copyWith(quantity: newQuantity);
      } else {
        // Add new item to cart
        final newItem = CartItemEntity(
          id: DateTime.now().millisecondsSinceEpoch, // Temporary ID
          medicine: medicine,
          quantity: quantity,
        );
        cartItems.add(newItem);
      }

      _calculateTotals();
      await _saveCartToStorage();

      Get.snackbar(
        'Added to Cart',
        '${medicine.name} added to your cart',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      return true;
    } catch (e) {
      print('Error adding to cart: $e');
      Get.snackbar(
        'Error',
        'Failed to add item to cart',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  /// Update item quantity
  Future<void> updateQuantity(int itemId, int newQuantity) async {
    final index = cartItems.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      if (newQuantity <= 0) {
        await removeItem(itemId);
      } else {
        final item = cartItems[index];

        // Check stock availability
        if (item.medicine.stockQuantity != null &&
            newQuantity > item.medicine.stockQuantity!) {
          Get.snackbar(
            'Stock Limit',
            'Only ${item.medicine.stockQuantity} items available',
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }

        cartItems[index] = item.copyWith(quantity: newQuantity);
        _calculateTotals();
        await _saveCartToStorage();
      }
    }
  }

  /// Increase item quantity
  Future<void> increaseQuantity(int itemId) async {
    final index = cartItems.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      await updateQuantity(itemId, cartItems[index].quantity + 1);
    }
  }

  /// Decrease item quantity
  Future<void> decreaseQuantity(int itemId) async {
    final index = cartItems.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      await updateQuantity(itemId, cartItems[index].quantity - 1);
    }
  }

  /// Remove item from cart
  Future<void> removeItem(int itemId) async {
    final index = cartItems.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      final itemName = cartItems[index].medicine.name;
      cartItems.removeAt(index);
      _calculateTotals();
      await _saveCartToStorage();

      Get.snackbar(
        'Removed',
        '$itemName removed from cart',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  /// Clear all items from cart
  Future<void> clearCart() async {
    cartItems.clear();
    _calculateTotals();
    await _saveCartToStorage();

    Get.snackbar(
      'Cart Cleared',
      'All items removed from cart',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  /// Calculate subtotal and total
  void _calculateTotals() {
    double calculatedSubtotal = 0.0;
    for (var item in cartItems) {
      calculatedSubtotal += item.calculatedTotalPrice;
    }
    subtotal.value = calculatedSubtotal;
    total.value = calculatedSubtotal + (cartItems.isEmpty ? 0 : deliveryFee.value);
  }

  /// Check if medicine is in cart
  bool isInCart(int medicineId) {
    return cartItems.any((item) => item.medicine.id == medicineId);
  }

  /// Get quantity of medicine in cart
  int getQuantityInCart(int medicineId) {
    final item = cartItems.firstWhereOrNull(
      (item) => item.medicine.id == medicineId,
    );
    return item?.quantity ?? 0;
  }
}
