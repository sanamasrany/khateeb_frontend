import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khateeb/custom.dart';
import 'package:khateeb/editorwebapp/editorpages/editorjoboffers/editorjoboffers_controller.dart';

class JobRequestsPage extends StatelessWidget {
  final controller = Get.put(JobRequestsController());

  @override
  Widget build(BuildContext context) {
    controller.fetchJobRequests();
    return Scaffold(
      backgroundColor: firstBackColor,
      appBar: AppBar(
        backgroundColor: firstBackColor,
        title: Text("دعوات العمل", style: TextStyle(color: sixBackColor)),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return Center(child: CircularProgressIndicator(color: fifthBackColor));
        }
        if (controller.jobs.isEmpty) {
          return Center(
              child: Text("لا توجد دعوات عمل",
                  style: TextStyle(fontSize: 18, color: sixBackColor)));
        }
        return ListView.builder(
          padding: EdgeInsets.all(20),
          itemCount: controller.jobs.length,
          itemBuilder: (_, i) {
            final job = controller.jobs[i];
            return Card(
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
                    Text(job.channelName,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: sixBackColor)),
                    SizedBox(height: 8),
                    Text(job.channelDescription,
                        style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                    SizedBox(height: 8),
                    Text("الدور المطلوب: ${job.role}",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: fifthBackColor)),
                    SizedBox(height: 8),


                    // Action Buttons
                    SizedBox(height: 12),
                    job.status == 'PENDING'?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.check_circle, color: Colors.green, size: 30),
                          tooltip: "قبول",
                          onPressed: () =>
                              controller.updateJobStatus(job.id, "ACTIVE"),
                        ),
                        IconButton(
                          icon: Icon(Icons.cancel, color: Colors.red, size: 30),
                          tooltip: "رفض",
                          onPressed: () =>
                              controller.updateJobStatus(job.id, "BANNED"),
                        ),
                      ],
                    )
                        : job.status== 'ACTIVE'?
                    Text("انت موظف هنا",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: fifthBackColor))
                        :Text("تم رفض الطلب",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: fifthBackColor))

                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
