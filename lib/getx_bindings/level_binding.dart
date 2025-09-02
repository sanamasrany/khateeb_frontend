import 'package:get/get.dart';
import 'package:khateeb/pages/level/level_controller.dart';

class LevelPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<LevelController>(LevelController());
  }

}