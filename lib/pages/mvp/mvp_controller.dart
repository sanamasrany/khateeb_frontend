import 'dart:convert';

import 'package:get/get.dart';
import 'package:khateeb/pages/mvp/mvp_service.dart';
import 'package:khateeb/utiles.dart';

class mvpController extends GetxController{


  var text='';
  var diacritizeStatus = false;
  var correctStatus = false;
  var correctStatustoshow = false.obs;
  var diacritize_text = ''.obs;
  var audioPath='';
  var showrecordeandtxt = true.obs;
  RxList<List<int>> highlights = <List<int>>[].obs;

  var loading = false.obs;
  var loading1 = false.obs;

  SecureStorage storage = SecureStorage();
  MvpService service = MvpService();

  @override
  void onInit() async{
    String jsonResponse = '{"ranges":[[1,2]]}';
    text = "هذا نص تجريبي لاختبار التلوين حسب الفهرس";
    updateFromJson(jsonResponse);

    super.onInit();
  }


  Future<void> diacritizeOnClick() async{
    loading(true);
    diacritizeStatus = await service.diacritize( text); // returns t or f
    loading(false);
    String? d =  await storage.read("diacritize_text");
    diacritize_text("$d");
  }


  Future<void> correctOnClick() async{
    loading1(true);
    correctStatus = await service.correct( text ,audioPath);
    loading1(false);
    String? jsonResponse =  await storage.read("correctinglist");
    updateFromJson(jsonResponse!);
    loading1(false);

  }
  void updateFromJson(String responseBody) {
    final decoded = jsonDecode(responseBody);
    final List<List<int>> parsedHighlights =
    (decoded['ranges'] as List).map((range) => List<int>.from(range)).toList();

    highlights.value = parsedHighlights;
  }

}