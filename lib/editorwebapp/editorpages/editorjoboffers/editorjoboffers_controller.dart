import 'dart:convert';

import 'package:get/get.dart';
import 'package:khateeb/custom.dart';
import 'package:khateeb/models/jobrequests.dart';
import 'package:http/http.dart' as http;
import 'package:khateeb/utiles.dart';

class JobRequestsController extends GetxController {
  var jobs = <JobRequest>[].obs;
  var loading = false.obs;

  Future<void> fetchJobRequests() async {
    loading.value = true;
    SecureStorage storage = SecureStorage();
    String? savedtoken = await storage.read("token");
    final res = await http.get(Uri.parse("${Utiles.baseurl}/employments/")
    ,headers:{
        'Authorization' : 'JWT ${savedtoken.toString()}',
      },
    );
    if (res.statusCode == 200) {
      final data = json.decode(res.body) as List;
      jobs.value = data.map((e) => JobRequest.fromJson(e)).toList();
    }
    loading.value = false;
  }

  Future<void> updateJobStatus(int jobId, String status) async {
    final url = Uri.parse("${Utiles.baseurl}/employments/$jobId/");
    final body = json.encode({"status": status});

    SecureStorage storage = SecureStorage();
    String? savedtoken = await storage.read("token");

    final res = await http.patch(
      url,
        headers:{
        'Authorization' : 'JWT ${savedtoken.toString()}',
        "Content-Type": "application/json"},
      body: body,
    );

    if (res.statusCode == 200) {
      showToast(text:"تم تحديث حالة الدعوة بنجاح" ,state: ToastStates.SUCCESS ,fontsize: 20);
      await fetchJobRequests(); // refresh list
    } else {
      var replay = jsonDecode(res.body);
      print(replay.toString());
      showToast(text:replay.toString() ,state: ToastStates.EROOR);
    }
  }
}
