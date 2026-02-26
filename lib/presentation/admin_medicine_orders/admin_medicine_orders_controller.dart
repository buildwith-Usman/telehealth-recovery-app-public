import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/controllers/base_controller.dart';

enum OrderStatus { pending, confirmed, dispatched, delivered, cancelled }

class MedicineOrder {
  final String id;
  final String customerName;
  final DateTime date;
  final OrderStatus status;
  final double total;

  MedicineOrder({
    required this.id,
    required this.customerName,
    required this.date,
    required this.status,
    required this.total,
  });
}

class AdminMedicineOrdersController extends BaseController {
  final orders = <MedicineOrder>[].obs;
  final filteredOrders = <MedicineOrder>[].obs;
  @override
  final isLoading = false.obs;
  String? errorMessage;

  final searchController = TextEditingController();
  final RxInt tabIndex = 0.obs;
  final List<String> tabs = ['All Orders', 'New Orders', 'Dispatch Order', 'Delivered'];

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
    searchController.addListener(() {
      filterOrders();
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void changeTabIndex(int index) {
    tabIndex.value = index;
    filterOrders();
  }

  void filterOrders() {
    final query = searchController.text.toLowerCase();
    OrderStatus? statusFilter;
    switch (tabIndex.value) {
      case 1: // New Orders
        statusFilter = OrderStatus.pending;
        break;
      case 2: // Dispatch Order
        statusFilter = OrderStatus.dispatched;
        break;
      case 3: // Delivered
        statusFilter = OrderStatus.delivered;
        break;
    }

    var tempFilteredList = orders.where((order) {
      final nameMatches = order.customerName.toLowerCase().contains(query);
      final statusMatches = statusFilter == null || order.status == statusFilter;
      return nameMatches && statusMatches;
    }).toList();

    filteredOrders.value = tempFilteredList;
  }

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      errorMessage = null;
      await Future.delayed(const Duration(seconds: 1));
      orders.value = [
        MedicineOrder(id: '1', customerName: 'John Doe', date: DateTime.now(), status: OrderStatus.pending, total: 50.0),
        MedicineOrder(id: '2', customerName: 'Jane Smith', date: DateTime.now(), status: OrderStatus.confirmed, total: 75.0),
        MedicineOrder(id: '3', customerName: 'Peter Jones', date: DateTime.now(), status: OrderStatus.dispatched, total: 100.0),
        MedicineOrder(id: '4', customerName: 'Mary Williams', date: DateTime.now(), status: OrderStatus.delivered, total: 125.0),
        MedicineOrder(id: '5', customerName: 'David Brown', date: DateTime.now(), status: OrderStatus.cancelled, total: 150.0),
      ];
      filterOrders();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshOrders() async {
    await fetchOrders();
  }
}
