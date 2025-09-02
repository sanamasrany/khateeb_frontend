import 'package:get/get.dart';
import 'package:khateeb/pages/register/register_controller.dart';

class RegisterPageBinging extends Bindings {
  @override
  void dependencies() {
    Get.put<RegisterController>(RegisterController());
  }

}