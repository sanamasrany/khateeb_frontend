import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class Utiles{
  static const String baseurl = 'http://129.151.138.122';
 //  String baseurl = 'http://3.76.106.49';
// bisher server http://129.151.138.122
}


class SecureStorage {

  final storage = new FlutterSecureStorage();
  Future<void> save (String key , String value)async { //
    await storage.write(key: key, value: value);

  }
  Future<String?> read (String key )async { // read the token and give me value
    return  await storage.read(key: key);

  }
}



