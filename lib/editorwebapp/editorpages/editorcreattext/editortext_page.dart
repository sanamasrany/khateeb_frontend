import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:khateeb/custom.dart';
import 'package:just_audio/just_audio.dart';
import 'package:khateeb/editorwebapp/editorpages/editorcreattext/editedtext_controller.dart';
import 'package:khateeb/pages/text/text_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class EditorTextPage  extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _EditorTextPage();
  }

}


class _EditorTextPage extends State<EditorTextPage> {

  EditorTextController controller = Get.find();
  var textController=TextEditingController();
  var edittextController=TextEditingController();
  var extractedtextController=TextEditingController();
  var usertextController=TextEditingController();
  var notstextController=TextEditingController();


  final String sampleText = "هذا نص تجريبي لاختبار التلوين حسب الفهرس";
  final String jsonResponse = '{"results":[[1,2],[4,10]]}';


  final double horizontalPadding = 40;
  final double verticalPadding = 25;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: firstBackColor,
      body:
      SafeArea(
          child: SingleChildScrollView(
            padding:const EdgeInsets.all(24.0),
            child:
            Obx(()=>
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    // Logo at the top
                    Image.asset('assets/images/kateeb.jpg', height: 100),

                    SizedBox(height: 10),

                    // Arabic phrase text
                    Text(
                      'ادخل النص الخاص بك',
                      style: TextStyle(
                        color: sixBackColor, // Gold color
                        fontSize: 20,
                        fontFamily: 'Amiri', // Or any Arabic-style font
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                            child:
                            controller.aftershakilni == true ?
                            controller.editpart == false ?
                            Container(
                              height: 60, // Or any suitable height
                              child: SingleChildScrollView(
                                child: Text(
                                  controller.diacritize_text.value,
                                  style: TextStyle(
                                    color: fourthBackColor,
                                    fontSize: 24,
                                    fontFamily: 'Amiri',
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                                :defaultTextFieldfortext(
                                height: 130,
                                controller:edittextController,
                                type: TextInputType.text,
                                hint: "عدل النص",
                                color: fifthBackColor,
                                validate:(value){
                                  if(value.isEmpty)
                                  {
                                    return "Your text must not be empty";
                                  }
                                  else{
                                    return null;
                                  }
                                },
                                prefix:Icons.book_outlined)

                                :defaultTextFieldfortext(
                                height: 130,
                                controller:textController,
                                type: TextInputType.text,
                                hint: "اكتب نص تريد اضافته",
                                color: fifthBackColor,
                                validate:(value){
                                  if(value.isEmpty)
                                  {
                                    return "Your text must not be empty";
                                  }
                                  else{
                                    return null;
                                  }
                                },
                                prefix:Icons.book_outlined) ),
                        SizedBox(width: 5,),
                        controller.loading == true ?
                        Center(
                          child: CircularProgressIndicator(color: fourthBackColor,),
                        )

                            : controller.aftershakilni == true ?
                        controller.editpart == false ?
                        newDefaultButton(
                            background: sixBackColor,
                            text: "تعديل".tr,
                            //  background: HexColor(green.toString()),
                            function: ()async{
                              controller.editpart(true);
                              edittextController.text = controller.diacritize_text.value;

                            },

                            width: 80,
                            isAppbar: false
                        )
                            :controller.loadingsave == true ?
                        Center(
                          child: CircularProgressIndicator(color: fourthBackColor,),
                        ):
                        newDefaultButton(
                            background: sixBackColor,
                            text: "حفظ".tr,
                            //  background: HexColor(green.toString()),
                            function: ()async{
                              onclicksaveedit();
                            },

                            width: 80,
                            isAppbar: false
                        )
                            :newDefaultButton(
                            background: sixBackColor,
                            text: "شكلني".tr,
                            //  background: HexColor(green.toString()),
                            function: ()async{
                              controller.text = textController.text;
                              onClickdiacritizeme();
                            },

                            width: 80,
                            isAppbar: false
                        ),

                      ],
                    ),

                    SizedBox(height: 20),




                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        controller.loadingadd == true ?
                        Center(
                          child: CircularProgressIndicator(color: fourthBackColor,),
                        )
                            :
                        newDefaultButton(
                            background: sixBackColor,
                            text: "اضافة النص".tr,
                            //  background: HexColor(green.toString()),
                            function: ()async{
                              Get.dialog(
                                Obx(() => AlertDialog(
                                  title: Text("هذا النص غير موجود لدينا, هل ترغب باضافته ؟"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CheckboxListTile(
                                        title: Text("الجمهور: العام"),
                                        value: controller.isPublic.value,
                                        onChanged: (val) {
                                          togglePublic(val ?? true);
                                        },
                                        controlAffinity: ListTileControlAffinity.leading,
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: ()  async {
                                        controller.text = textController.text;;
                                        onClickaddtotext();
                                        Get.back(); // Close dialog
                                        Get.toNamed(('/editorhome'));
                                      },
                                      child: Text("اضافة"),
                                    ),
                                  ],
                                )),
                              );
                            },

                            width: 150,
                            isAppbar: false
                        ),


                      ],
                    ),
                    SizedBox(height: 10,),
                    newDefaultButton(
                        background: sixBackColor,
                        text: "اعادة".tr,
                        //  background: HexColor(green.toString()),
                        function: ()async{
                          controller.aftershakilni(false);
                          controller.editpart(false);
                        },

                        width: 80,
                        isAppbar: false
                    ),

                  ],
                )
            ),
          )
      ),
    );
  }


  void onClickaddtotext() async {
    await controller.addtoportifolioOnClick();

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


  void onClickdiacritizeme() async {
    controller.correctStatustoshow(false);
    await controller.diacritizeOnClick();
    if (controller.diacritizeStatus) {
      controller.loading(false);
    }else{
      controller.loading(false);
      print('error');
    }
  }

  void onClickcorrect() async {

    await controller.correctOnClick();
    if (controller.correctStatus) {
      controller.correctStatustoshow(true);
      controller.loading1(false);
    }else{
      controller.loading1(false);
      print('error');
    }
  }

  void onclicksaveedit() async {
    await controller.diacritizationerrorOnClick();
  }

  void togglePublic(bool value) {
    if (!value) {
      // Show confirmation if unchecking
      Get.dialog(
        AlertDialog(
          title: Text("هل انت متاكد ؟"),
          actions: [
            TextButton(
              onPressed: () {
                controller.isPublic.value = false; // Keep unchecked
                Get.back(); // Close dialog
              },
              child: Text("نعم"),
            ),
            TextButton(
              onPressed: () {
                controller.isPublic.value = true; // Re-check it
                Get.back(); // Close dialog
              },
              child: Text("لا"),
            ),
          ],
        ),
      );
    } else {
      controller.isPublic.value = true;
    }
  }






}