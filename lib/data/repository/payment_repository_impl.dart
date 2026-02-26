import 'package:recovery_consultation_app/data/datasource/payment/payment_datasource.dart';
import 'package:recovery_consultation_app/domain/entity/payment_method_entity.dart';
import 'package:recovery_consultation_app/domain/enums/payment_method_type.dart';
import 'package:recovery_consultation_app/domain/repositories/payment_repository.dart';

/// Payment Repository Implementation
/// This implementation integrates with PaymentDatasource for API calls
/// and provides mock data for development purposes
class PaymentRepositoryImpl implements PaymentRepository {
  PaymentRepositoryImpl({required this.paymentDatasource});

  final PaymentDatasource paymentDatasource;

  // Mock in-memory storage for development (remove when API is ready)
  final List<PaymentMethodEntity> _mockPaymentMethods = [];
  int _nextId = 1;
  bool _initialized = false;

  void _initializeMockData() {
    if (_initialized) return;
    _initialized = true;

    // ❌ No default payment methods - all have isDefault: false
    _mockPaymentMethods.addAll([
      PaymentMethodEntity(
        id: _nextId++,
        type: PaymentMethodType.jazzCash,
        phoneNumber: '03123456789',
        isDefault: false, // Not default
        nickname: 'Jazz Cash',
        createdAt: DateTime.now().toIso8601String(),
      ),
      PaymentMethodEntity(
        id: _nextId++,
        type: PaymentMethodType.easyPaisa,
        phoneNumber: '03451234567',
        isDefault: false,
        createdAt: DateTime.now().toIso8601String(),
      ),
      PaymentMethodEntity(
        id: _nextId++,
        type: PaymentMethodType.creditCard,
        cardNumber: '4532',
        cardHolderName: 'John Doe',
        expiryDate: '12/25',
        cardType: 'Visa',
        isDefault: false,
        nickname: 'Visa Card',
        createdAt: DateTime.now().toIso8601String(),
      ),
    ]);
  }

  @override
  Future<List<PaymentMethodEntity>> getSavedPaymentMethods() async {
    // Initialize mock data if needed
    _initializeMockData();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    // TODO: Replace with actual API call when backend is ready
    // final response = await paymentDatasource.getPaymentMethods();
    // return response.map((json) => PaymentMethodEntity.fromJson(json)).toList();

    return List.from(_mockPaymentMethods);
  }

  @override
  Future<PaymentMethodEntity?> getPaymentMethodById(int id) async {
    _initializeMockData();
    await Future.delayed(const Duration(milliseconds: 200));

    // TODO: Replace with actual API call
    // final response = await paymentDatasource.getPaymentMethodById(id);
    // return PaymentMethodEntity.fromJson(response);

    try {
      return _mockPaymentMethods.firstWhere((method) => method.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<PaymentMethodEntity> savePaymentMethod(PaymentMethodEntity paymentMethod) async {
    _initializeMockData();
    await Future.delayed(const Duration(milliseconds: 500));

    final isFirstMethod = _mockPaymentMethods.isEmpty;

    final newMethod = PaymentMethodEntity(
      id: _nextId++,
      type: paymentMethod.type,
      phoneNumber: paymentMethod.phoneNumber,
      cardNumber: paymentMethod.cardNumber,
      cardHolderName: paymentMethod.cardHolderName,
      expiryDate: paymentMethod.expiryDate,
      cardType: paymentMethod.cardType,
      isDefault: isFirstMethod || paymentMethod.isDefault,
      nickname: paymentMethod.nickname,
      createdAt: DateTime.now().toIso8601String(),
    );

    if (newMethod.isDefault) {
      _removeDefaultFromAll();
    }

    _mockPaymentMethods.add(newMethod);

    // TODO: Replace with actual API call
    // final response = await paymentDatasource.savePaymentMethod(newMethod.toJson());
    // return PaymentMethodEntity.fromJson(response);

    return newMethod;
  }

  @override
  Future<PaymentMethodEntity> updatePaymentMethod(PaymentMethodEntity paymentMethod) async {
    _initializeMockData();
    await Future.delayed(const Duration(milliseconds: 400));

    final index = _mockPaymentMethods.indexWhere((m) => m.id == paymentMethod.id);
    if (index == -1) {
      throw Exception('Payment method not found');
    }

    if (paymentMethod.isDefault) {
      _removeDefaultFromAll();
    }

    final updatedMethod = paymentMethod.copyWith(
      updatedAt: DateTime.now().toIso8601String(),
    );

    _mockPaymentMethods[index] = updatedMethod;

    // TODO: Replace with actual API call
    // final response = await paymentDatasource.updatePaymentMethod(paymentMethod.id, updatedMethod.toJson());
    // return PaymentMethodEntity.fromJson(response);

    return updatedMethod;
  }

  @override
  Future<void> deletePaymentMethod(int id) async {
    _initializeMockData();
    await Future.delayed(const Duration(milliseconds: 300));

    final method = _mockPaymentMethods.firstWhere(
      (m) => m.id == id,
      orElse: () => throw Exception('Payment method not found'),
    );

    final wasDefault = method.isDefault;
    _mockPaymentMethods.removeWhere((m) => m.id == id);

    if (wasDefault && _mockPaymentMethods.isNotEmpty) {
      final firstMethod = _mockPaymentMethods.first;
      final index = _mockPaymentMethods.indexOf(firstMethod);
      _mockPaymentMethods[index] = firstMethod.copyWith(isDefault: true);
    }

    // TODO: Replace with actual API call
    // await paymentDatasource.deletePaymentMethod(id);
  }

  @override
  Future<void> setDefaultPaymentMethod(int id) async {
    _initializeMockData();
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _mockPaymentMethods.indexWhere((m) => m.id == id);
    if (index == -1) {
      throw Exception('Payment method not found');
    }

    _removeDefaultFromAll();

    _mockPaymentMethods[index] = _mockPaymentMethods[index].copyWith(
      isDefault: true,
      updatedAt: DateTime.now().toIso8601String(),
    );

    // TODO: Replace with actual API call
    // await paymentDatasource.setDefaultPaymentMethod(id);
  }

  @override
  Future<PaymentMethodEntity?> getDefaultPaymentMethod() async {
    _initializeMockData();
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      return _mockPaymentMethods.firstWhere((method) => method.isDefault);
    } catch (e) {
      return _mockPaymentMethods.isNotEmpty ? _mockPaymentMethods.first : null;
    }
  }

  @override
  Future<bool> validatePaymentMethod(PaymentMethodEntity paymentMethod) async {
    await Future.delayed(const Duration(milliseconds: 200));

    if (paymentMethod.type.requiresPhoneNumber) {
      if (paymentMethod.phoneNumber == null || paymentMethod.phoneNumber!.isEmpty) {
        return false;
      }
      if (paymentMethod.phoneNumber!.length < 10) {
        return false;
      }
    }

    if (paymentMethod.type.requiresCardDetails) {
      if (paymentMethod.cardNumber == null || paymentMethod.cardNumber!.isEmpty) {
        return false;
      }
      if (paymentMethod.cardHolderName == null || paymentMethod.cardHolderName!.isEmpty) {
        return false;
      }
      if (paymentMethod.expiryDate == null || paymentMethod.expiryDate!.isEmpty) {
        return false;
      }
    }

    // TODO: Replace with actual API call
    // final response = await paymentDatasource.validatePaymentMethod(paymentMethod.toJson());
    // return response['isValid'] as bool;

    return true;
  }

  @override
  Future<Map<String, dynamic>> processPayment({
    required int paymentMethodId,
    required double amount,
    required String currency,
    Map<String, dynamic>? metadata,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));

    final paymentMethod = await getPaymentMethodById(paymentMethodId);
    if (paymentMethod == null) {
      throw Exception('Payment method not found');
    }

    // TODO: Replace with actual API call
    // final response = await paymentDatasource.processPayment({
    //   'paymentMethodId': paymentMethodId,
    //   'amount': amount,
    //   'currency': currency,
    //   'metadata': metadata,
    // });
    // return response;

    return {
      'success': true,
      'transactionId': 'TXN${DateTime.now().millisecondsSinceEpoch}',
      'amount': amount,
      'currency': currency,
      'paymentMethod': paymentMethod.displayTitle,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  void _removeDefaultFromAll() {
    for (int i = 0; i < _mockPaymentMethods.length; i++) {
      if (_mockPaymentMethods[i].isDefault) {
        _mockPaymentMethods[i] = _mockPaymentMethods[i].copyWith(isDefault: false);
      }
    }
  }
}
