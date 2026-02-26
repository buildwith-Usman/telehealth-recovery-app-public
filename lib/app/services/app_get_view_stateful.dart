import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class GetStatefulWidget<T extends GetxController>
    extends StatefulWidget {
  const GetStatefulWidget({super.key});

  final String? tag = null;

  T get controller => GetInstance().find<T>(tag: tag);
}
