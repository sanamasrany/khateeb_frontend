import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:khateeb/utiles.dart';

class EditorSearchPageController extends GetxController{
  var filteredUsers = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;


  Future<void> search(String query) async {
    if (query.isEmpty) {
      filteredUsers.clear();
      return;
    }
    try {
      isLoading.value = true;
      final url = Uri.parse("${Utiles.baseurl}/users/?search=$query");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        filteredUsers.value = List<Map<String, dynamic>>.from(data);
      } else {
        Get.snackbar("Error", "Failed to load results");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}