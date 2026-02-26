import 'package:flutter/foundation.dart';

class ControllerLogger {
  final String controllerName;
  
  ControllerLogger(this.controllerName);
  
  // ==================== CORE LOGGING METHODS ====================
  
  void controller(String message, {Map<String, dynamic>? params}) {
    if (kDebugMode) {
      final paramStr = params != null ? ' | Params: $params' : '';
      debugPrint('🎮 CONTROLLER: [$controllerName] $message$paramStr');
    }
  }

  void userAction(String action, {Map<String, dynamic>? params}) {
    if (kDebugMode) {
      final paramStr = params != null ? ' | Params: $params' : '';
      debugPrint('👆 USER: [$controllerName] $action$paramStr');
    }
  }

  void navigation(String event, {String? route, Map<String, dynamic>? arguments}) {
    if (kDebugMode) {
      final routeStr = route != null ? ' → $route' : '';
      final argStr = arguments != null ? ' | Args: $arguments' : '';
      debugPrint('🧭 NAVIGATION: [$controllerName] $event$routeStr$argStr');
    }
  }

  void stateChange(String property, dynamic oldValue, dynamic newValue) {
    if (kDebugMode) {
      debugPrint('🔄 REACTIVE: [$controllerName] $property: $oldValue → $newValue');
    }
  }

  void warning(String message) {
    if (kDebugMode) {
      debugPrint('⚠️  WARNING: [$controllerName] $message');
    }
  }

  void error(String message, {dynamic error}) {
    if (kDebugMode) {
      debugPrint('❌ ERROR: [$controllerName] $message${error != null ? ' | Error: $error' : ''}');
    }
  }

  void performance(String operation, Duration duration, {Map<String, dynamic>? metadata}) {
    if (kDebugMode) {
      final metaStr = metadata != null ? ' | Meta: $metadata' : '';
      debugPrint('⚡ PERFORMANCE: [$controllerName] $operation (${duration.inMilliseconds}ms)$metaStr');
    }
  }

  void method(String methodName, {String? params}) {
    if (kDebugMode) {
      final message = params != null 
        ? '$controllerName.$methodName($params)'
        : '$controllerName.$methodName()';
      debugPrint('📝 METHOD: $message');
    }
  }

  void apiCall(String endpoint, {String? method, Map<String, dynamic>? params}) {
    if (kDebugMode) {
      final methodStr = method ?? 'GET';
      final paramStr = params != null ? ' | Params: $params' : '';
      debugPrint('🌐 API: [$controllerName] $methodStr $endpoint$paramStr');
    }
  }

  // ==================== LIFECYCLE LOGGING ====================
  
  void initialized() {
    controller('initialized');
  }

  void ready() {
    controller('ready');
  }

  void disposing() {
    controller('disposing');
  }

  // ==================== UTILITY METHODS ====================
  
  /// Execute a block of code with performance logging
  Future<T> withPerformanceLogging<T>(
    String operationName,
    Future<T> Function() operation, {
    Map<String, dynamic>? metadata,
  }) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      final result = await operation();
      stopwatch.stop();
      performance(operationName, stopwatch.elapsed, metadata: metadata);
      return result;
    } catch (error) {
      stopwatch.stop();
      this.error('$operationName failed after ${stopwatch.elapsed.inMilliseconds}ms', error: error);
      rethrow;
    }
  }

  /// Execute a synchronous block of code with performance logging
  T withSyncPerformanceLogging<T>(
    String operationName,
    T Function() operation, {
    Map<String, dynamic>? metadata,
  }) {
    final stopwatch = Stopwatch()..start();
    
    try {
      final result = operation();
      stopwatch.stop();
      performance(operationName, stopwatch.elapsed, metadata: metadata);
      return result;
    } catch (error) {
      stopwatch.stop();
      this.error('$operationName failed after ${stopwatch.elapsed.inMilliseconds}ms', error: error);
      rethrow;
    }
  }
}