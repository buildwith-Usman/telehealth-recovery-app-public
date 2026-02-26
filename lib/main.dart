import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/config/app_config.dart';
import 'app/config/app_pages.dart';
import 'app/environments/environment.dart';
import 'app/services/app_storage.dart';
import 'app/services/cart_service.dart';
import 'app/services/localization_service.dart';
import 'app/services/role_manager.dart';
import 'app/utils/global.dart';
import 'generated/locales.g.dart';

void main() async {
  // Init widgets
  WidgetsFlutterBinding.ensureInitialized();
  await AppStorage.instance.ensureInitialized();

  // Initialize Role Manager
  Get.put(RoleManager(), permanent: true );

  // Initialize Cart Service
  Get.put(CartService(), permanent: true);

  // Init environment
  String environment = const String.fromEnvironment(
    'ENV',
    // defaultValue: AppService().savedEnv ?? Environment.liv,
    defaultValue: Environment.dev,
  );
  // Init config for app based on environment
 AppConfig(env: Environment.getConfigEnvironment(environment));

  runApp(const RecoveryConsultationMobileApp());
}

class RecoveryConsultationMobileApp extends StatelessWidget {
  const RecoveryConsultationMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translationsKeys: AppTranslation.translations,
      locale: LocalizationService.locale,
      initialRoute: AppPages.appInitialRoute,
      getPages: AppPages.pages,
      theme: primaryTheme,
      navigatorObservers: [navigationObserver],
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      navigatorKey: navigatorKey,
    );
  }
}
