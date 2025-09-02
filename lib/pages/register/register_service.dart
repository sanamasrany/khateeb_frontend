import 'dart:convert';
import 'package:http/http.dart' as http ;
import 'package:khateeb/custom.dart';
import 'package:khateeb/utiles.dart';
class RegisterService {


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




  var url = Uri.parse('${Utiles.baseurl}/auth/users/');
  var url_login = Uri.parse('${Utiles.baseurl}/auth/jwt/create');

  Future<bool> register  ( String password,
      String email , String first_name ,String last_name
      , String bio , String? gender , String birthdate , String country , String? is_native_arabic_speaker , String photopath
      ) async { // async and await for making any comand after wait till this ends


      var request = http.MultipartRequest('POST', url);
      request.fields.addAll({
        'email': email,
        'password': password,
        'first_name': first_name,
        'last_name': last_name,
        'bio': bio,
        'gender': ?gender,
        'birthdate': birthdate,
        'country': country,
        'is_native_arabic_speaker': ?is_native_arabic_speaker
      });
      request.files.add(await http.MultipartFile.fromPath('photo',photopath ));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 201) {
        var data = await response.stream.bytesToString();
        var replay = jsonDecode(data);
        token_access = replay['access'];
        token_refresh = replay['refresh'] ;
        var user = replay['user'];
        Userid = user['id'].toString();
        email1 = user['email'];
        first_name1 = user['first_name'];
        last_name1 = user['last_name'];
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



        // String? savedtoken = await storage.read("token");
        String? savedid= await storage.read("userid");
        print("++++++++++++++++++++++++++++++++++++++++++++++");
        // print(savedtoken);
        print(savedid);
        print("++++++++++++++++++++++++++++++++++++++++++++++");

        return true;
      }
      else {
        var data = await response.stream.bytesToString();
        var replay = jsonDecode(data);
        print(data);
        showToast(text: replay.toString() ,state: ToastStates.EROOR);
        return false;
      }
  }





}