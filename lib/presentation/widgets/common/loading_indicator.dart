import 'package:get/get.dart';

import '../indicator/loading_indicator_widget.dart';

/// Show loading indicator
void showLoadingIndicator({
  Duration duration = const Duration(milliseconds: 100),
}) {
  Future.delayed(duration, () async {
    Get.generalDialog(
      pageBuilder: (_, __, ___) {
        return const LoadingIndicatorWidget();
      },
      transitionDuration: const Duration(),
    );
  });
}

/// Hide loading indicator
void hideLoadingIndicator() {
  Get.back();
}
