import 'dart:convert';
import 'package:http/http.dart' as http ;
import 'package:khateeb/custom.dart';
import 'package:khateeb/utiles.dart';

class ProfileService {


  var last_name1;
  var first_name1;
  var bio1;
  var gender1;
  var birthdate1;


  Future<bool> Edituserinfo (String first_name , String last_name, String bio ,String? gender , String birthdate , ) async { // async and await for making any comand after wait till this ends
    print(first_name);
    print(last_name);


    SecureStorage storage = SecureStorage();
    String? savedtoken = await storage.read("token");
    String? savedid = await storage.read("userid");

    var url = Uri.parse('${Utiles.baseurl}/auth/users/me/');

    var response = await http.patch(url,
        headers:{
          'Authorization' : 'JWT ${savedtoken.toString()}',
        },
        body: {
          'first_name': first_name,
          'last_name': last_name,
          'bio': bio,
          'gender': gender,
          'birthdate': birthdate,

        }
    );
    print(response.statusCode);
    print(response.body);

    if(response.statusCode == 200){
      var replay = jsonDecode(response.body);
      first_name1 = replay['first_name'];
      last_name1 = replay['last_name'];
      bio1 = replay['bio'];
      gender1 = replay['gender'];
      birthdate1 = replay['birthdate'];


      //save token to device
      SecureStorage storage = SecureStorage();


      await storage.save('first_name', first_name1);
      await storage.save('last_name', last_name1);
      await storage.save('bio', bio1);
      await storage.save('gender', gender1);
      await storage.save('birthdate', birthdate1);

      showToast(text:"Profile Edited Successfully" ,state: ToastStates.SUCCESS);
      return true;
    }else {
      var replay = jsonDecode(response.body);
      String replayshow = replay['detail'].toString();
      showToast(text: replayshow ,state: ToastStates.EROOR);
      return false;
    }

  }

}