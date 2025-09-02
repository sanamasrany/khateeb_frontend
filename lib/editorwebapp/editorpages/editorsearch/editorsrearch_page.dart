import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khateeb/custom.dart';
import 'package:khateeb/editorwebapp/editorpages/editorsearch/editorsearch_controller.dart';
import 'package:khateeb/pages/portfolio/usersportfolio_page.dart';
import 'dart:async';
import 'package:khateeb/pages/search/search_controller.dart';


class EditorSearchPage extends StatelessWidget {

  EditorSearchPageController controller = Get.find();
  final searchTextController = TextEditingController();
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: gradientBackground,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 80),
          child: Column(
            children: [
              searchTextField(
                controller: searchTextController,
                onChanged: (value) {
                  // debounce handled in your controller if you want
                  controller.search(value);
                },
                hint: "البحث عن معارض الأعمال".tr,
              ),
              const SizedBox(height: 20),

              // 👤 List of users
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.filteredUsers.isEmpty) {
                    return const Center(child: Text("لا يوجد نتائج"));
                  }
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: controller.filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = controller.filteredUsers[index];
                      final photo = user['photo'];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundImage: photo != null && photo.isNotEmpty
                                ? NetworkImage(photo)
                                : const AssetImage("assets/images/Picture1.png")
                            as ImageProvider,
                          ),
                          title: Text("${user['first_name']} ${user['last_name']}"),
                          subtitle: Text(user['email'] ?? ""),
                          onTap: () {
                            // Go to portfolio page with email
                            Get.to(() => UserPortfolioPage(),
                              arguments: {"email": user['email'] , "name": "${user['first_name']} ${user['last_name']}", "photo" : photo},
                            );
                          },
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onClicktext() async {

    // await controller.profileOnClick();
    // if (controller.profileStatus) {
    Get.toNamed('/text');
    // }else{
    //   print('error');
    // }
  }

  void onClickhome() async {

    // await controller.profileOnClick();
    // if (controller.profileStatus) {
    Get.toNamed('/home');
    // }else{
    //   print('error');
    // }
  }

  void onClickprofile() async {

    // await controller.profileOnClick();
    // if (controller.profileStatus) {
    Get.toNamed('/profile');
    // }else{
    //   print('error');
    // }
  }

  static Widget _buildFab({
    required IconData icon,
    required VoidCallback onPressed,
    String? label,
  }) {
    return FloatingActionButton(
      heroTag: label,
      // avoid heroTag conflict
      onPressed: onPressed,
      mini: true,
      backgroundColor: const Color(0xFFD4AF37),
      child: Icon(icon, color: Colors.black),
      elevation: 4,
    );
  }


}