import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khateeb/custom.dart';

class EditorHomeController extends GetxController {
  void goToPage(String route) {
     Get.toNamed(route);
  }
}

class EditorHomePage extends StatelessWidget {

  final List<Map<String, String>> buttons = [
    {"label": "اضافة نص", "route": "/editortext"},
    {"label": "بحث عن معارض اعمال", "route": "/editorsearch"},
    {"label": "ارسال مهمات", "route": "/editortexts"},
    {"label": "دعوات العمل", "route": "/jobrequest"},
    {"label": "ارسل رايك", "route": "/feedback"},
  ];

  final EditorHomeController controller = Get.put(EditorHomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: firstBackColor,
      appBar: AppBar(
        title: Text("الصفحة الرئيسية", style: TextStyle(fontFamily: "Cairo")),
        centerTitle: true,
      ),
      body: Center(
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 3,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          padding: EdgeInsets.all(20),
          children: buttons.map((btn) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                backgroundColor: fifthBackColor,
              ),
              onPressed: () => controller.goToPage(btn["route"]!),
              child: Text(
                btn["label"]!,
                style: TextStyle(fontSize: 18, fontFamily: "Cairo"),
                textAlign: TextAlign.center,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}