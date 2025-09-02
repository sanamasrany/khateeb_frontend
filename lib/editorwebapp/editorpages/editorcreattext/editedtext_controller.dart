import 'dart:convert';
import 'package:get/get.dart';
import 'package:khateeb/editorwebapp/editorpages/editorcreattext/editedtext_service.dart';
import 'package:khateeb/utiles.dart';

class EditorTextController extends GetxController{

  var text='';
  var diacritizeStatus = false;
  var correctStatus = false;
  var correctStatustoshow = false.obs;
  var diacritize_text = ''.obs;
  var audioPath='';
  var showrecordeandtxt = true.obs;
  RxList<List<int>> highlights = <List<int>>[].obs;
  double results_wer = 0;
  double results_der = 0;
  double results_cer = 0;
  var predicted_text = '';

  var loading = false.obs;
  var loading1 = false.obs;

  var loadingadd = false.obs;
  var addStatus = false;

  var isPublic = true.obs;

  var aftershakilni = false.obs;
  var editpart = false.obs;

  var loadingsave = false.obs;
  var diacritizationerrorStatus = false;

  var loadingprotest = false.obs;
  var protestStatus = false;
  var usertext ='';
  var notetext = '';



  SecureStorage storage = SecureStorage();
  EditorTextService service = EditorTextService();

  @override
  void onInit() async{
    String jsonResponse = '{"ranges":[[1,2]] , "predicted_text": "ال" , "wer":0 , "der":0 , "cer":0 }';
    text = "هذا نص تجريبي لاختبار التلوين حسب الفهرس";
    updateFromJson(jsonResponse);
    aftershakilni(false);
    editpart(false);

    super.onInit();
  }


  Future<void> diacritizeOnClick() async{
    loading(true);
    diacritizeStatus = await service.diacritize( text); // returns t or f
    loading(false);
    String? d =  await storage.read("diacritize_text");
    diacritize_text("$d");
    aftershakilni(true);
  }


  Future<void> correctOnClick() async{
    loading1(true);
    correctStatus = await service.correct( text ,audioPath);
    loading1(false);
    String? jsonResponse =  await storage.read("correctinglist");
    updateFromJson(jsonResponse!);
    loading1(false);

  }

  Future<void> diacritizationerrorOnClick() async{
    loadingsave(true);
    diacritizationerrorStatus = await service.diacritizationerror( diacritize_text.value ,text);
    loadingsave(false);


  }

  void updateFromJson(String responseBody) {
    final decoded = jsonDecode(responseBody);
    final List<List<int>> parsedHighlights =
    (decoded['ranges'] as List).map((range) => List<int>.from(range)).toList();
    predicted_text = decoded['predicted_text'] ;

    results_wer = (decoded['wer'] as num).toDouble() ;
    results_der =  (decoded['der'] as num).toDouble();
    results_cer =  (decoded['cer']as num).toDouble();
    highlights.value = parsedHighlights;
  }

  Future<void> addtoportifolioOnClick() async{
    loadingadd(true);
    addStatus = await service.addtext( text , "${isPublic.value}"); // returns t or f
    loadingadd(false);

  }

  Future<void> protestOnClick() async{
    loadingprotest(true);
    protestStatus = await service.protestaudio( predicted_text , usertext  ,  audioPath ,notetext); // returns t or f
    loadingprotest(false);

  }





}