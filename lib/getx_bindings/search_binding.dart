import 'package:get/get.dart';
import 'package:khateeb/pages/search/search_controller.dart';

class SearchPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SearchPageController>(SearchPageController());
  }
}