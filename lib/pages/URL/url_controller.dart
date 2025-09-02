import 'package:get/get.dart';
import 'package:khateeb/utiles.dart';

class urlController extends GetxController{

  var url ;
  var loading = false.obs;

  SecureStorage storage = SecureStorage();

  Future<void> urlOnClick() async{
    loading(true);
    await storage.save('baseurl', url);
    String? savedurl = await storage.read("baseurl");
    print("saved URL:");
    print(savedurl);
    loading(false);


  }

}