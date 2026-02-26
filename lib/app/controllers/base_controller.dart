import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entity/error_entity.dart';
import '../../core/utils/controller_logger.dart';

/// Base controller with built-in API error handling capabilities
abstract class BaseController extends GetxController {
  late final ControllerLogger logger = ControllerLogger(runtimeType.toString());

  // Reactive loading state
  final isLoading = false.obs;

  // Reactive general error message
  final _generalError = RxnString();

  /// Centralized API execution wrapper
  Future<T?> executeApiCall<T>(
    Future<T?> Function() apiCall, {
    VoidCallback? onSuccess,
    Function(String message)? onError,
  }) async {
    logger.controller('API Call started');
    final stopwatch = Stopwatch()..start();
    
    try {
      setLoading(true);
      clearGeneralError();

      final result = await apiCall();

      if (result != null) {
        setLoading(false);
        stopwatch.stop();
        logger.performance('API Call completed', stopwatch.elapsed);
        onSuccess?.call();
      }

      return result;
    } on BaseErrorEntity catch (error) {
      setLoading(false);
      stopwatch.stop();
      logger.error('API Call failed after ${stopwatch.elapsed.inMilliseconds}ms - BaseErrorEntity: ${error.message}');
      // Controller trusts repository-provided error messages
      _generalError.value = error.message;
      onError?.call(error.message);
      return null;
    } catch (e) {
      setLoading(false);
      stopwatch.stop();
      logger.error('API Call failed after ${stopwatch.elapsed.inMilliseconds}ms - Unexpected error', error: e);
      const message = "An unexpected error occurred";
      _generalError.value = message;
      onError?.call(message);
      return null;
    } finally {
      setLoading(false);
    }
  }

  /// Public accessors
  RxnString get generalError => _generalError;
  
  void clearGeneralError() {
    if (_generalError.value != null) {
      logger.controller('Clearing general error');
    }
    _generalError.value = null;
  }

  /// Loading state
  void setLoading(bool loading) {
    if (isLoading.value != loading) {
      logger.stateChange('loading', isLoading.value, loading);
    }
    isLoading.value = loading;
  }

  /// Manual error injection (optional for custom scenarios)
  void setGeneralError(String message) {
    logger.warning('General error set: $message');
    _generalError.value = message;
  }

  @override
  void onInit() {
    super.onInit();
    logger.initialized();
  }

  @override
  void onReady() {
    super.onReady();
    logger.ready();
  }

  @override
  void onClose() {
    logger.disposing();
    super.onClose();
  }
}
