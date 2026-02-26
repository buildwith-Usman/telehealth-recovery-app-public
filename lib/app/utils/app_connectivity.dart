import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class AppConnectivity extends WidgetsBindingObserver {
  AppConnectivity._internal();

  static final AppConnectivity instance = AppConnectivity._internal();

  Future<bool> isInternetAvailable() async {
    final checkConnectivity = await Connectivity().checkConnectivity();
    final result = (checkConnectivity.contains(ConnectivityResult.wifi) ||
        checkConnectivity.contains(ConnectivityResult.mobile) ||
        checkConnectivity.contains(ConnectivityResult.vpn) ||
        checkConnectivity.contains(ConnectivityResult.ethernet));
    return result;
  }

}
