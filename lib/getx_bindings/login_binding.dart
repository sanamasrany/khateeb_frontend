import 'package:get/get.dart';
import 'package:khateeb/pages/login/login_controller.dart';

class LoginPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<loginController>(loginController());
  }

}