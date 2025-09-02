// Texts Page
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khateeb/custom.dart';
import 'package:khateeb/editorwebapp/editorpages/editorsendassignment/editorsendassignment_controller.dart';

class TextsPage extends StatelessWidget {
  final controller = Get.put(TextsController());

  @override
  Widget build(BuildContext context) {
    controller.fetchTexts();
    return Scaffold(
      backgroundColor: firstBackColor,
      appBar: AppBar(
        backgroundColor: firstBackColor,
        title: Text("اختيار النص", style: TextStyle(color: sixBackColor)),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return Center(child: CircularProgressIndicator(color: fifthBackColor));
        }
        return GridView.builder(
          padding: EdgeInsets.all(20),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 cards per row
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 3,
          ),
          itemCount: controller.texts.length,
          itemBuilder: (_, i) {
            final t = controller.texts[i];
            return GestureDetector(
              onTap: () => Get.to(() => ChannelsPage(textId: t.id)),
              child: Card(
                color: firstBackColor,
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: fifthBackColor, width: 2),
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      t.text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: sixBackColor,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}


// Channels Page
class ChannelsPage extends StatelessWidget {
  final int textId;
  ChannelsPage({required this.textId});

  final controller = Get.put(ChannelsController());

  @override
  Widget build(BuildContext context) {
    controller.fetchChannels();
    return Scaffold(
      backgroundColor: firstBackColor,
      appBar: AppBar(
        backgroundColor: firstBackColor,
        title: Text("اختر القناة", style: TextStyle(color: sixBackColor)),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return Center(child: CircularProgressIndicator(color: fifthBackColor));
        }
        return ListView.builder(
          padding: EdgeInsets.all(20),
          itemCount: controller.channels.length,
          itemBuilder: (_, i) {
            final c = controller.channels[i];
            return GestureDetector(
              onTap: () => Get.to(() => EmployeesPage(textId: textId, channelId: c.id)),
              child: Card(
                color: firstBackColor,
                elevation: 6,
                margin: EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: fifthBackColor, width: 2),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c.name,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: sixBackColor)),
                      SizedBox(height: 8),
                      Text(
                        c.description,
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}


// Employees Page
class EmployeesPage extends StatelessWidget {
  final int textId;
  final int channelId;

  EmployeesPage({required this.textId, required this.channelId});

  final controller = Get.put(EmployeesController());

  @override
  Widget build(BuildContext context) {
    controller.fetchEmployees(channelId);
    return Scaffold(
      backgroundColor: firstBackColor,
      appBar: AppBar(
        backgroundColor: firstBackColor,
        title: Text("اختر الموظف", style: TextStyle(color: sixBackColor)),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return Center(child: CircularProgressIndicator(color: fifthBackColor));
        }
        return ListView.builder(
          padding: EdgeInsets.all(20),
          itemCount: controller.employees.length,
          itemBuilder: (_, i) {
            final e = controller.employees[i];
            return GestureDetector(
              onTap: () {
                controller.assignText(textId, e.id);
                Get.toNamed(('/editorhome'));
              },
              child: Card(
                color: firstBackColor,
                elevation: 6,
                margin: EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: fifthBackColor, width: 2),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.person, color: fifthBackColor, size: 40),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e.fullName,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: sixBackColor)),
                          Text("الدور: ${e.role}",
                              style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

