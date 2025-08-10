import 'package:get/get.dart';
import 'package:on_track/controllers/view_controller.dart';

class ViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ViewController>(() => ViewController());
  }
}
