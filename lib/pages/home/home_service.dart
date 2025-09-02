import 'dart:convert';

import 'package:khateeb/custom.dart';
import 'package:khateeb/utiles.dart';
import 'package:http/http.dart' as http ;

class HomeService {


  String Userid = '';
  var email1;
  var last_name1;
  var first_name1;
  var bio1;
  var gender1;
  var birthdate1;

  var url = Uri.parse('${Utiles.baseurl}/auth/users/me/');
  var urllogout1 = Uri.parse('${Utiles.baseurl}/api/logout-user/');
  var urllogout2 = Uri.parse('${Utiles.baseurl}/api/logoutall-user/');


  // Future<bool> Getuser () async { // async and await for making any comand after wait till this ends
  //
  //   SecureStorage storage = SecureStorage();
  //   String? savedtoken = await storage.read("token");
  //   print(savedtoken);
  //
  //   var response = await http.get(url,
  //     headers:{
  //       'Authorization' : 'JWT ${savedtoken.toString()}',
  //     },
  //
  //   );
  //   print(response.statusCode);
  //   print(response.body);
  //
  //   if(response.statusCode == 200){
  //     var replay = jsonDecode(response.body);
  //     // token = replay['token'];
  //     Userid = replay['id'].toString();
  //     email1 = replay['email'];
  //     first_name1 = replay['first_name'];
  //     last_name1 = replay['last_name'];
  //     bio1 = replay['bio'];
  //     gender1 = replay['gender'];
  //     birthdate1 = replay['birthdate'];
  //
  //     //save token to device
  //     SecureStorage storage = SecureStorage();
  //
  //     // await storage.save('token', token);
  //     await storage.save('userid', Userid);
  //     await storage.save('email', email1);
  //     await storage.save('first_name', first_name1);
  //     await storage.save('last_name', last_name1);
  //     await storage.save('bio', bio1);
  //     await storage.save('gender', gender1);
  //     await storage.save('birthdate', birthdate1);
  //
  //     // String? savedtoken = await storage.read("token");
  //     String? savedid= await storage.read("userid");
  //     print("++++++++++++++++++++++++++++++++++++++++++++++");
  //     // print(savedtoken);
  //     print(savedid);
  //     print("++++++++++++++++++++++++++++++++++++++++++++++");
  //
  //     return true;
  //   }else if (response.statusCode == 400){
  //     var replay = jsonDecode(response.body);
  //     String replayshow = replay.toString();
  //     showToast(text: replayshow  ,state: ToastStates.EROOR);
  //     return false;
  //   }else {
  //     var replay = jsonDecode(response.body);
  //     String replayshow = replay['detail'].toString();
  //     showToast(text:replayshow ,state: ToastStates.EROOR);
  //     return false;
  //   }
  // }





  Future<bool> logout1 () async { // async and await for making any comand after wait till this ends

    SecureStorage storage = SecureStorage();
    String? savedtoken = await storage.read("token");
    print("bye bye");
    print(savedtoken);

    var response = await http.post(urllogout1,
      headers:{
        'Authorization' : 'Token ${savedtoken.toString()}',
      },

    );
    print(response.statusCode);
    print(response.body);

    if(response.statusCode == 204){
      showToast(text:"Logout Successfully" ,state: ToastStates.SUCCESS);
      return true;
    }else {
      showToast(text:"Error" ,state: ToastStates.EROOR);
      return false;
    }
  }


  Future<bool> logout2 () async { // async and await for making any comand after wait till this ends

    SecureStorage storage = SecureStorage();
    String? savedtoken = await storage.read("token");
    print("bye bye from all");
    print(savedtoken);

    var response = await http.post(urllogout2,
      headers:{
        'Authorization' : 'Token ${savedtoken.toString()}',
      },

    );
    print(response.statusCode);
    print(response.body);

    if(response.statusCode == 204){
      showToast(text:"Logout Successfully" ,state: ToastStates.SUCCESS);
      return true;
    }else {
      showToast(text:"Error" ,state: ToastStates.EROOR);
      return false;
    }
  }

}