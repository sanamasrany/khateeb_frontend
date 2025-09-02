import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khateeb/pages/portfolio/userportfolio_controller.dart';

import '../../custom.dart';


class UserPortfolioPage extends StatelessWidget {
  final controller = Get.put(UserPortfolioController());

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map;
    final email = args["email"];
    final name = args["name"];
    final photo = args["photo"];

    // Fetch data when page loads
    controller.fetchPortfolios(email);

    return Scaffold(
      appBar: AppBar(
        title: Text("معرض أعمال - $name"),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: photo != null && photo.isNotEmpty
                      ? NetworkImage(photo)
                      : const AssetImage("assets/images/kateeb.jpg")as ImageProvider,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        email,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),
        Expanded(
        child:
      Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.portfolios.isEmpty) {
          return const Center(child: Text("لا توجد أعمال لهذا المستخدم"));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.portfolios.length,
          itemBuilder: (context, index) {
            final portfolio = controller.portfolios[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      portfolio.text,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    // Audio row
                    Row(
                      children: [
                        const Icon(Icons.audiotrack, color: fourthBackColor),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "النتيجة على مستوى كل من :",
                            style: TextStyle(color: Colors.grey[600]),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Obx(() {
                          final isPlaying = controller.currentPlayingId.value == portfolio.id;
                          return IconButton(
                            onPressed: () async {
                              if (isPlaying) {
                                await controller.stopAudio();
                              } else {
                                await controller.playAudio(portfolio.id, portfolio.audioFile);
                              }
                            },
                            icon: Icon(
                              isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                              color: fourthBackColor,
                              size: 32,
                            ),
                          );
                        })
                      ],
                    ),
                    const SizedBox(height: 10),
                    portfolio.error != null
                        ? Text("Error: ${portfolio.error}",
                        style: const TextStyle(color: Colors.red))
                        : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("الكلمة"),
                        Text("WER: ${portfolio.wer ?? "-"}"),
                        buildWerPieChart(portfolio.wer),
                      ],
                    ),
                    const SizedBox(width: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("التشكيل"),
                        Text("DER: ${portfolio.der ?? "-"}"),
                        buildWerPieChart(portfolio.der),
                      ],
                    ),
                    const SizedBox(width: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("الحرف"),
                        Text("CER: ${portfolio.cer ?? "-"}"),
                        buildWerPieChart(portfolio.cer),
                      ],
                    ),
                  ],
            )
                  ]
            )
            )
            );
          },
        );
      })
        ),
        ],
      )

    );
  }


}
