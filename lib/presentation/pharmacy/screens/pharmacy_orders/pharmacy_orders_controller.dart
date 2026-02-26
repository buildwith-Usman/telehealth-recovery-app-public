import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/config/app_routes.dart';
import '../../../../app/controllers/base_controller.dart';
import '../../../../domain/entity/pharmacy_order_entity.dart';

/// Pharmacy Orders Controller - Manages pharmacy orders screen state
class PharmacyOrdersController extends BaseController {
  
  // ==================== OBSERVABLES ====================
  final RxList<PharmacyOrderEntity> allOrders = <PharmacyOrderEntity>[].obs;
  final RxList<PharmacyOrderEntity> inProgressOrders = <PharmacyOrderEntity>[].obs;
  final RxList<PharmacyOrderEntity> deliveredOrders = <PharmacyOrderEntity>[].obs;
  
  // Loading states
  final RxBool isInitialLoading = true.obs;
  @override
  final RxBool isLoading = false.obs;
  
  // Tab management
  final RxInt selectedTabIndex = 0.obs;
  
  // Statistics
  final RxInt totalOrdersCount = 0.obs;
  final RxInt inProgressOrdersCount = 0.obs;
  final RxInt deliveredOrdersCount = 0.obs;
  
  // Search and filter
  final RxString searchQuery = ''.obs;
  final RxList<OrderStatus> selectedStatusFilters = <OrderStatus>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  /// Load initial data when page loads
  Future<void> loadInitialData() async {
    try {
      isInitialLoading.value = true;
      await Future.wait([
        loadAllOrders(),
        loadOrderStatistics(),
      ]);
    } finally {
      isInitialLoading.value = false;
    }
  }

  /// Load all orders from API
  Future<void> loadAllOrders() async {
    try {
      setLoading(true);
      
      // TODO: Replace with actual API call
      // final orders = await pharmacyOrderService.getAllOrders();
      
      // Mock data for demonstration
      await Future.delayed(const Duration(seconds: 1));
      final mockOrders = _generateMockOrders();
      
      allOrders.value = mockOrders;
      _filterOrdersByStatus();
      
    } catch (e) {
      // showErrorMessage('Failed to load orders');
      debugPrint('Error loading orders: $e');
    } finally {
      setLoading(false);
    }
  }

  /// Filter orders by status for different tabs
  void _filterOrdersByStatus() {
    inProgressOrders.value = allOrders
        .where((order) => order.isInProgress)
        .toList();
        
    deliveredOrders.value = allOrders
        .where((order) => order.isCompleted)
        .toList();
  }

  /// Load order statistics
  Future<void> loadOrderStatistics() async {
    totalOrdersCount.value = allOrders.length;
    inProgressOrdersCount.value = inProgressOrders.length;
    deliveredOrdersCount.value = deliveredOrders.length;
  }

  /// Handle tab change
  void onTabChanged(int index) {
    selectedTabIndex.value = index;
    debugPrint('Switched to tab: $index');
  }

  /// Refresh all orders
  Future<void> refreshAllOrders() async {
    await loadAllOrders();
    await loadOrderStatistics();
  }

  /// Refresh in progress orders
  Future<void> refreshInProgressOrders() async {
    await refreshAllOrders();
  }

  /// Refresh delivered orders
  Future<void> refreshDeliveredOrders() async {
    await refreshAllOrders();
  }

  /// View order details
  void viewOrderDetails(PharmacyOrderEntity order) {
    Get.toNamed(AppRoutes.orderDetail, arguments: {
      'order': order,
      'orderId': order.id,
    });
  }

  /// Track order
  void trackOrder(PharmacyOrderEntity order) {
    Get.toNamed(AppRoutes.orderTracking, arguments: {
      'order': order,
      'trackingNumber': order.trackingNumber,
    });
  }

  /// Cancel order
  Future<void> cancelOrder(PharmacyOrderEntity order) async {
    try {
      final confirmed = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Cancel Order'),
          content: Text('Are you sure you want to cancel order ${order.orderNumber}?'),
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
        // await pharmacyOrderService.cancelOrder(order.id);
        
        await Future.delayed(const Duration(seconds: 1));
        // showSuccessMessage('Order cancelled successfully');
        
        // Refresh orders
        await refreshAllOrders();
      }
    } catch (e) {
      // showErrorMessage('Failed to cancel order');
    } finally {
      setLoading(false);
    }
  }

  /// Reorder items
  void reorderItems(PharmacyOrderEntity order) {
    // Add order items to cart and navigate to cart
    Get.toNamed('/cart', arguments: {
      'reorderItems': order.items,
      'message': 'Items from order ${order.orderNumber} added to cart',
    });
  }

  /// Rate order
  void rateOrder(PharmacyOrderEntity order) {
    Get.toNamed('/rate-order', arguments: {
      'order': order,
    });
  }

  /// Show search dialog
  void showSearchDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Search Orders'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Enter order number or customer name',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            searchQuery.value = value;
            // TODO: Implement search functionality
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              // TODO: Apply search
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  /// Show filter dialog
  void showFilterDialog() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter Orders',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // TODO: Add filter options
            const Text('Filter options will be implemented here'),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Cancel'),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      // TODO: Apply filters
                    },
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Generate mock orders for demonstration
  List<PharmacyOrderEntity> _generateMockOrders() {
    return [
      // Recent orders (in progress)
      PharmacyOrderEntity(
        id: '1',
        orderNumber: 'ORD-2024-001',
        customerName: 'John Doe',
        customerPhone: '+1 234 567 8900',
        deliveryAddress: '123 Main St, City, State 12345',
        orderDate: DateTime.now().subtract(const Duration(days: 1)),
        status: OrderStatus.confirmed,
        paymentStatus: PaymentStatus.paid,
        paymentMethod: 'Credit Card',
        subtotal: 45.99,
        deliveryFee: 5.00,
        tax: 4.14,
        totalAmount: 55.13,
        trackingNumber: 'TRK123456789',
        items: [
          const OrderItemEntity(
            id: '1',
            medicineId: 'med1',
            medicineName: 'Paracetamol 500mg',
            unitPrice: 12.99,
            quantity: 2,
            totalPrice: 25.98,
            manufacturer: 'PharmaCorp',
          ),
          const OrderItemEntity(
            id: '2',
            medicineId: 'med2',
            medicineName: 'Vitamin C Tablets',
            unitPrice: 20.01,
            quantity: 1,
            totalPrice: 20.01,
            manufacturer: 'HealthPlus',
          ),
        ],
      ),
      
      // Dispatched order
      PharmacyOrderEntity(
        id: '2',
        orderNumber: 'ORD-2024-002',
        customerName: 'Jane Smith',
        customerPhone: '+1 234 567 8901',
        deliveryAddress: '456 Oak Ave, City, State 12345',
        orderDate: DateTime.now().subtract(const Duration(days: 2)),
        status: OrderStatus.dispatched,
        paymentStatus: PaymentStatus.paid,
        paymentMethod: 'JazzCash',
        subtotal: 75.50,
        deliveryFee: 5.00,
        tax: 6.79,
        totalAmount: 87.29,
        trackingNumber: 'TRK987654321',
        items: [
          const OrderItemEntity(
            id: '3',
            medicineId: 'med3',
            medicineName: 'Cough Syrup',
            unitPrice: 18.75,
            quantity: 1,
            totalPrice: 18.75,
            manufacturer: 'MediCare',
          ),
          const OrderItemEntity(
            id: '4',
            medicineId: 'med4',
            medicineName: 'Multivitamin Pack',
            unitPrice: 56.75,
            quantity: 1,
            totalPrice: 56.75,
            manufacturer: 'VitaLife',
          ),
        ],
      ),
      
      // Delivered order
      PharmacyOrderEntity(
        id: '3',
        orderNumber: 'ORD-2024-003',
        customerName: 'Mike Johnson',
        customerPhone: '+1 234 567 8902',
        deliveryAddress: '789 Pine St, City, State 12345',
        orderDate: DateTime.now().subtract(const Duration(days: 5)),
        deliveryDate: DateTime.now().subtract(const Duration(days: 1)),
        status: OrderStatus.delivered,
        paymentStatus: PaymentStatus.paid,
        paymentMethod: 'Easy Paisa',
        subtotal: 32.99,
        deliveryFee: 5.00,
        tax: 2.97,
        totalAmount: 40.96,
        items: [
          const OrderItemEntity(
            id: '5',
            medicineId: 'med5',
            medicineName: 'Ibuprofen 400mg',
            unitPrice: 14.25,
            quantity: 1,
            totalPrice: 14.25,
            manufacturer: 'PainRelief Inc',
          ),
          const OrderItemEntity(
            id: '6',
            medicineId: 'med6',
            medicineName: 'Antacid Tablets',
            unitPrice: 18.74,
            quantity: 1,
            totalPrice: 18.74,
            manufacturer: 'DigestAid',
          ),
        ],
      ),
      
      // Dispatched order
      PharmacyOrderEntity(
        id: '4',
        orderNumber: 'ORD-2024-004',
        customerName: 'Sarah Wilson',
        customerPhone: '+1 234 567 8903',
        deliveryAddress: '321 Elm St, City, State 12345',
        orderDate: DateTime.now().subtract(const Duration(hours: 8)),
        status: OrderStatus.dispatched,
        paymentStatus: PaymentStatus.paid,
        paymentMethod: 'Cash on Delivery',
        subtotal: 28.50,
        deliveryFee: 5.00,
        tax: 2.57,
        totalAmount: 36.07,
        trackingNumber: 'TRK456789123',
        items: [
          const OrderItemEntity(
            id: '7',
            medicineId: 'med7',
            medicineName: 'Allergy Relief',
            unitPrice: 28.50,
            quantity: 1,
            totalPrice: 28.50,
            manufacturer: 'AllergyFree',
          ),
        ],
      ),
      
      // Pending order
      PharmacyOrderEntity(
        id: '5',
        orderNumber: 'ORD-2024-005',
        customerName: 'David Brown',
        customerPhone: '+1 234 567 8904',
        deliveryAddress: '654 Maple Dr, City, State 12345',
        orderDate: DateTime.now().subtract(const Duration(hours: 2)),
        status: OrderStatus.pending,
        paymentStatus: PaymentStatus.pending,
        paymentMethod: 'Credit Card',
        subtotal: 42.25,
        deliveryFee: 5.00,
        tax: 3.80,
        totalAmount: 51.05,
        items: [
          const OrderItemEntity(
            id: '8',
            medicineId: 'med8',
            medicineName: 'Blood Pressure Monitor',
            unitPrice: 42.25,
            quantity: 1,
            totalPrice: 42.25,
            manufacturer: 'HealthTech',
          ),
        ],
      ),
    ];
  }

    /// Go back to previous screen
  void goBack() {
    logger.navigation('Going back from order tracking');
    Get.back();
  }
}