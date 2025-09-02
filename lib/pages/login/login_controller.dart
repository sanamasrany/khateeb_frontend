import 'package:get/get.dart';
import 'package:khateeb/pages/login/login_service.dart';

class loginController extends GetxController{


  var email='';
  var password='' ;
  var loginStatus = false;

  var loading = false.obs;

  LoginService service = LoginService();


  Future<void> LoginOnClick() async{
    loading(true);
    loginStatus = await service.login( email , password); // returns t or f
    loading(false);
    // if the back sends me a msg as a list so i can make it a string
    // if (message is List ){
    //   String fix ='';
    //   for(String m in message) {
    //     fix +=m+ '\n';
    //   }
    //   message = fix;
    //
    // }
    // if(password != passwordConfirm){
    //   message = 'make sure of your password';
    //   signupStatus = false;
    // }
  }

}