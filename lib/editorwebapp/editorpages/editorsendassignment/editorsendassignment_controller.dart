import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:khateeb/custom.dart';
import 'package:khateeb/models/editor_models.dart';
import 'package:khateeb/utiles.dart';

class TextsController extends GetxController {
  var texts = <TextModel>[].obs;
  var loading = false.obs;

  Future<void> fetchTexts() async {
    SecureStorage storage = SecureStorage();
    String? savedtoken = await storage.read("token");


    loading.value = true;
    final res = await http.get(Uri.parse("${Utiles.baseurl}/texts/"),
      headers:{
        'Authorization' : 'JWT ${savedtoken.toString()}',
      },
    );
    if (res.statusCode == 200) {
      final data = json.decode(res.body) as List;
      texts.value = data.map((e) => TextModel.fromJson(e)).toList();
    }
    loading.value = false;
  }
}

class ChannelsController extends GetxController {
  var channels = <ChannelModel>[].obs;
  var loading = false.obs;



  Future<void> fetchChannels() async {
    loading.value = true;
    SecureStorage storage = SecureStorage();
    String? savedtoken = await storage.read("token");
    final res = await http.get(Uri.parse("${Utiles.baseurl}/employed-channels/"),
      headers:{
        'Authorization' : 'JWT ${savedtoken.toString()}',
      },
    );
    if (res.statusCode == 200) {
      final data = json.decode(res.body) as List;
      channels.value = data.map((e) => ChannelModel.fromJson(e)).toList();
    }
    loading.value = false;
  }
}

class EmployeesController extends GetxController {
  var employees = <EmployeeModel>[].obs;
  var loading = false.obs;

  Future<void> fetchEmployees(int channelId) async {
    loading.value = true;
    SecureStorage storage = SecureStorage();
    String? savedtoken = await storage.read("token");
    final res = await http.get(Uri.parse("${Utiles.baseurl}/employed-channels/$channelId/employees/"),
      headers:{
        'Authorization' : 'JWT ${savedtoken.toString()}',
      },
    );
    if (res.statusCode == 200) {
      final data = json.decode(res.body) as List;
      employees.value = data.map((e) => EmployeeModel.fromJson(e)).toList();
    }
    loading.value = false;
  }

  Future<void> assignText(int textId, int employeeId) async {
    print("${textId}");
    print("${employeeId}");
    SecureStorage storage = SecureStorage();
    String? savedtoken = await storage.read("token");

    final body = json.encode({
      "text_id": "${textId}",
      "sent_to_id": "${employeeId}"
    });

    final res = await http.post(
      Uri.parse("${Utiles.baseurl}/assignments/"),
      headers:{
        'Authorization' : 'JWT ${savedtoken.toString()}',
        'Content-Type': 'application/json'
      },
      body: json.encode({
        "text_id": textId,
        "sent_to_id": employeeId
      })
    );

    if (res.statusCode == 201) {
      var replay = jsonDecode(res.body);
      print(replay.toString());
      showToast(text:"تم إرسال المهمة بنجاح" ,state: ToastStates.SUCCESS ,fontsize: 20);

    } else {
      var replay = jsonDecode(res.body);
      print(replay.toString());
      showToast(text:replay.toString() ,state: ToastStates.EROOR);
    }
  }
}
