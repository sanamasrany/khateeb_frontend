import 'package:get/get.dart';
import 'package:khateeb/pages/mvp/mvp_controller.dart';


class MvpPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<mvpController>(mvpController());
  }

}