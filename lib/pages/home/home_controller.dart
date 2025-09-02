import 'dart:convert';

import 'package:get/get.dart';
import 'package:khateeb/pages/home/home_service.dart';
import 'package:khateeb/utiles.dart';
import 'package:http/http.dart' as http;

import '../../models/levels.dart';


class homeController extends GetxController{
  var selectedFab = ''.obs;

  var username = 'User name'.obs;

  var profileStatus = false;
  var mytextshow = false.obs;
  var textshow = true.obs;
  var assignmentshow = false.obs;

  var levels = <Level>[].obs;
  var myLevels = <Level>[].obs;
  var myassignment = <Level1>[].obs;
  var isLoading = false.obs;

  SecureStorage storage = SecureStorage();
  HomeService service = HomeService();

  @override
  void onInit() async{
    await fetchLevels();
  }

  Future<void> fetchLevels() async {
    isLoading.value = true;
    String? savedtoken = await storage.read("token");
    String? saveduserid = await storage.read("userid");
    try {
      final response = await http.get(Uri.parse("${Utiles.baseurl}/texts/"),
        headers:{
        'Authorization' : 'JWT ${savedtoken.toString()}',
        },
      );
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        levels.value = data.map((e) => Level.fromJson(e)).toList();
        print(data);
        if (saveduserid != null) {
          myLevels.value = levels.where((level) => level.createdById == saveduserid).toList();
          print(myLevels.value);
        } else {
          myLevels.clear();
        }
      } else {
        Get.snackbar("Error", "Failed to fetch levels");
      }
      //assignment
      final response1 = await http.get(Uri.parse("${Utiles.baseurl}/assignments/"),
        headers:{
          'Authorization' : 'JWT ${savedtoken.toString()}',
        },
      );
      if (response1.statusCode == 200) {
        final List data = jsonDecode(response1.body);
        myassignment.value = data.map((e) => Level1.fromJson(e)).toList();
        print("++++++++++++++++ assignments");
        print(data);
      } else {
        Get.snackbar("Error", "Failed to fetch levels");
      }

    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }


}