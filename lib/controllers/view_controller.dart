import 'dart:ui';

import 'package:get/get.dart';

class ViewController extends GetxController {
  var state = Brightness.dark.obs;
  void updateTheme(Brightness theme) {
    state.value = theme;
  }
}
