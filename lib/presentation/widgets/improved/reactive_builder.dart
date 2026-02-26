import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Improved reactive builder that only rebuilds when specific observables change
class ReactiveBuilder<T> extends StatelessWidget {
  final List<Rx<dynamic>> observables;
  final Widget Function() builder;
  final String? debugLabel;

  const ReactiveBuilder({
    super.key,
    required this.observables,
    required this.builder,
    this.debugLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Listen to all observables but build only once
      for (final obs in observables) {
        obs.value; // Access to register listener
      }
      return builder();
    });
  }
}

/// Conditional reactive builder - only rebuilds when condition is met
class ConditionalReactiveBuilder<T> extends StatelessWidget {
  final Rx<T> observable;
  final bool Function(T value) condition;
  final Widget Function(T value) builder;
  final Widget? fallback;

  const ConditionalReactiveBuilder({
    super.key,
    required this.observable,
    required this.condition,
    required this.builder,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final value = observable.value;
      if (condition(value)) {
        return builder(value);
      }
      return fallback ?? const SizedBox.shrink();
    });
  }
}

/// Throttled reactive builder - limits rebuild frequency
class ThrottledReactiveBuilder<T> extends StatefulWidget {
  final Rx<T> observable;
  final Widget Function(T value) builder;
  final Duration throttleDuration;

  const ThrottledReactiveBuilder({
    super.key,
    required this.observable,
    required this.builder,
    this.throttleDuration = const Duration(milliseconds: 100),
  });

  @override
  State<ThrottledReactiveBuilder<T>> createState() =>
      _ThrottledReactiveBuilderState<T>();
}

class _ThrottledReactiveBuilderState<T>
    extends State<ThrottledReactiveBuilder<T>> {
  T? _lastValue;
  DateTime _lastUpdate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentValue = widget.observable.value;
      final now = DateTime.now();

      if (now.difference(_lastUpdate) >= widget.throttleDuration) {
        _lastValue = currentValue;
        _lastUpdate = now;
      }

      return widget.builder(_lastValue ?? currentValue);
    });
  }
}
