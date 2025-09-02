import 'dart:io';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:khateeb/pages/profile/profile_service.dart';
import 'package:khateeb/utiles.dart';

import '../../models/portifolio.dart';

class ProfileController extends GetxController {

  var first_name = ''.obs;
  var last_name = ''.obs;
  var bio = ''.obs;
  var gender = ''.obs;
  var native_arabic = ''.obs;
  var birthdate = ''.obs;
  var profileImageurl = ''.obs;





  @override
  void onInit() async{
    await fetchPortfolios();
    String? f =  await storage.read("first_name");
    String? l =  await storage.read("last_name");
    String? b =  await storage.read("bio");
    String? g =  await storage.read("gender");
    String? bd =  await storage.read("birthdate");
    String? phot =  await storage.read("photo");

    first_name("$f");
    last_name("$l");
    bio("$b");
    gender("$g");
    birthdate("$bd");
    profileImageurl("$phot");
    //   last_name = (await storage.read("last_name"));
    print(first_name);

    super.onInit();
  }

  var first_name_new= '';
  var last_name_new='';
  var bio_new='';
  RxnString gender_new = RxnString('');
  RxnString native_arabic_new = RxnString('');
  var birthdate_new='';
  var profileImage_new = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  var editprofileStatus = false;

  var showeditstuff = false.obs;

  ProfileService service = ProfileService();
  SecureStorage storage = SecureStorage();




  Future<void> EditProfileOnClick() async{

    editprofileStatus = await service.Edituserinfo( first_name_new , last_name_new, bio_new ,gender_new.value , birthdate_new); // returns t or f

  }

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source, imageQuality: 75);
    if (pickedFile != null) {
      profileImage_new.value = File(pickedFile.path);
    }
  }

  var portfolios = <Portfolio>[].obs;
  var isLoading = false.obs;

  Future<void> fetchPortfolios() async {
    String? savedtoken = await storage.read("token");
    String? savedemail = await storage.read("email");

    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse("${Utiles.baseurl}/portfolios/?search=${savedemail.toString()}"),
        headers:{
          'Authorization' : 'JWT ${savedtoken.toString()}',
        },
      );
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        print(data);
        portfolios.value = data.map((e) => Portfolio.fromJson(e)).toList();
      } else {
        Get.snackbar("Error", "Failed to fetch portfolios");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
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