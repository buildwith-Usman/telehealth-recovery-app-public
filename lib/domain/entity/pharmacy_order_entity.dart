/// Pharmacy Order Entity - Represents a pharmacy order
class PharmacyOrderEntity {
  final String id;
  final String orderNumber;
  final String customerName;
  final String customerPhone;
  final String deliveryAddress;
  final DateTime orderDate;
  final DateTime? deliveryDate;
  final OrderStatus status;
  final PaymentStatus paymentStatus;
  final String paymentMethod;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double totalAmount;
  final List<OrderItemEntity> items;
  final String? notes;
  final String? trackingNumber;

  const PharmacyOrderEntity({
    required this.id,
    required this.orderNumber,
    required this.customerName,
    required this.customerPhone,
    required this.deliveryAddress,
    required this.orderDate,
    this.deliveryDate,
    required this.status,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.totalAmount,
    required this.items,
    this.notes,
    this.trackingNumber,
  });

  /// Calculate estimated delivery date based on order date
  DateTime get estimatedDeliveryDate {
    return deliveryDate ?? orderDate.add(const Duration(days: 3));
  }

  /// Get order status display text
  String get statusDisplayText {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.dispatched:
        return 'Dispatched';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  /// Get status color for UI
  String get statusColor {
    switch (status) {
      case OrderStatus.pending:
        return '#FFA500'; // Orange
      case OrderStatus.confirmed:
        return '#007AFF'; // Blue
      case OrderStatus.dispatched:
        return '#FF9500'; // Orange
      case OrderStatus.delivered:
        return '#34C759'; // Green
      case OrderStatus.cancelled:
        return '#FF3B30'; // Red
    }
  }

  /// Check if order is in progress
  bool get isInProgress {
    return [
      OrderStatus.confirmed,
      OrderStatus.dispatched,
    ].contains(status);
  }

  /// Check if order is completed
  bool get isCompleted {
    return status == OrderStatus.delivered;
  }

  /// Check if order can be cancelled
  bool get canBeCancelled {
    return [
      OrderStatus.pending,
      OrderStatus.confirmed,
    ].contains(status);
  }

  /// Get total items count
  int get totalItemsCount {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }
}

/// Order Status Enum
enum OrderStatus {
  pending,
  confirmed,
  dispatched,
  delivered,
  cancelled,
}

/// Payment Status Enum
enum PaymentStatus {
  pending,
  paid,
  failed,
  refunded,
}

/// Order Item Entity
class OrderItemEntity {
  final String id;
  final String medicineId;
  final String medicineName;
  final String? medicineImage;
  final String? manufacturer;
  final double unitPrice;
  final int quantity;
  final double totalPrice;
  final String? dosage;
  final String? instructions;

  const OrderItemEntity({
    required this.id,
    required this.medicineId,
    required this.medicineName,
    this.medicineImage,
    this.manufacturer,
    required this.unitPrice,
    required this.quantity,
    required this.totalPrice,
    this.dosage,
    this.instructions,
  });
}