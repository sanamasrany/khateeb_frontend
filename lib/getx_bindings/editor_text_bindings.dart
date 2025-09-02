import 'package:get/get.dart';
import 'package:khateeb/editorwebapp/editorpages/editorcreattext/editedtext_controller.dart';

class EditorTextPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<EditorTextController>(EditorTextController());
  }

}