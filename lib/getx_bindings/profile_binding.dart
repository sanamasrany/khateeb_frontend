import 'package:get/get.dart';
import 'package:khateeb/pages/profile/profile_controller.dart';

class ProfilePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ProfileController>(ProfileController());
  }

}