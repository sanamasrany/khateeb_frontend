import 'package:get/get.dart';
import 'package:khateeb/pages/home/home_controller.dart';

class HomePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<homeController>(homeController());
  }

}