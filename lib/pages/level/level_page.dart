import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:khateeb/models/errorshow.dart';
import 'package:khateeb/pages/level/level_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../../custom.dart';

class LevelPage  extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _LevelPage();
  }

}

class _LevelPage extends State<LevelPage> {

  LevelController controller = Get.find();
  var textController=TextEditingController();
  var edittextController=TextEditingController();
  var extractedtextController=TextEditingController();
  var usertextController=TextEditingController();
  var notstextController=TextEditingController();
  final AudioRecorder audioRec = AudioRecorder();
  final AudioPlayer audiPl = AudioPlayer();

  final String sampleText = "هذا نص تجريبي لاختبار التلوين حسب الفهرس";
  final String jsonResponse = '{"results":[[1,2],[4,10]]}';

  bool isRecoding =false;
  bool isPlaying =false;
  String? Recordingpath ;
  final double horizontalPadding = 40;
  final double verticalPadding = 25;

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    final String id = args["id"];
    final String text = args["text"];
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
                      'اقرأ النص التالي باسلوبك',
                      style: TextStyle(
                        color: sixBackColor, // Gold color
                        fontSize: 20,
                        fontFamily: 'Amiri', // Or any Arabic-style font
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'النص :',
                          style: TextStyle(
                            color: sixBackColor, // Gold color
                            fontSize: 20,
                            fontFamily: 'Amiri', // Or any Arabic-style font
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
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
                              color: thirdBackColor,
                              child: SingleChildScrollView(
                                child: Text(
                                  text,
                                  style: TextStyle(
                                    color: sixBackColor,
                                    fontSize: 28,
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
                                color: Color(0xFFD4AF37),
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
                                hint: "اكتب نص تريد التدرب عليه",
                                color: Color(0xFFD4AF37),
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
                          child: CircularProgressIndicator(color: Color(0xFFD4AF37),),
                        )

                            : controller.aftershakilni == true ?
                        controller.editpart == false ?
                        // newDefaultButton(
                        //     background: sixBackColor,
                        //     text: "تعديل".tr,
                        //     //  background: HexColor(green.toString()),
                        //     function: ()async{
                        //       controller.editpart(true);
                        //       edittextController.text = text;
                        //
                        //     },
                        //
                        //     width: 80,
                        //     isAppbar: false
                        // )
                        Text("")
                            :controller.loadingsave == true ?
                        Center(
                          child: CircularProgressIndicator(color: Color(0xFFD4AF37),),
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
                            background: fifthBackColor,
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
                    // Arabic phrase text
                    controller.aftershakilni == true ?
                    Center(
                      child: Obx(() {
                        if (controller.gettingaudiolouding.value) {
                          return CircularProgressIndicator();
                        }

                        return Card(
                          color: Colors.white,
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                controller.ihavetheaudio.value
                                    ? Text(
                                  '🎧 للاستماع الى النص',
                                  style: TextStyle(
                                    color: sixBackColor,
                                    fontSize: 20,
                                    fontFamily: 'Amiri',
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                )
                                    : newDefaultButton(
                                  background: fifthBackColor,
                                  text: "استمع الى النص  ▶",
                                  function: () async {
                                    await controller.fetchAudio(text);
                                    controller.ihavetheaudio(true);
                                  },
                                  width: 180,
                                  isAppbar: false,
                                ),
                                const SizedBox(height: 20),

                                if (controller.audioUrl.value.isNotEmpty) ...[
                                  // 🎶 Progress Bar
                                  StreamBuilder<Duration>(
                                    stream: controller.player.positionStream,
                                    builder: (context, snapshot) {
                                      final position = snapshot.data ?? Duration.zero;
                                      final total = controller.player.duration ?? Duration.zero;
                                      return Column(
                                        children: [
                                          Slider(
                                            value: position.inSeconds.toDouble(),
                                            max: total.inSeconds.toDouble() > 0
                                                ? total.inSeconds.toDouble()
                                                : 1,
                                            activeColor: fifthBackColor,
                                            onChanged: (value) {
                                              controller.player.seek(Duration(seconds: value.toInt()));
                                            },
                                          ),
                                          Text(
                                            "${position.toString().split('.').first} / ${total.toString().split('.').first}",
                                            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                                          ),
                                        ],
                                      );
                                    },
                                  ),

                                  const SizedBox(height: 10),

                                  // 🎛 Control Buttons
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.replay, color: fifthBackColor, size: 35),
                                        onPressed: () => controller.player.seek(Duration.zero),
                                      ),
                                      Obx(() {
                                        return IconButton(
                                          icon: Icon(
                                            controller.isPlaying.value
                                                ? Icons.pause_circle_filled
                                                : Icons.play_circle_fill,
                                            color: fifthBackColor,
                                            size: 50,
                                          ),
                                          onPressed: () {
                                            controller.isPlaying.value
                                                ? controller.pauseAudio()
                                                : controller.playAudio();
                                          },
                                        );
                                      }),
                                      IconButton(
                                        icon: Icon(Icons.stop, color: Colors.redAccent, size: 35),
                                        onPressed: controller.stopAudio,
                                      ),
                                    ],
                                  ),
                                ]
                              ],
                            ),
                          ),
                        );
                      }),
                    )
                        :Text(''),

                    SizedBox(height: 24),
                controller.showrecordoption == false?
                controller.aftershakilni == true ?
                newDefaultButton(
                    background: sixBackColor,
                    text: "اختبر نفسي".tr,
                    //  background: HexColor(green.toString()),
                    function: ()async{
                      controller.showrecordoption(true);
                    },

                    width: 120,
                    isAppbar: false
                ):Text('')
                    :Column(
                  children: [
                    Text(
                      'سجل صوتك للاختبار',
                      style: TextStyle(
                        color: sixBackColor, // Gold color
                        fontSize: 20,
                        fontFamily: 'Amiri', // Or any Arabic-style font
                      ),
                    ),
                    SizedBox(height: 5),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _recordingButten(),
                        const SizedBox(width: 20,),
                        _buildUI(),
                      ],
                    ),

                    SizedBox(height: 20),

                    // "صححلي" button
                    controller.loading1 == true ?
                    Center(
                      child: CircularProgressIndicator(color: fourthBackColor),
                    )

                        :
                    newDefaultButton(
                        background: fifthBackColor,
                        text: "صحح لي".tr,
                        //  background: HexColor(green.toString()),
                        function: ()async{
                          controller.text =  text;


                          await Permission.storage.status;
                          Directory generalDownloadDir = Directory('/storage/emulated/0/Download');
                          File originalFile = File(Recordingpath!);
                          print(Recordingpath);
                          // String newPath = '${generalDownloadDir.path}/${originalFile.path.split('/').last}';
                          // await originalFile.copy(newPath);
                          controller.audioPath = Recordingpath!;


                          onClickcorrect();
                        },

                        width: 100,
                        isAppbar: false
                    ),
                    ]),

                    SizedBox(height: 24),

                    controller.correctStatustoshow == true ?
                        Column(
                          children: [
                            Container(
                              height: 100, // Or any suitable height
                              color: thirdBackColor,
                              child:  SingleChildScrollView(
                                scrollDirection: Axis.vertical, // vertical scroll
                                child: Wrap(
                                  textDirection: TextDirection.rtl,
                                  alignment: WrapAlignment.start,
                                  runSpacing: 8, // spacing between lines
                                  children: controller.correctTextWords.map((word) {
                                    HighlightRange? highlight;
                                    try {
                                      highlight = controller.highlights.firstWhere((h) => h.correctText == word);
                                    } catch (e) {
                                      highlight = null;
                                    }

                                    Widget wordWidget;
                                    if (highlight != null) {
                                      wordWidget = Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            highlight.predictedText,
                                            style: TextStyle(color: sixBackColor, fontSize: 24),
                                            textDirection: TextDirection.rtl,
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            highlight.correctText,
                                            style: TextStyle(color: Colors.red, fontSize: 28),
                                            textDirection: TextDirection.rtl,
                                          ),
                                        ],
                                      );
                                    } else {
                                      wordWidget = Text(
                                        word,
                                        style: TextStyle(color: sixBackColor, fontSize: 28),
                                        textDirection: TextDirection.rtl,
                                      );
                                    }

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                      child: wordWidget,
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),

                            SizedBox(height: 10,),
                            Text(
                              "النتيجة على مستوى كل من :",
                              style: TextStyle(color: sixBackColor),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 5,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("الكلمة", style: TextStyle(color: sixBackColor),),
                                    buildWerPieChart(controller.results_wer),
                                  ],
                                ),
                                const SizedBox(width: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("التشكيل", style: TextStyle(color: sixBackColor),),
                                    buildWerPieChart(controller.results_der),
                                  ],
                                ),
                                const SizedBox(width: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("الحرف", style: TextStyle(color: sixBackColor),),
                                    buildWerPieChart(controller.results_cer),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        )

                        : Text(" "),





                    SizedBox(height: 30,),
                     controller.correctStatustoshow == true ?

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        controller.loadingadd == true ?
                        Center(
                          child: CircularProgressIndicator(color: fourthBackColor,),
                        )
                            :
                        newDefaultButton(
                            background: fifthBackColor,
                            text: "اضافة الى المعرض".tr,
                            //  background: HexColor(green.toString()),
                            function: ()async{
                              controller.text = text;
                              controller.textid = id ;
                              await Permission.storage.status;
                              Directory generalDownloadDir = Directory('/storage/emulated/0/Download');
                              File originalFile = File(Recordingpath!);
                              print(Recordingpath);
                              // String newPath = '${generalDownloadDir.path}/${originalFile.path.split('/').last}';
                              // await originalFile.copy(newPath);
                              controller.audioPath = Recordingpath!;
                              onClickaddtoportifolio();
                            },

                            width: 150,
                            isAppbar: false
                        ),

                        SizedBox(width: 10),
                        controller.loadingprotest == true ?
                        Center(
                          child: CircularProgressIndicator(color: fourthBackColor,),
                        )
                            :
                        newDefaultButton(
                            background: sixBackColor,
                            text: "الاعتراض".tr,
                            //  background: HexColor(green.toString()),
                            function: ()async{
                              usertextController.text = text ;
                              Get.dialog(
                                  AlertDialog(
                                    title: Text("يمكنك تعديل النص بما تراه مناسب و اضافة ملاحظات"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        defaultTextFieldfortext(
                                            height: 90,
                                            controller:usertextController,
                                            type: TextInputType.text,
                                            hint: "ادخل النص الصحيح برأيك",
                                            color: fourthBackColor,
                                            validate:(value){
                                              if(value.isEmpty)
                                              {
                                                return "Your text must not be empty";
                                              }
                                              else{
                                                return null;
                                              }
                                            },
                                            prefix:Icons.book_outlined),
                                        SizedBox(height: 5),
                                        defaultTextFieldfortext(
                                            height: 90,
                                            controller:notstextController,
                                            type: TextInputType.text,
                                            hint: "ملاحظات",
                                            color: fourthBackColor,
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


                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: ()  async {
                                          controller.usertext = usertextController.text;
                                          controller.notetext = notstextController.text;
                                          await Permission.storage.status;
                                          Directory generalDownloadDir = Directory('/storage/emulated/0/Download');
                                          File originalFile = File(Recordingpath!);
                                          print(Recordingpath);
                                          controller.audioPath = Recordingpath!;
                                          onClickprotest();
                                          Get.back(); // Close dialog
                                        },
                                        child: Text("ارسال الاعتراض"),
                                      ),
                                    ],
                                  )
                              );
                            },

                            width: 150,
                            isAppbar: false
                        ),

                      ],
                    )
                     : Text(" "),
                    SizedBox(height: 10,),
                    controller.correctStatustoshow == true?
                    newDefaultButton(
                        background: sixBackColor,
                        text: "اعادة".tr,
                        //  background: HexColor(green.toString()),
                        function: ()async{
                          controller.correctStatustoshow(false);
                          controller.editpart(false);
                        },

                        width: 80,
                        isAppbar: false
                    )
                  : Text(" "),



                  ],
                )
            ),
          )
      ),
    );
  }


  void onClickaddtoportifolio() async {
    await controller.addtoportifolioOnClick();

  }
  void onClickprotest() async {
    await controller.protestOnClick();
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

  Widget   _buildUI(){
    return SizedBox(
      width: MediaQuery.sizeOf(context).width *.20,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if(Recordingpath != null) MaterialButton(
            elevation: 0,
            onPressed: () async{
            if(audiPl.playing){
              audiPl.stop();
              setState(() {
                isPlaying = false;
              });
            }else{
              await audiPl.setFilePath(Recordingpath!);
              audiPl.play();
              setState(() {
                isPlaying = true;
              });
            }
          },
            color: firstBackColor,
            child:  Icon(isPlaying? Icons.pause_outlined :Icons.play_arrow_outlined, color: fifthBackColor,size: 50,),),
          if(Recordingpath == null)  Text(" ".tr),

        ],),
    );
  }
  Widget _recordingButten(){
    return FloatingActionButton(
      elevation: 0,
      backgroundColor: firstBackColor,
      foregroundColor: firstBackColor,
      onPressed: ()async{
        if(isRecoding){
          String? filepath = await audioRec.stop();

          if(filepath != null){
            setState(() {
              isRecoding = false;
              Recordingpath = filepath;
              print("GO find it here : $Recordingpath");
            });
          }

        }else{
          await Permission.storage.status;
          if(await audioRec.hasPermission()){
            final Directory appDocumentsDir= await getApplicationDocumentsDirectory();
            final String filePath = p.join(appDocumentsDir.path, "recording.wav");

            await audioRec.start( RecordConfig( encoder: AudioEncoder.wav ), path: filePath);

            setState(() {
              isRecoding =true;
              Recordingpath =null;
            });
          }
        }
      } ,child:  Icon(isRecoding? Icons.stop :Icons.mic , color:fifthBackColor ,size: 40),);
  }



  List<TextSpan> buildHighlightedSpans(String text, List<List<int>> highlights) {
    List<TextSpan> spans = [];

    // Sort to avoid overlapping and unordered ranges
    //highlights.sort((a, b) => a[0].compareTo(b[0]));

    int currentIndex = 0;

    for (final range in highlights) {
      int start = range[0];
      int end = range[1];

      if (start > currentIndex) {
        spans.add(TextSpan(
          text: text.substring(currentIndex, start),
          style: TextStyle(color: Colors.white),
        ));
      }

      spans.add(TextSpan(
        text: text.substring(start, end),
        style: TextStyle(color: Colors.red),
      ));

      currentIndex = end;
    }

    if (currentIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(currentIndex),
        style: TextStyle(color: Colors.white),
      ));
    }

    return spans;
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
