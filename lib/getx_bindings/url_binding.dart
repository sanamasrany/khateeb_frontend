import 'package:get/get.dart';
import 'package:khateeb/pages/URL/url_controller.dart';

class UrlPageBinging extends Bindings {
  @override
  void dependencies() {
    Get.put<urlController>(urlController());
  }

}