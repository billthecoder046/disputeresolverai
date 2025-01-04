import 'package:get/get.dart';
import 'logic.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatScreenLogic>(() => ChatScreenLogic());
  }
}
