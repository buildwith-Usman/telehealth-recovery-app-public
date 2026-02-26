import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/controllers/base_controller.dart';
import '../../../../domain/entity/pharmacy_order_entity.dart';

/// Order Detail Controller - Manages order detail screen state
class OrderDetailController extends BaseController {

  // ==================== OBSERVABLES ====================
  late Rx<PharmacyOrderEntity> order;

  @override
  void onInit() {
    super.onInit();
    _loadOrderData();
  }

  /// Load order data from navigation arguments
  void _loadOrderData() {
    try {
      final args = Get.arguments;
      if (args != null && args['order'] != null) {
        order = Rx<PharmacyOrderEntity>(args['order'] as PharmacyOrderEntity);
      } else {
        logger.error('No order data found in arguments');
        Get.back();
      }
    } catch (e) {
      logger.error('Error loading order data: $e');
      Get.back();
    }
  }

  /// Navigate to order tracking screen
  void trackOrder() {
    logger.navigation('Navigating to order tracking');
    Get.toNamed('/orderTracking', arguments: {
      'order': order.value,
      'trackingNumber': order.value.trackingNumber,
    });
  }

  /// Cancel order
  Future<void> cancelOrder() async {
    try {
      final confirmed = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Cancel Order'),
          content: Text(
              'Are you sure you want to cancel order ${order.value.orderNumber}?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Yes, Cancel'),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        setLoading(true);

        // TODO: Call cancel order API
        // await pharmacyOrderService.cancelOrder(order.value.id);

        await Future.delayed(const Duration(seconds: 1));

        logger.controller('Order cancelled successfully');
        Get.back(result: true); // Go back and refresh orders list
      }
    } catch (e) {
      logger.error('Failed to cancel order: $e');
    } finally {
      setLoading(false);
    }
  }

  /// Reorder items
  void reorderItems() {
    logger.navigation('Reordering items from order ${order.value.orderNumber}');
    Get.toNamed('/cart', arguments: {
      'reorderItems': order.value.items,
      'message': 'Items from order ${order.value.orderNumber} added to cart',
    });
  }

  /// Contact support
  void contactSupport() {
    logger.userAction('Contacting support for order ${order.value.orderNumber}');
    // TODO: Implement contact support functionality
    Get.snackbar(
      'Contact Support',
      'Support feature will be implemented soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Download invoice
  void downloadInvoice() {
    logger.userAction('Downloading invoice for order ${order.value.orderNumber}');
    // TODO: Implement invoice download functionality
    Get.snackbar(
      'Download Invoice',
      'Invoice download will be implemented soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Go back to previous screen
  void goBack() {
    logger.navigation('Going back from order details');
    Get.back();
  }
}
