import 'package:get/get.dart';
import 'package:khateeb/editorwebapp/editorpages/editorhome/editorhome.dart';

class EditorHomePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<EditorHomeController>(EditorHomeController());
  }

}