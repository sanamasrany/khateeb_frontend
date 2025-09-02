import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:khateeb/custom.dart';
import 'package:just_audio/just_audio.dart';
import 'package:khateeb/models/errorshow.dart';
import 'package:khateeb/pages/text/text_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class TextPage  extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _TextPage();
  }

}


class _TextPage extends State<TextPage> {

  TextController controller = Get.find();
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
                _buildFab(icon: Icons.home, onPressed: () {onClickhome();}, label: "Home" ,background: thirdBackColor),
                _buildFab(icon: Icons.work_history_outlined, onPressed: () {Get.toNamed('/jobrequest');}, label: "job request" ,background: thirdBackColor),
                _buildFab(icon: Icons.search, onPressed: () {onClicksearch();}, label: "Search" ,background: thirdBackColor),
                _buildFab(icon: Icons.text_snippet, onPressed: () {}, label: "Add Text" ,background: fifthBackColor),
              ],
            ),
          ),
        ),
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
                    Image.asset('assets/images/kateeb.jpg', height: 150),

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
                                  height: 150, // Or any suitable height
                                  color: thirdBackColor,
                                  child: SingleChildScrollView(
                                    child: Text(
                                      controller.diacritize_text.value,
                                      style: TextStyle(
                                        color: sixBackColor,
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
                                    hint: "اكتب نص تريد التدرب عليه",
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
                            controller.ihavetheaudio == false?
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
                        ):Text('')
                        :controller.loadingsave == true ?
                        Center(
                          child: CircularProgressIndicator(color: fourthBackColor,),
                        ):
                        newDefaultButton(
                            background: sixBackColor,
                            text: "حفظ".tr,
                            //  background: HexColor(green.toString()),
                            function: ()async{
                              controller.editpart(false);
                              controller.aftershakilni(true);
                              controller.diacritize_text.value = edittextController.text;

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
                    // Arabic phrase text




                    SizedBox(height: 24),
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
                                    await controller.fetchAudio();
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
                    SizedBox(height: 40,),

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
                      child: CircularProgressIndicator(color: fourthBackColor,),
                    )

                        :
                    newDefaultButton(
                        background: sixBackColor,
                        text: "صحح لي".tr,
                        //  background: HexColor(green.toString()),
                        function: ()async{
                          controller.text = textController.text;
                          // await Permission.storage.status;
                          // if (await Permission.manageExternalStorage.request().isGranted) {
                          //   Directory generalDownloadDir = Directory('/storage/emulated/0/Download');
                          //   File originalFile = File(Recordingpath!);
                          //   print(Recordingpath);
                          //   String newPath = '${generalDownloadDir.path}/${originalFile.path.split('/').last}';
                          //   await originalFile.copy(newPath);
                          //   controller.audioPath = newPath;
                          // } else {
                          //   openAppSettings(); // Show user how to enable
                          // }

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
                    ]
                ),

                    SizedBox(height: 24),

                    controller.correctStatustoshow == true ?
                    Column(
                      children: [
                        // AnnotatedArabicText(
                        //   text: controller.diacritize_text.value,         // correct_text
                        //   highlights: controller.highlights,              // List<HighlightRange>
                        //   baseStyle: const TextStyle(fontSize: 20, fontFamily: 'Amiri', color: Colors.white),
                        //   highlightStyle: const TextStyle(fontSize: 20, fontFamily: 'Amiri', color: Colors.red),
                        //   predictedStyle: const TextStyle(fontSize: 14, fontFamily: 'Amiri', color: Colors.white),
                        //   labelGap: 4, // tweak spacing above red part
                        // ),
                        Container(
                          height: 150, // Or any suitable height
                          color: thirdBackColor,
                          width: 300,
                          child:
                          Center(
                            child: SingleChildScrollView(
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
                          )

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
                                Text("الحرف" , style: TextStyle(color: sixBackColor),),
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
                            background: sixBackColor,
                            text: "اضافة الى المعرض".tr,
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
                                        controller.text = textController.text;
                                        await Permission.storage.status;
                                        Directory generalDownloadDir = Directory('/storage/emulated/0/Download');
                                        File originalFile = File(Recordingpath!);
                                        print(Recordingpath);
                                        // String newPath = '${generalDownloadDir.path}/${originalFile.path.split('/').last}';
                                        // await originalFile.copy(newPath);
                                        controller.audioPath = Recordingpath!;

                                        onClickaddtoportifolio();
                                        Get.back(); // Close dialog
                                      },
                                      child: Text("اضافة الى المعرض"),
                                    ),
                                  ],
                                )),
                              );
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
                              usertextController.text = controller.diacritize_text.value ;
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
                                        prefix:Icons.book_outlined),
                                    SizedBox(height: 5),
                                    defaultTextFieldfortext(
                                        height: 90,
                                        controller:notstextController,
                                        type: TextInputType.text,
                                        hint: "ملاحظات",
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
                    controller.correctStatustoshow == true ?
                    newDefaultButton(
                        background: sixBackColor,
                        text: "اعادة".tr,
                        //  background: HexColor(green.toString()),
                        function: ()async{
                          controller.aftershakilni(false);
                          controller.correctStatustoshow(false);
                          controller.editpart(false);
                          controller.showrecordoption(false);
                          textController.text = '';
                        },

                        width: 80,
                        isAppbar: false
                    ): Text(" "),



                  ],
                )
            ),
          )
      ),
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

  void onClickaddtoportifolio() async {
     await controller.addtoportifolioOnClick();

  }
  void onClickprotest() async {
    await controller.protestOnClick();
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
          if(Recordingpath != null) MaterialButton(onPressed: () async{
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
            elevation: 0,
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
      } ,child:  Icon(isRecoding? Icons.stop :Icons.mic , color: fifthBackColor,size: 40),);
  }

  List<InlineSpan> buildHighlightedSpansWithPredicted(
      String text, List<HighlightRange> highlights) {

    List<InlineSpan> spans = [];
    int currentIndex = 0;

    // Sort highlights by start ASC
    final sortedHighlights = [...highlights]..sort((a,b)=> a.start.compareTo(b.start));

    for (final r in sortedHighlights) {
      // Extend highlight to full word boundaries
      int start = _findWordStart(text, r.start);
      int end = _findWordEnd(text, r.end);
      String predicted = r.predictedText;

      // Normal text before red word
      if (start > currentIndex) {
        spans.add(TextSpan(
          text: text.substring(currentIndex, start),
          style: TextStyle(color: sixBackColor, fontSize: 20),
        ));
      }

      // Red word + predicted above
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                predicted,
                style: TextStyle(color: sixBackColor, fontSize: 14),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
              SizedBox(height: 2),
              Text(
                text.substring(start, end),
                style: TextStyle(color: Colors.red, fontSize: 20),
                textDirection: TextDirection.rtl,
              ),
            ],
          ),
        ),
      );

      currentIndex = end;
    }

    // Remaining text
    if (currentIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(currentIndex),
        style: TextStyle(color: sixBackColor, fontSize: 20),
      ));
    }

    return spans;
  }



// Helpers to find word boundaries
  int _findWordStart(String text, int index) {
    while (index > 0 && text[index - 1] != ' ') {
      index--;
    }
    return index;
  }

  int _findWordEnd(String text, int index) {
    while (index < text.length && text[index] != ' ') {
      index++;
    }
    return index;
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