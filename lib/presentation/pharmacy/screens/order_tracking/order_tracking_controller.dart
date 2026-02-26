import 'package:get/get.dart';
import '../../../../app/config/app_routes.dart';
import '../../../../app/controllers/base_controller.dart';
import '../../../../domain/entity/cart_item_entity.dart';

/// Order Tracking Status Enum
enum OrderTrackingStatus {
  placed,
  dispatched,
  delivered,
  completed,
}

/// Order Tracking Step Model
class TrackingStep {
  final OrderTrackingStatus status;
  final String title;
  final String? description;
  final DateTime? timestamp;
  final bool isCompleted;
  final bool isCurrent;

  const TrackingStep({
    required this.status,
    required this.title,
    this.description,
    this.timestamp,
    required this.isCompleted,
    required this.isCurrent,
  });
}

/// Order Tracking Controller - Manages order tracking screen state
class OrderTrackingController extends BaseController {
  // Order Details
  final RxString orderId = ''.obs;
  final RxString orderNumber = ''.obs;
  final RxString orderDate = ''.obs;
  final RxString estimatedDelivery = ''.obs;

  // Order Summary
  final RxDouble subtotal = 0.0.obs;
  final RxDouble deliveryFee = 0.0.obs;
  final RxDouble total = 0.0.obs;

  // Delivery Information
  final RxString deliveryAddress = ''.obs;
  final RxString phoneNumber = ''.obs;
  final RxString paymentMethod = ''.obs;

  // Tracking Status
  final Rx<OrderTrackingStatus> currentStatus = OrderTrackingStatus.placed.obs;
  final RxList<TrackingStep> trackingSteps = <TrackingStep>[].obs;

  // Order Items
  final RxList<CartItemEntity> orderItems = <CartItemEntity>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadOrderTrackingData();
  }

  /// Load order tracking data from arguments
  Future<void> _loadOrderTrackingData() async {
    try {
      setLoading(true);

      // Get order data passed from previous screen
      final args = Get.arguments as Map<String, dynamic>?;

      // Initialize order details
      orderId.value = args?['orderId'] ?? '';
      orderNumber.value = args?['orderNumber'] ?? 'ORD12345678';
      orderDate.value = args?['orderDate'] ?? _formatCurrentDate();
      estimatedDelivery.value = args?['estimatedDelivery'] ?? _calculateEstimatedDelivery();

      // Initialize order summary
      subtotal.value = args?['subtotal'] ?? 450.0;
      deliveryFee.value = args?['deliveryFee'] ?? 50.0;
      total.value = args?['total'] ?? 500.0;

      // Initialize delivery info
      deliveryAddress.value = args?['deliveryAddress'] ?? '123 Main Street, City, State 12345';
      phoneNumber.value = args?['phoneNumber'] ?? '+1 234 567 8900';
      paymentMethod.value = args?['paymentMethod'] ?? 'Cash on Delivery';

      // Initialize order items
      if (args?['orderItems'] != null) {
        final items = args!['orderItems'] as List;
        orderItems.value = items.map((item) => item as CartItemEntity).toList();
      }

      // Initialize tracking status
      final statusString = args?['currentStatus'] as String?;
      currentStatus.value = _parseOrderStatus(statusString) ?? OrderTrackingStatus.dispatched;

      // Build tracking steps
      _buildTrackingSteps();

      setLoading(false);
    } catch (e) {
      logger.error('Error loading order tracking data: $e');
      setLoading(false);
    }
  }

  /// Build tracking steps based on current status
  void _buildTrackingSteps() {
    final now = DateTime.now();
    final List<TrackingStep> steps = [];

    // Define all possible steps
    final allStatuses = [
      OrderTrackingStatus.placed,
      OrderTrackingStatus.dispatched,
      OrderTrackingStatus.delivered,
      OrderTrackingStatus.completed,
    ];

    final currentIndex = allStatuses.indexOf(currentStatus.value);

    for (int i = 0; i < allStatuses.length; i++) {
      final status = allStatuses[i];
      final isCompleted = i < currentIndex;
      final isCurrent = i == currentIndex;

      steps.add(TrackingStep(
        status: status,
        title: _getStatusTitle(status),
        description: _getStatusDescription(status),
        timestamp: isCompleted || isCurrent ? now.subtract(Duration(days: allStatuses.length - i - 1)) : null,
        isCompleted: isCompleted,
        isCurrent: isCurrent,
      ));
    }

    trackingSteps.value = steps;
  }

  /// Get status title
  String _getStatusTitle(OrderTrackingStatus status) {
    switch (status) {
      case OrderTrackingStatus.placed:
        return 'Order Placed';
      case OrderTrackingStatus.dispatched:
        return 'Dispatched';
      case OrderTrackingStatus.delivered:
        return 'Delivered';
      case OrderTrackingStatus.completed:
        return 'Completed';
    }
  }

  /// Get status description
  String _getStatusDescription(OrderTrackingStatus status) {
    switch (status) {
      case OrderTrackingStatus.placed:
        return 'Your order has been placed successfully';
      case OrderTrackingStatus.dispatched:
        return 'Your order is on the way';
      case OrderTrackingStatus.delivered:
        return 'Your order has been delivered';
      case OrderTrackingStatus.completed:
        return 'Order completed. Thank you!';
    }
  }

  /// Format current date
  String _formatCurrentDate() {
    final now = DateTime.now();
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[now.month - 1]} ${now.day}, ${now.year}';
  }

  /// Calculate estimated delivery
  String _calculateEstimatedDelivery() {
    final deliveryDate = DateTime.now().add(const Duration(days: 3));
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${deliveryDate.day} ${months[deliveryDate.month - 1]}, ${deliveryDate.year}';
  }

  /// Format timestamp for display
  String formatTimestamp(DateTime? timestamp) {
    if (timestamp == null) return '';

    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final hour = timestamp.hour > 12 ? timestamp.hour - 12 : timestamp.hour;
    final period = timestamp.hour >= 12 ? 'PM' : 'AM';

    return '${months[timestamp.month - 1]} ${timestamp.day}, ${timestamp.year} at $hour:${timestamp.minute.toString().padLeft(2, '0')} $period';
  }

  /// Parse order status from string
  OrderTrackingStatus? _parseOrderStatus(String? statusString) {
    if (statusString == null) return null;

    switch (statusString.toLowerCase()) {
      case 'placed':
        return OrderTrackingStatus.placed;
      case 'dispatched':
        return OrderTrackingStatus.dispatched;
      case 'delivered':
        return OrderTrackingStatus.delivered;
      case 'completed':
        return OrderTrackingStatus.completed;
      default:
        return null;
    }
  }

  /// Go back to previous screen
  void goBack() {
    logger.navigation('Going back from order tracking');
    Get.back();
  }

  /// Go to home
  void goToHome() {
    logger.navigation('Going to pharmacy home');
    Get.offAllNamed(AppRoutes.navScreen);
  }

  /// Contact support
  void contactSupport() {
    logger.userAction('Contacting support for order: ${orderNumber.value}');
    // TODO: Implement contact support functionality
  }
}
