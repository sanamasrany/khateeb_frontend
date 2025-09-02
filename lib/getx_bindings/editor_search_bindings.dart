import 'package:get/get.dart';
import 'package:khateeb/editorwebapp/editorpages/editorsearch/editorsearch_controller.dart';

class EditorSearchPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<EditorSearchPageController>(EditorSearchPageController());
  }

}