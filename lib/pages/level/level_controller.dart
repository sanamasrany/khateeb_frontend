import 'dart:convert';

import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:khateeb/models/errorshow.dart';

import '../../utiles.dart';
import 'level_service.dart';
import 'package:http/http.dart' as http ;

class LevelController extends GetxController{

  var text='';
  var diacritizeStatus = false;
  var correctStatus = false;
  var correctStatustoshow = false.obs;
  var diacritize_text = ''.obs;
  var audioPath='';
  var showrecordeandtxt = true.obs;
  double results_wer = 0;
  double results_der = 0;
  double results_cer = 0;
  var predicted_text = '';

  var loading = false.obs;
  var loading1 = false.obs;

  var loadingadd = false.obs;
  var addStatus = false;

  var isPublic = true.obs;

  var aftershakilni = true.obs;
  var editpart = false.obs;

  var loadingsave = false.obs;
  var diacritizationerrorStatus = false;

  var loadingprotest = false.obs;
  var protestStatus = false;
  var usertext ='';
  var notetext = '';
  var textid = '';

  var diacritize_text1 = ''.obs;
  RxList<HighlightRange> highlights = <HighlightRange>[].obs;

  //ghassan adding
  var showrecordoption = false.obs;

  SecureStorage storage = SecureStorage();
  LevelService service = LevelService();

  @override
  void onInit() async{
    String jsonResponse = '{"ranges":[[1,2]] , "predicted_text": "ال" , "wer":0 , "der":0 , "cer":0 }';
    text = "هذا نص تجريبي لاختبار التلوين حسب الفهرس";
    updateFromJson(jsonResponse);
    aftershakilni(true);
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

  List<String> correctTextWords = [] ;

  void updateFromJson(String responseBody) {
    final decoded = jsonDecode(responseBody);

    predicted_text = decoded['predicted_text'];
    results_wer = (decoded['wer'] as num).toDouble();
    results_der = (decoded['der'] as num).toDouble();
    results_cer = (decoded['cer'] as num).toDouble();

    final rangesJson = decoded['ranges']['ranges'] as List;
    highlights.value = rangesJson.map((r) => HighlightRange.fromJson(r)).toList();

    diacritize_text1.value = decoded['ranges']['correct_text'] as String;

    correctTextWords = diacritize_text1.value.split(' ');
  }

  Future<void> addtoportifolioOnClick() async{
    loadingadd(true);
    addStatus = await service.createportifolio(audioPath, textid);
    loadingadd(false);

  }

  Future<void> protestOnClick() async{
    loadingprotest(true);
    protestStatus = await service.protestaudio( predicted_text , usertext  ,  audioPath ,notetext); // returns t or f
    loadingprotest(false);

  }

  //tts adding
  final player = AudioPlayer();
  var audioUrl = "".obs;

  var gettingaudiolouding= false.obs;
  var gettingaudiostatuse = false;

  var ihavetheaudio = false.obs;


  Future<void> fetchAudio(String text) async {
    try {
      gettingaudiolouding.value = true;
      print(text);

      final response = await http.post(
        Uri.parse("${Utiles.baseurl}/utilities/tts/"),
        body:
        {
          "text": text,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        audioUrl.value = data["audio_url"];
        print(data);

        // Load into player
        await player.setUrl(audioUrl.value);
      } else {
        print("Error: ${response.body}");
      }
    } catch (e) {
      print("Exception: $e");
    } finally {
      gettingaudiolouding.value = false;
    }
  }
  var isPlaying = false.obs;

  void playAudio() {
    player.play();
    isPlaying(true);
  }

  void pauseAudio() {
    player.pause();
    isPlaying(false);
  }

  void stopAudio() {
    player.stop();
    isPlaying(false);
  }

  @override
  void onClose() {
    player.dispose();
    super.onClose();
  }



}