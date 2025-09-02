import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:khateeb/utiles.dart';
import 'dart:convert';
import '../../models/portifolio.dart';


class UserPortfolioController extends GetxController {
  var portfolios = <Portfolio>[].obs;
  var isLoading = false.obs;

  Future<void> fetchPortfolios(String email) async {
    try {
      isLoading.value = true;
      final url = Uri.parse("${Utiles.baseurl}/portfolios/?search=$email");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        portfolios.value = data.map((e) => Portfolio.fromJson(e)).toList();
      } else {
        portfolios.clear();
      }
    } catch (e) {
      print("Error fetching portfolios: $e");
      portfolios.clear();
    } finally {
      isLoading.value = false;
    }
  }

  final player = AudioPlayer();

  var isPlaying = false.obs;
  var currentPlayingId = RxnInt();

  Future<void> playAudio(int id, String url) async {
    try {
      await player.setUrl(url);
      player.play();
      currentPlayingId.value = id;

      player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          currentPlayingId.value = null;
        }
      });
    } catch (e) {
      print("Error playing audio: $e");
      currentPlayingId.value = null;
    }
  }

  Future<void> stopAudio() async {
    await player.pause();
    currentPlayingId.value = null;
  }

  @override
  void onClose() {
    player.dispose();
    super.onClose();
  }
}
