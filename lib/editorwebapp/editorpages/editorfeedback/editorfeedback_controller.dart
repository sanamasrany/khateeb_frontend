import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:khateeb/custom.dart';
import 'package:khateeb/utiles.dart';

class FeedbackController extends GetxController {
  var feedback = "".obs;
  var loading = false.obs;

  Future<void> sendFeedback() async {
    if (feedback.value.trim().isEmpty) {
      Get.snackbar("تنبيه", "الرجاء كتابة ملاحظتك");
      return;
    }
    SecureStorage storage = SecureStorage();
    String? savedtoken = await storage.read("token");
    loading.value = true;
    final res = await http.post(
      Uri.parse("${Utiles.baseurl}/feedbacks/"),
      headers: {
          'Authorization' : 'JWT ${savedtoken.toString()}',
        "Content-Type": "application/json"},
      body: json.encode({"content": feedback.value}),
    );

    loading.value = false;

    if (res.statusCode == 201) {
      showToast(text:"شكراً لك ❤️, تم إرسال ملاحظتك بنجاح" ,state: ToastStates.SUCCESS ,fontsize: 20);
      feedback.value = ""; // clear input
    } else {
      var replay = jsonDecode(res.body);
      print(replay.toString());
      showToast(text:replay.toString() ,state: ToastStates.EROOR);
    }
  }
}
