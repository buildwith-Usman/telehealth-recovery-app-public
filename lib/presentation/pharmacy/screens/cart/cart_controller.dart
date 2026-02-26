import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/config/app_routes.dart';
import 'package:recovery_consultation_app/app/services/cart_service.dart';
import 'package:recovery_consultation_app/domain/entity/cart_item_entity.dart';
import '../../../../app/controllers/base_controller.dart';

/// Cart Controller - Manages shopping cart state and logic
/// This follows the same pattern as MedicineDetailController
class CartController extends BaseController {
  // Get cart service
  final CartService _cartService = Get.find<CartService>();

  // Use cart service observables directly
  RxList<CartItemEntity> get cartItems => _cartService.cartItems;
  RxDouble get subtotal => _cartService.subtotal;
  RxDouble get deliveryFee => _cartService.deliveryFee;
  RxDouble get total => _cartService.total;

  @override
  void onInit() {
    super.onInit();
    // Cart is already loaded by CartService on app start
    logger.controller('Cart controller initialized with ${cartItems.length} items');
  }

  /// Increase item quantity
  Future<void> increaseQuantity(int itemId) async {
    await _cartService.increaseQuantity(itemId);
    logger.userAction('Increased quantity for item $itemId');
  }

  /// Decrease item quantity
  Future<void> decreaseQuantity(int itemId) async {
    await _cartService.decreaseQuantity(itemId);
    logger.userAction('Decreased quantity for item $itemId');
  }

  /// Remove item from cart
  Future<void> removeItem(int itemId) async {
    await _cartService.removeItem(itemId);
    logger.userAction('Removed item $itemId from cart');
  }

  /// Clear all items from cart
  Future<void> clearCart() async {
    await _cartService.clearCart();
    logger.userAction('Cleared cart');
  }

  /// Proceed to checkout
  void proceedToCheckout() {
    if (cartItems.isEmpty) {
      Get.snackbar(
        'Empty Cart',
        'Please add items to cart before checkout',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    logger.userAction('Proceeding to checkout with ${cartItems.length} items');
    Get.toNamed(
      '/checkout',
      arguments: {
        'cartItems': cartItems.toList(),
        'subtotal': subtotal.value,
        'deliveryFee': deliveryFee.value,
        'total': total.value,
      },
    );
  }

  /// Navigate to pharmacy home page
  void goBack() {
    logger.navigation('Navigating to pharmacy home from cart');
    Get.offAllNamed(AppRoutes.pharmacy);
  }

  @override
  void onClose() {
    // Clean up resources
    super.onClose();
  }
}
