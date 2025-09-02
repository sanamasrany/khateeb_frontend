import 'package:get/get.dart';

import '../pages/text/text_controller.dart';

class TextPageBinging extends Bindings {
  @override
  void dependencies() {
    Get.put<TextController>(TextController());
  }

}