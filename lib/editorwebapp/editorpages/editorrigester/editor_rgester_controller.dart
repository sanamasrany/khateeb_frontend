import 'package:get/get.dart';
import 'package:khateeb/editorwebapp/editorpages/editorrigester/editor_rigester_service.dart';
import 'package:khateeb/models/country.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';


class EditorRegisterController extends GetxController{


  var password='' ;
  var email='';
  var first_name='' ;
  var last_name='';
  var bio='';
  RxnString selectedGender = RxnString('MALE');
  RxnString native_arabic = RxnString('true');
  var birthdate='';
  var registerStatus = false;
  var loading = false.obs;
  var countries = <Country>[].obs;
  var selectedCountryCode = ''.obs;
  var profileImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();
  EditorRegisterService service = EditorRegisterService();


  @override
  void onInit() {
    fetchCountries();
    super.onInit();
  }

  Future<void> RegisterOnClick() async{
    loading(true);
    registerStatus = await service.register(  password , email,first_name,last_name, bio ,  selectedGender.value ,
        birthdate , selectedCountryCode.value ,native_arabic.value , profileImage.value!.path); // returns t or f
    loading(false);
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source, imageQuality: 75);
    if (pickedFile != null) {
      profileImage.value = File(pickedFile.path);
    }
  }

  Future<void> fetchCountries() async {
    try {
      final response = await http.get(Uri.parse("https://restcountries.com/v3.1/all?fields=name,cca2"));
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        countries.value = data.map((json) => Country.fromJson(json)).toList()..sort((a, b) => a.name.compareTo(b.name)); ;
      } else {
        Get.snackbar("Error", "Failed to load countries");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }


}


