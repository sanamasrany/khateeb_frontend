import 'package:get/get.dart';
import 'package:khateeb/editorwebapp/editorpages/editorlogin/editor_login_controller.dart';

class EditorLoginPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<EditorloginController>(EditorloginController());
  }

}