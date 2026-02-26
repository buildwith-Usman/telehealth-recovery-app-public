import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:async';

/// Enhanced controller with improved state management
abstract class BaseController extends GetxController {
  // Loading states
  final _isLoading = false.obs;
  final _isRefreshing = false.obs;
  final _loadingStates = <String, bool>{}.obs;

  // Error handling
  final _errorMessage = ''.obs;
  final _errors = <String, String>{}.obs;

  // Network status
  final _isOnline = true.obs;

  // Computed getters
  bool get isLoading => _isLoading.value;
  bool get isRefreshing => _isRefreshing.value;
  String get errorMessage => _errorMessage.value;
  bool get isOnline => _isOnline.value;
  bool get hasError => _errorMessage.value.isNotEmpty;

  // Loading state for specific operations
  bool isLoadingOperation(String operation) =>
      _loadingStates[operation] ?? false;
  String getError(String key) => _errors[key] ?? '';

  /// Set loading state for entire controller
  void setLoading(bool loading) {
    _isLoading.value = loading;
  }

  /// Set loading state for specific operation
  void setOperationLoading(String operation, bool loading) {
    _loadingStates[operation] = loading;
  }

  /// Set error message
  void setError(String message, [String? key]) {
    if (key != null) {
      _errors[key] = message;
    } else {
      _errorMessage.value = message;
    }
  }

  /// Clear errors
  void clearErrors([String? key]) {
    if (key != null) {
      _errors.remove(key);
    } else {
      _errorMessage.value = '';
      _errors.clear();
    }
  }

  /// Set refresh state
  void setRefreshing(bool refreshing) {
    _isRefreshing.value = refreshing;
  }

  /// Network status
  void setNetworkStatus(bool online) {
    _isOnline.value = online;
  }

  /// Safe API call wrapper
  Future<T?> safeApiCall<T>(
    Future<T> Function() apiCall, {
    String? operation,
    bool showGlobalLoading = true,
    String? errorKey,
    Function(String)? onError,
  }) async {
    try {
      // Clear previous errors
      clearErrors(errorKey);

      // Set loading states
      if (showGlobalLoading) setLoading(true);
      if (operation != null) setOperationLoading(operation, true);

      // Make API call
      final result = await apiCall();
      return result;
    } catch (e) {
      final errorMsg = e.toString();
      setError(errorMsg, errorKey);
      onError?.call(errorMsg);
      return null;
    } finally {
      // Clear loading states
      if (showGlobalLoading) setLoading(false);
      if (operation != null) setOperationLoading(operation, false);
    }
  }

  /// Debounced method executor
  Timer? _debounceTimer;
  void debounceMethod(VoidCallback method,
      [Duration delay = const Duration(milliseconds: 300)]) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(delay, method);
  }

  @override
  void onClose() {
    _debounceTimer?.cancel();
    super.onClose();
  }
}

/// State management for lists with pagination
mixin ListStateMixin<T> on BaseController {
  final _items = <T>[].obs;
  final _hasMore = true.obs;
  final _currentPage = 1.obs;
  final _isLoadingMore = false.obs;

  RxList<T> get items => _items;
  bool get hasMore => _hasMore.value;
  int get currentPage => _currentPage.value;
  bool get isLoadingMore => _isLoadingMore.value;

  void setItems(List<T> newItems, {bool append = false}) {
    if (append) {
      _items.addAll(newItems);
    } else {
      _items.value = newItems;
    }
  }

  void addItem(T item) {
    _items.add(item);
  }

  void removeItem(T item) {
    _items.remove(item);
  }

  void updateItem(int index, T item) {
    if (index >= 0 && index < _items.length) {
      _items[index] = item;
    }
  }

  void setHasMore(bool hasMore) {
    _hasMore.value = hasMore;
  }

  void setCurrentPage(int page) {
    _currentPage.value = page;
  }

  void nextPage() {
    _currentPage.value++;
  }

  void resetPagination() {
    _currentPage.value = 1;
    _hasMore.value = true;
    _items.clear();
  }

  void setLoadingMore(bool loading) {
    _isLoadingMore.value = loading;
  }

  /// Load more items
  Future<void> loadMore(Future<List<T>> Function(int page) loader) async {
    if (!hasMore || isLoadingMore) return;

    setLoadingMore(true);
    try {
      final newItems = await loader(currentPage);
      if (newItems.isEmpty) {
        setHasMore(false);
      } else {
        setItems(newItems, append: true);
        nextPage();
      }
    } catch (e) {
      setError('Failed to load more items');
    } finally {
      setLoadingMore(false);
    }
  }
}

/// Form state management mixin
mixin FormStateMixin on BaseController {
  final _formData = <String, dynamic>{}.obs;
  final _formErrors = <String, String>{}.obs;
  final _isFormValid = false.obs;

  Map<String, dynamic> get formData => _formData;
  bool get isFormValid => _isFormValid.value;

  void setFormField(String key, dynamic value) {
    _formData[key] = value;
    _formErrors.remove(key); // Clear error when field is updated
    _validateForm();
  }

  dynamic getFormField(String key) => _formData[key];

  void setFormError(String key, String error) {
    _formErrors[key] = error;
    _validateForm();
  }

  String getFormError(String key) => _formErrors[key] ?? '';

  void clearFormErrors() {
    _formErrors.clear();
    _validateForm();
  }

  void resetForm() {
    _formData.clear();
    _formErrors.clear();
    _isFormValid.value = false;
  }

  void _validateForm() {
    _isFormValid.value = _formErrors.isEmpty && _formData.isNotEmpty;
  }

  /// Validate specific field
  bool validateField(String key, String? Function(dynamic) validator) {
    final value = _formData[key];
    final error = validator(value);
    if (error != null) {
      setFormError(key, error);
      return false;
    } else {
      _formErrors.remove(key);
      return true;
    }
  }
}
