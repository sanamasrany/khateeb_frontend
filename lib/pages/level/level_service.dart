import 'dart:convert';
import 'package:http/http.dart' as http ;
import 'package:khateeb/custom.dart';
import '../../utiles.dart';
class LevelService{

  var diacritize_text;
  var correctinglist ;

  SecureStorage storage = SecureStorage();


  Future<bool> diacritize (String text ) async { // async and await for making any comand after wait till this ends

    //get url
    String? savedurl = await storage.read("baseurl");
    print("saved URL:");
    print(savedurl);
    var url = Uri.parse('${savedurl}/diacritize-text');

    var response = await http.post(url,
        body: {
          'text': text,
        }
    );
    print(response.statusCode);
    print(response.body);

    if(response.statusCode == 200){
      var replay = jsonDecode(response.body);
      diacritize_text = replay['result'];

      //save token to device
      SecureStorage storage = SecureStorage();

      await storage.save('diacritize_text', diacritize_text);

      String? saveddiacritize_text = await storage.read("diacritize_text");
      print("++++++++++++++++++++++++++++++++++++++++++++++");
      print(saveddiacritize_text);
      print("++++++++++++++++++++++++++++++++++++++++++++++");

      return true;
    }else if (response.statusCode == 400){
      var replay = jsonDecode(response.body);
      String replayshow = replay.toString();
      showToast(text:replayshow ,state: ToastStates.EROOR);
      return false;
    }else {
      var replay = jsonDecode(response.body);
      String replayshow = replay['detail'].toString();
      showToast(text:replayshow ,state: ToastStates.EROOR);
      return false;
    }
  }


  Future<bool> correct(String text , String audioPath) async { // async and await for making any comand after wait till this ends
    print(text);
    print(audioPath);

    String? savedurl = await storage.read("baseurl");
    print("saved URL:");
    print(savedurl);
    var url1 = Uri.parse('${savedurl}/compare-text-audio');


    var request = http.MultipartRequest('POST',
        url1);
    request.fields.addAll({
      'text': text,

    });

    request.files.add(await http.MultipartFile.fromPath('audio', audioPath));

    http.StreamedResponse response = await request.send();
    print(response.statusCode);
    if(response.statusCode == 200) {
      // Map<String,dynamic> replay = jsonDecode(await response.stream.bytesToString());
      // correctinglist = replay['results'];
      var correctinglist = await response.stream.bytesToString();
      print(correctinglist);

      //save token to device
      SecureStorage storage = SecureStorage();

      await storage.save('correctinglist', correctinglist);


      String? savedcorrectinglist = await storage.read("correctinglist");
      print("++++++++++++++++++++++++++++++++++++++++++++++");
      print(savedcorrectinglist);
      print("++++++++++++++++++++++++++++++++++++++++++++++");


      return true;

    }else if (response.statusCode == 403){
      var errormasg = await response.stream.bytesToString();
      print(errormasg);
      showToast(text:errormasg.toString() ,state: ToastStates.EROOR);
      return false;
    }else if (response.statusCode == 400){
      var errormasg = await response.stream.bytesToString();
      print(errormasg);
      showToast(text:errormasg.toString() ,state: ToastStates.EROOR);
      return false;
    } else {
      var errormasg = await response.stream.bytesToString();
      print(errormasg);
      showToast(text:errormasg.toString() ,state: ToastStates.EROOR);
      return false;
    }
  }


  Future<bool> addtext (String text, String is_public ) async { // async and await for making any comand after wait till this ends

    //get url
    print(text);
    print(is_public);

    var url = Uri.parse('${Utiles.baseurl}/texts/');
    SecureStorage storage = SecureStorage();
    String? token = await storage.read("token");
    print(token);

    var response = await http.post(url,
        headers: {
          'Authorization': 'JWT ${token}',
        },
        body: {
          'text': text,
          'is_public': is_public ,
        }
    );
    print(response.statusCode);
    print(response.body);

    if(response.statusCode == 201){
      var replay = jsonDecode(response.body);
      var newtextid = replay["id"].toString();

      SecureStorage storage = SecureStorage();
      await storage.save('newtextid', newtextid);

      return true;
    }else if (response.statusCode == 400){
      var replay = jsonDecode(response.body);
      String replayshow = replay.toString();
      showToast(text:replayshow ,state: ToastStates.EROOR);
      return false;
    }else {
      var replay = jsonDecode(response.body);
      String replayshow = replay['detail'].toString();
      showToast(text:replayshow ,state: ToastStates.EROOR);
      return false;
    }
  }

  Future<bool> createportifolio(String audioPath ,String text ) async { // async and await for making any comand after wait till this ends

    print(audioPath);
    print(text);

    var url1 = Uri.parse('${Utiles.baseurl}/portfolios/');

    SecureStorage storage = SecureStorage();
    String? token = await storage.read("token");
    print(token);

    var headers = {
      'Authorization': 'JWT ${token}'
    };

    var request = http.MultipartRequest('POST',
        url1);
    request.fields.addAll({
      'text': text,

    });

    request.files.add(await http.MultipartFile.fromPath('recorde_file', audioPath));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    print(response.statusCode);

    if(response.statusCode == 201) {
      var msg = await response.stream.bytesToString();
      print(msg);
      showToast(text:"تمت الاضافة الى معرض الاعمال" ,state: ToastStates.SUCCESS ,fontsize: 20);


      return true;

    }else if (response.statusCode == 403){
      var errormasg = await response.stream.bytesToString();
      print(errormasg);
      showToast(text:errormasg.toString() ,state: ToastStates.EROOR);
      return false;
    }else if (response.statusCode == 400){
      var errormasg = await response.stream.bytesToString();
      print(errormasg);
      showToast(text:errormasg.toString() ,state: ToastStates.EROOR);
      return false;
    } else {
      var errormasg = await response.stream.bytesToString();
      print(errormasg);
      showToast(text:errormasg.toString() ,state: ToastStates.EROOR);
      return false;
    }
  }

  Future<bool> diacritizationerror (String app_text, String user_text ) async { // async and await for making any comand after wait till this ends

    SecureStorage storage = SecureStorage();
    String? token = await storage.read("token");
    print(token);

    var url = Uri.parse('${Utiles.baseurl}/utilities/diacritization-error/');

    var response = await http.post(url,
        headers: {
          'Authorization': 'JWT ${token}',
        },
        body: {
          'app_text': app_text,
          'user_text':user_text,
        }
    );
    print(response.statusCode);
    print(response.body);

    if(response.statusCode == 201){
      var replay = jsonDecode(response.body);
      print(replay);
      showToast(text:"تم الحفظ يمكنك التدرب الآن" ,state: ToastStates.SUCCESS ,fontsize: 20);


      return true;
    }else if (response.statusCode == 400){
      var replay = jsonDecode(response.body);
      String replayshow = replay.toString();
      showToast(text:replayshow ,state: ToastStates.EROOR);
      return false;
    }else {
      var replay = jsonDecode(response.body);
      String replayshow = replay['detail'].toString();
      showToast(text:replayshow ,state: ToastStates.EROOR);
      return false;
    }
  }

  Future<bool> protestaudio(String extracted_text , String user_text,String audioPath ,String notes ) async { // async and await for making any comand after wait till this ends

    var url1 = Uri.parse('${Utiles.baseurl}/utilities/audio-compare-error/');

    SecureStorage storage = SecureStorage();
    String? token = await storage.read("token");
    print(token);

    var headers = {
      'Authorization': 'JWT ${token}'
    };

    var request = http.MultipartRequest('POST',
        url1);
    request.fields.addAll({
      'extracted_text': extracted_text,
      'user_text': user_text,
      'notes': notes,

    });

    request.files.add(await http.MultipartFile.fromPath('audio_file', audioPath));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    print(response.statusCode);

    if(response.statusCode == 201) {
      var msg = await response.stream.bytesToString();
      print(msg);
      showToast(text:"تم ارسال الاعتراض سيقوم احد خبرائنا من التحقق منه, شكرا لك" ,state: ToastStates.SUCCESS ,fontsize: 20);


      return true;

    }else if (response.statusCode == 403){
      var errormasg = await response.stream.bytesToString();
      print(errormasg);
      showToast(text:errormasg.toString() ,state: ToastStates.EROOR);
      return false;
    }else if (response.statusCode == 400){
      var errormasg = await response.stream.bytesToString();
      print(errormasg);
      showToast(text:errormasg.toString() ,state: ToastStates.EROOR);
      return false;
    } else {
      var errormasg = await response.stream.bytesToString();
      print(errormasg);
      showToast(text:errormasg.toString() ,state: ToastStates.EROOR);
      return false;
    }
  }


}