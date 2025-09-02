import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khateeb/custom.dart';
import 'package:khateeb/editorwebapp/editorpages/editorfeedback/editorfeedback_controller.dart';

class FeedbackPage extends StatelessWidget {
  final controller = Get.put(FeedbackController());
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: firstBackColor,
      appBar: AppBar(
        backgroundColor: firstBackColor,
        title: Text("ارسل رايك", style: TextStyle(color: sixBackColor)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            // Icon
            Icon(Icons.feedback, color: fifthBackColor, size: 80),
            SizedBox(height: 20),

            // TextField
            TextField(
              controller: textController,
              maxLines: 5,
              style: TextStyle(color: sixBackColor),
              decoration: InputDecoration(
                hintText: "اكتب ملاحظتك هنا...",
                hintStyle: TextStyle(color: Colors.grey[500]),
                filled: true,
                fillColor: firstBackColor,
                contentPadding: EdgeInsets.all(16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: fifthBackColor, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: fifthBackColor, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: fifthBackColor, width: 2),
                ),
              ),
              onChanged: (val) => controller.feedback.value = val,
            ),

            SizedBox(height: 30),

            // Send Button
            Obx(() => ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: fifthBackColor,
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              icon: controller.loading.value
                  ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: sixBackColor,
                  ))
                  : Icon(Icons.send, color: sixBackColor),
              label: Text(
                controller.loading.value ? "جارٍ الإرسال..." : "إرسال الملاحظة",
                style: TextStyle(
                    color: sixBackColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: controller.loading.value
                  ? null
                  : () {
                controller.sendFeedback();
                textController.clear();
              },
            )),
          ],
        ),
      ),
    );
  }
}
