import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khateeb/custom.dart';
import 'package:khateeb/pages/home/home_controller.dart';

class HomePage extends StatelessWidget {

  homeController controller = Get.find();
  final double horizontalPadding = 40;
  final double verticalPadding = 25;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // floatingActionButton: h(),
        bottomNavigationBar: BottomAppBar(
          color: firstBackColor,
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFab(icon: Icons.person, onPressed: () {onClickprofile();}, label: "Profile" ,background: thirdBackColor),
                _buildFab(icon: Icons.home, onPressed: () {}, label: "Home" ,background: fifthBackColor),
                _buildFab(icon: Icons.work_history_outlined, onPressed: () {Get.toNamed('/jobrequest');}, label: "job request",background: thirdBackColor),
                _buildFab(icon: Icons.search, onPressed: () {onClicksearch();}, label: "Search",background: thirdBackColor),
                _buildFab(icon: Icons.text_snippet, onPressed: () {onClicktext();}, label: "Add Text",background: thirdBackColor),
              ],
            ),
          ),
        ),
          body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: firstBackColor),
      child: SafeArea(

    child:
    Obx(()=>
    Column(
      children: [
      // Fixed AppBar + Buttons at the top
      Container(
      color: firstBackColor,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _TopButton(onPressed: () {controller.mytextshow(true);controller.textshow(false); controller.assignmentshow(false);},
              label: "نصوصي" , color: controller.mytextshow.value? fifthBackColor : sixBackColor),
          _TopButton(onPressed: () {controller.mytextshow(false);controller.textshow(false); controller.assignmentshow(true);},
              label: "مهمات" , color: controller.assignmentshow.value? fifthBackColor : sixBackColor),
          _TopButton(onPressed: () {controller.mytextshow(false);controller.textshow(true); controller.assignmentshow(false);},
              label: "تدريب" , color: controller.textshow.value? fifthBackColor : sixBackColor),
        ],
      ),
    ),

        Expanded(child:
        SingleChildScrollView (
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Column(
                children: [
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      controller.isLoading.value ?
                      Center(child: CircularProgressIndicator())
                      :controller.mytextshow.value?
                        controller.myLevels.length < 1 ?
                          SizedBox(width: 40
                          ,child: Text("أضف نصوصاً لعرضها", style: TextStyle(color: Colors.white, fontSize: 15),),
                        )
                      :Column(
                        children: [
                          for (int i = 0; i < controller.myLevels.length; i++)
                            GestureDetector(
                              onTap: () {
                                var level = controller.myLevels[i];
                                print(level.id);
                                print(level.text);
                                Get.toNamed("/level", arguments: {"id": level.id, "text": level.text},
                                );
                              },
                              child: buildStep(
                                icon: buildCircle(
                                  child: Text(
                                    // Option A: Show number
                                    "${i + 1}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  color: fifthBackColor,
                                ),
                                isLast: i == controller.myLevels.length - 1,
                              ),
                            ),
                        ],
                      )
                      :SizedBox(width: 40),
                      const SizedBox(width: 40),
                      controller.isLoading.value ?
                      Center(child: CircularProgressIndicator())
                      :controller.assignmentshow.value?
                      controller.myassignment.length < 1 ?
                      SizedBox(width: 50
                        ,child: Text("لم يسند لك معد النصوص مهمات", style: TextStyle(color: Colors.white, fontSize: 15),),
                      )
                          :Column(
                        children: [
                          for (int i = 0; i < controller.myassignment.length; i++)
                            GestureDetector(
                              onTap: () {
                                var level = controller.myassignment[i];
                                print(level.id);
                                print(level.text);
                                Get.toNamed("/level", arguments: {"id": level.id, "text": level.text},
                                );
                              },
                              child: buildStep(
                                icon: buildCircle(
                                  child: Text(
                                    // Option A: Show number
                                    "${i + 1}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  color: fifthBackColor,
                                ),
                                isLast: i == controller.myassignment.length - 1,
                              ),
                            ),
                        ],
                      )
                          :SizedBox(width: 40),
                      const SizedBox(width: 40),
                      controller.isLoading.value ?
                      Center(child: CircularProgressIndicator())
                      :controller.textshow.value?
                      Column(
                        children: [
                          for (int i = 0; i < controller.levels.length; i++)
                            GestureDetector(
                              onTap: () {
                                // Navigate with GetX
                                final level = controller.levels[i];
                                print(level.id);
                                print(level.text);
                                Get.toNamed("/level", arguments: {"id": level.id, "text": level.text});
                              },
                              child: buildStep(
                                icon: buildCircle(
                                  child: Text(
                                    // Option A: Show number
                                    "${i + 1}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  color: fifthBackColor,
                                ),
                                isLast: i == controller.levels.length - 1,
                              ),
                            ),
                        ],
                      )
                          :SizedBox(width: 40),

                      // Placeholder for logo
                      // Column(
                      //   children: [
                      //     const SizedBox(height: 120),
                      //     Image.asset(
                      //       'assets/images/Picture1.png', // Replace with your actual asset path
                      //       height: 150,
                      //       fit: BoxFit.contain,
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  // Container(
                  //   padding: const EdgeInsets.all(16),
                  //   decoration: BoxDecoration(
                  //     border: Border.all(color: Colors.grey),
                  //     borderRadius: BorderRadius.circular(10),
                  //     color: Colors.transparent,
                  //   ),
                  //   child: Column(
                  //     children: const [
                  //       Text(
                  //         'Unit 4',
                  //         style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  //       ),
                  //       SizedBox(height: 5),
                  //       Text(
                  //         'التَخَطي في المسْجُد',
                  //         style: TextStyle(color: Colors.white70, fontSize: 18),
                  //       ),
                  //       SizedBox(height: 10),
                  //       Icon(Icons.download, color: Color(0xFFD4AF37)),
                  //     ],
                  //   ),
                  // ),
                ],
              )



            ],
          ),
        ),)

    ]
    )
    )

    )
          )
    );
  }
  void onClickprofile() async {

    // await controller.profileOnClick();
    // if (controller.profileStatus) {
      Get.toNamed('/profile');
    // }else{
    //   print('error');
    // }
  }

  void onClicktext() async {

    // await controller.profileOnClick();
    // if (controller.profileStatus) {
    Get.toNamed('/text');
    // }else{
    //   print('error');
    // }
  }
  void onClicksearch() async {

    // await controller.profileOnClick();
    // if (controller.profileStatus) {
    Get.toNamed('/search');
    // }else{
    //   print('error');
    // }
  }



  Widget buildStep({required Widget icon, bool isLast = false}) {
    return Column(
      children: [
        icon,
        if (!isLast)
          Container(
            height: 30,
            width: 2,
            color: Colors.grey[700],
          ),
      ],
    );
  }

  Widget buildCircle({required Widget child, Color? color}) {
    return CircleAvatar(
      backgroundColor: color ?? Colors.grey[800],
      radius: 25,
      child: child,
    );
  }

  static Widget _buildFab({
    required IconData icon,
    required VoidCallback onPressed,
    String? label,
    required Color background,
  }) {
    return FloatingActionButton(
      heroTag: label,
      // avoid heroTag conflict
      onPressed: onPressed,
      mini: true,
      backgroundColor: background,
      child: Icon(icon, color: Colors.black),
      elevation: 4,
    );
  }

  Widget _TopButton({required VoidCallback onPressed, required String label , required Color color}) {
    return GestureDetector(
      onTap: onPressed,
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }


}