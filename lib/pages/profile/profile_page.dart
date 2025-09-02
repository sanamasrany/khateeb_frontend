import 'package:birth_picker/birth_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:khateeb/custom.dart';
import 'package:khateeb/pages/profile/profile_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

class ProfilePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _ProfilePage();
  }

}


class _ProfilePage extends State<ProfilePage>{

  late ProfileController controller;
  late TextEditingController firstnameController;
  late TextEditingController lastnameController;
  late TextEditingController bioController;


  @override
  void initState() {
    super.initState();

    // Find the controller after the widget is initialized
    controller = Get.find<ProfileController>();

    // Initialize your TextEditingController with the observable's value
    firstnameController = TextEditingController(text: controller.first_name.value);
    lastnameController = TextEditingController(text: controller.last_name.value);
    bioController = TextEditingController(text: controller.bio.value);

    ever(controller.first_name, (value) {
      firstnameController.text = value;
    });

    ever(controller.last_name, (value) {
      lastnameController.text = value;
    });

    ever(controller.bio, (value) {
      bioController.text = value;
    });

  }

  @override
  void dispose() {
    // Dispose of the controllers to free up resources
    firstnameController.dispose();
    lastnameController.dispose();
    bioController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      bottomNavigationBar: BottomAppBar(
        color: firstBackColor,
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFab(icon: Icons.feedback_outlined, onPressed: () {Get.toNamed('/feedback');}, label: "feedback" ,background: thirdBackColor),
              _buildFab(icon: Icons.person, onPressed: () {}, label: "Profile" , background: fifthBackColor),
              _buildFab(icon: Icons.home, onPressed: () {onClickhome();}, label: "Home" ,background: thirdBackColor),
               _buildFab(icon: Icons.work_history_outlined, onPressed: () {Get.toNamed('/jobrequest');}, label: "job request",background: thirdBackColor),
              _buildFab(icon: Icons.search, onPressed: () {onClicksearch();}, label: "Search" ,background: thirdBackColor),
              _buildFab(icon: Icons.text_snippet, onPressed: () {onClicktext();}, label: "Add Text" ,background: thirdBackColor),
            ],
          ),
        ),
      ),
      //floatingActionButton: h()
      appBar: AppBar(
        backgroundColor: firstBackColor,

      ),
      body:Container(
        height:MediaQuery.of(context).size.height ,
        width: MediaQuery.of(context).size.width,
        decoration: gradientBackground,
        child:SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 50),


            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:  [
                Obx(()=>
                controller.showeditstuff.isTrue?
                Column(
                  children: [
                    Center(child:
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: controller.profileImage_new.value != null
                              ? FileImage(controller.profileImage_new.value!)
                              : AssetImage('assets/images/kateeb.jpg') as ImageProvider,
                        ),
                        InkWell(
                          onTap: () {
                            Get.bottomSheet(
                              Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                ),
                                child: Wrap(
                                  children: [
                                    ListTile(
                                      leading: Icon(Icons.photo_camera, color: fifthBackColor),
                                      title: Text("التقط صورة"),
                                      onTap: () {
                                        controller.pickImage(ImageSource.camera);
                                        Get.back();
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.photo_library, color: fifthBackColor),
                                      title: Text("اختر صورة"),
                                      onTap: () {
                                        controller.pickImage(ImageSource.gallery);
                                        Get.back();
                                      },),],),),);
                          },
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: fifthBackColor,
                            child: Icon(Icons.camera_alt, color: Colors.white, size: 18),
                          ),),],)
                      ,)
                    ,const SizedBox(height: 20),
                    defaultTextField(
                        controller:firstnameController,
                        type: TextInputType.emailAddress,
                        hint: "First name".tr,
                        validate:(value){
                          if(value.isEmpty)
                          {
                            return "Your email must not be empty";
                          }
                          else{
                            return null;
                          }
                        },
                        prefix:Icons.person_outline),
                    const SizedBox(height: 20,),
                    defaultTextField(
                        controller:lastnameController,
                        type: TextInputType.emailAddress,
                        hint: "Last name".tr,
                        validate:(value){
                          if(value.isEmpty)
                          {
                            return "Your email must not be empty";
                          }
                          else{
                            return null;
                          }
                        },
                        prefix:Icons.person_outline),
                    const SizedBox(height: 20,),
                    defaultTextField(
                        controller:bioController,
                        type: TextInputType.emailAddress,
                        hint: "الوصف".tr,
                        validate:(value){
                          if(value.isEmpty)
                          {
                            return "Your email must not be empty";
                          }
                          else{
                            return null;
                          }
                        },
                        prefix:Icons.create_outlined),
                    const SizedBox(height: 20,),
                    RadioListTile<String>(
                      title:  Text('ذكر'.tr),
                      value: 'MALE',
                      groupValue: controller.gender_new.value,
                      onChanged: (value) => controller.gender_new.value = value,
                    ),
                    RadioListTile<String>(
                      title:  Text('أنثى'.tr),
                      value: 'FEMALE',
                      groupValue: controller.gender_new.value,
                      onChanged: (value) => controller.gender_new.value = value,
                    ),

                    const SizedBox(height: 20,),

                    Text("تاريخ الميلاد".tr
                      ,style: TextStyle(
                        color: Colors.black54,
                      ),),
                    const SizedBox(height: 10,),
                    BirthPicker(
                      onChanged: (dateTime) {
                        if (dateTime != null) {
                          controller.birthdate_new = '${dateTime.year}-${dateTime.month}-${dateTime.day}';
                        } else {
                          print('Invalid Date');
                        }
                      },
                    ),

                    SizedBox(height: 30,),
                    //    ConditionalBuilder(
                    //     condition: state is !PharmacyLoadingState ,
                    //     builder: (context) =>
                    newDefaultButton(

                        background: sixBackColor,
                        text: "Save".tr,
                        //  background: HexColor(green.toString()),
                        function: (){
                          controller.first_name_new = firstnameController.text;
                          controller.last_name_new = lastnameController.text;
                          controller.bio_new = bioController.text;
                          onClickSave();
                        },

                        width: double.infinity,
                        isAppbar: false
                    ),
                    SizedBox(height: 10,),
                    //    ConditionalBuilder(
                    //     condition: state is !PharmacyLoadingState ,
                    //     builder: (context) =>
                    newDefaultButton(
                        background: sixBackColor,
                        text: "العودة".tr,
                        //  background: HexColor(green.toString()),
                        function: (){
                           controller.showeditstuff(false);
                        },

                        width: double.infinity,
                        isAppbar: false
                    ),
                  ],
                )
                    :Column(
                  children: [
                    // Profile Photo + Name
                    Center(
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundImage: controller.profileImageurl.value != 'null' ? NetworkImage(controller.profileImageurl.value) :AssetImage('assets/images/kateeb.jpg') ,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 4,
                                child: GestureDetector(
                                  onTap: () {
                                    controller.showeditstuff(true);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: fifthBackColor,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(6),
                                    child: const Icon(
                                      Icons.edit,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Text(
                            "${controller.first_name.value} ${controller.last_name.value }",
                            style: GoogleFonts.bebasNeue(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: fifthBackColor,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            controller.bio.value,
                            style: TextStyle(
                              color: sixBackColor,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Info Cards
                        _buildInfoCard("", controller.gender.value == "MALE" ? "ذكر" : "أنثى"),
                        _buildInfoCard("تاريخ الميلاد", controller.birthdate.value),


                    const SizedBox(height: 40),

                    // Portfolio (for later)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "معرض أعمالي",
                        style: GoogleFonts.bebasNeue(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: fifthBackColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    controller.isLoading.value ?
                    Center(child: CircularProgressIndicator())
                    :controller.portfolios.isEmpty ?
                    Center(child: Text("اضف الى معرض اعمالك بعد التدريب عرضها هنا",style: TextStyle(color: Colors.white),))
                    :
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: controller.portfolios.map((portfolio) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 3,
                          margin: const EdgeInsets.only(bottom: 15),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text
                                Text(
                                  portfolio.text,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
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

                                // Score (if available)
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
                                        buildWerPieChart(portfolio.wer),
                                      ],
                                    ),
                                    const SizedBox(width: 5),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("التشكيل"),
                                        buildWerPieChart(portfolio.der),
                                      ],
                                    ),
                                    const SizedBox(width: 5),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("الحرف"),
                                        buildWerPieChart(portfolio.cer),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    )
                  ],
                ),
                ),


                const  SizedBox(height:5,),


              ],
            ),
          ),
        ),
      ),

    );
  }

  void onClickSave() async {
    await controller.EditProfileOnClick();
    if (controller.editprofileStatus) {
      controller.showeditstuff(false);
      Get.offNamed('/home');
    }else{
      print('error');
    }
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

  void onClicksearch() async {

    // await controller.profileOnClick();
    // if (controller.profileStatus) {
    Get.toNamed('/search');
    // }else{
    //   print('error');
    // }
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

  Widget _buildInfoCard(String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          value,
          style: GoogleFonts.bebasNeue(fontSize: 24),
        ),
      ),
    );
  }



}