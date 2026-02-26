import 'package:get/get.dart';
import '../../../../app/config/app_routes.dart';
import '../../../../app/controllers/base_controller.dart';
import '../../../../domain/entity/cart_item_entity.dart';
import '../../../../domain/entity/medicine_entity.dart';

/// Order Confirmation Controller - Manages order confirmation screen state
class OrderConfirmationController extends BaseController {
  // Order Details
  final RxString orderId = ''.obs;
  final RxString orderNumber = ''.obs;
  final RxString orderDate = ''.obs;
  final RxString estimatedDelivery = ''.obs;

  // Order Items
  final RxList<CartItemEntity> orderItems = <CartItemEntity>[].obs;

  // Order Summary
  final RxDouble subtotal = 0.0.obs;
  final RxDouble deliveryFee = 0.0.obs;
  final RxDouble total = 0.0.obs;

  // Delivery Information
  final RxString customerName = ''.obs;
  final RxString deliveryAddress = ''.obs;
  final RxString phoneNumber = ''.obs;
  final RxString paymentMethod = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadOrderData();
  }

  /// Load order data from arguments
  Future<void> _loadOrderData() async {
    try {
      setLoading(true);

      // Get order data passed from checkout
      final args = Get.arguments as Map<String, dynamic>?;

      // Initialize with default values
      orderId.value = args?['orderId'] ?? '';
      orderNumber.value = args?['orderNumber'] ?? _generateOrderNumber();
      orderDate.value = args?['orderDate'] ?? _formatCurrentDate();

      // Load order items from cart
      if (args?['cartItems'] != null) {
        final items = args!['cartItems'] as List;
        orderItems.value = items.map((item) => item as CartItemEntity).toList();
      } else {
        // Add dummy data for testing
        orderItems.value = _getDummyOrderItems();
      }

      subtotal.value = args?['subtotal'] ?? 0.0;
      deliveryFee.value = args?['deliveryFee'] ?? 50.0;
      total.value = args?['total'] ?? 0.0;
      customerName.value = args?['customerName'] ?? 'John Doe';
      deliveryAddress.value = args?['deliveryAddress'] ?? '123 Main Street, City, State 12345';
      phoneNumber.value = args?['phoneNumber'] ?? '+1 234 567 8900';
      paymentMethod.value = args?['paymentMethod'] ?? 'Cash on Delivery';
      estimatedDelivery.value = args?['estimatedDelivery'] ?? _calculateEstimatedDelivery();

      setLoading(false);
    } catch (e) {
      logger.error('Error loading order data: $e');
      setLoading(false);
    }
  }

  /// Generate order number (temporary - should come from backend)
  String _generateOrderNumber() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'ORD${timestamp.toString().substring(timestamp.toString().length - 8)}';
  }

  /// Format current date for order
  String _formatCurrentDate() {
    final now = DateTime.now();
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[now.month - 1]} ${now.day}, ${now.year}';
  }

  /// Calculate estimated delivery time (temporary - should come from backend)
  String _calculateEstimatedDelivery() {
    final deliveryDate = DateTime.now().add(const Duration(days: 3));
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${deliveryDate.day} ${months[deliveryDate.month - 1]}, ${deliveryDate.year}';
  }

  /// Get dummy order items for testing
  List<CartItemEntity> _getDummyOrderItems() {
    return [
      const CartItemEntity(
        id: 1,
        medicine: MedicineEntity(
          id: 1,
          name: 'Paracetamol 500mg',
          price: 50.0,
        ),
        quantity: 2,
      ),
      const CartItemEntity(
        id: 2,
        medicine: MedicineEntity(
          id: 2,
          name: 'Ibuprofen 200mg',
          price: 80.0,
        ),
        quantity: 1,
      ),
      const CartItemEntity(
        id: 3,
        medicine: MedicineEntity(
          id: 3,
          name: 'Vitamin C 1000mg',
          price: 120.0,
        ),
        quantity: 3,
      ),
      const CartItemEntity(
        id: 4,
        medicine: MedicineEntity(
          id: 4,
          name: 'Amoxicillin 250mg',
          price: 150.0,
        ),
        quantity: 1,
      ),
    ];
  }

  /// Track order
  void trackOrder() {
    logger.userAction('Tracking order: ${orderNumber.value}');
    Get.toNamed(AppRoutes.orderTracking, arguments: {
      'orderId': orderId.value,
      'orderNumber': orderNumber.value,
      'orderDate': orderDate.value,
      'estimatedDelivery': estimatedDelivery.value,
      'subtotal': subtotal.value,
      'deliveryFee': deliveryFee.value,
      'total': total.value,
      'deliveryAddress': deliveryAddress.value,
      'phoneNumber': phoneNumber.value,
      'paymentMethod': paymentMethod.value,
      'currentStatus': 'dispatched', // Default status
      'orderItems': orderItems.toList(),
    });
  }

  /// Go back to home/pharmacy
  void goToHome() {
    logger.navigation('Going back to pharmacy home');
    Get.offAllNamed(AppRoutes.navScreen);
  }

  /// View order details
  void viewOrderDetails() {
    logger.userAction('Viewing order details: ${orderNumber.value}');
    // TODO: Navigate to order details page
    // Get.toNamed(AppRoutes.orderDetails, arguments: {'orderId': orderId.value});
  }
}
