import 'package:get/get.dart';
import 'package:khateeb/editorwebapp/editorpages/editorrigester/editor_rgester_controller.dart';

class EditorRigesterPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<EditorRegisterController>(EditorRegisterController());
  }

}