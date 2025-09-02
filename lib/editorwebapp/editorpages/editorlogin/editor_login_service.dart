import 'dart:convert';
import 'package:http/http.dart' as http ;

import '../../../custom.dart';
import '../../../utiles.dart';

class EditorLoginService {

  var token_refresh;
  var token_access ;
  String Userid = '';
  var email1;
  var last_name1;
  var first_name1;
  var bio1;
  var gender1;
  var birthdate1;
  var country1;
  var photopath1;
  var native1;


  var url = Uri.parse('${Utiles.baseurl}/auth/jwt/create/');

  Future<bool> login (String email , String password) async { // async and await for making any comand after wait till this ends
    print(email);
    print(password);
    var response = await http.post(url,

        body: {
          'email': email,
          'password': password,
        }
    );
    print(response.statusCode);
    print(response.body);

    if(response.statusCode == 200){
      var replay = jsonDecode(response.body);
      token_access = replay['access'];
      token_refresh = replay['refresh'] ;
      var user = replay['user'];
      Userid = user['id'].toString();
      first_name1 = user['first_name'];
      last_name1 = user['last_name'];
      email1 = user['email'];
      bio1 = user['bio'];
      gender1 = user['gender'];
      birthdate1 = user['birthdate'];
      country1 = user['country'];
      photopath1 =user['photo'];


      //save token to device
      SecureStorage storage = SecureStorage();

      await storage.save('token', token_access);
      await storage.save('refreshtoken', token_refresh);

      await storage.save('userid', Userid);
      await storage.save('email', email1);
      await storage.save('first_name', first_name1);
      await storage.save('last_name', last_name1);
      await storage.save('bio', bio1);
      await storage.save('gender', gender1);
      await storage.save('birthdate', birthdate1);

      await storage.save('country', country1);
      await storage.save('photo', photopath1);


      String? savedtoken = await storage.read("token");
      // String? savedid= await storage.read("userid");
      print("++++++++++++++++++++++++++++++++++++++++++++++");
      print(savedtoken);
      // print(savedid);
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

}