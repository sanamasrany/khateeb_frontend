import 'dart:convert';
import 'package:http/http.dart' as http ;
import 'package:khateeb/custom.dart';
import '../../utiles.dart';
class MvpService{

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




}