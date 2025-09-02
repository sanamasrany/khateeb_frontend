import 'package:get/get.dart';
import 'package:khateeb/editorwebapp/editorpages/editorlogin/editor_login_service.dart';


class EditorloginController extends GetxController{


  var email='';
  var password='' ;
  var loginStatus = false;

  var loading = false.obs;

  EditorLoginService service = EditorLoginService();


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