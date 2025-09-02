import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:khateeb/custom.dart';
import 'package:get/get.dart';
import 'package:khateeb/pages/mvp/mvp_controller.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';


class MvpPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MvpPage();
  }

}


class _MvpPage extends State<MvpPage> {

  mvpController controller = Get.find();
  var textController=TextEditingController();
  final AudioRecorder audioRec = AudioRecorder();
  final AudioPlayer audiPl = AudioPlayer();

  final String sampleText = "هذا نص تجريبي لاختبار التلوين حسب الفهرس";
  final String jsonResponse = '{"results":[[1,2],[4,10]]}';


  bool isRecoding =false;
  bool isPlaying =false;
  String? Recordingpath ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body:
      SafeArea(
        child: SingleChildScrollView(
        padding:const EdgeInsets.all(24.0),
        child:
    Obx(()=>
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 100),
            // Logo at the top
            Image.asset('assets/images/logo1.jpg', height: 100),

            SizedBox(height: 24),

            // Arabic phrase text
            Text(
              'مرحبا بك في تطبيق خطيب',
              style: TextStyle(
                color: Color(0xFFD4AF37), // Gold color
                fontSize: 24,
                fontFamily: 'Amiri', // Or any Arabic-style font
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child:
                  defaultTextField(
                    height: 130,
                    controller:textController,
                    type: TextInputType.text,
                    hint: "اكتب ما تود تشكيلة..",
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
                    prefix:Icons.book_outlined)),
                SizedBox(width: 5,),
                controller.loading == true ?
                Center(
                  child: CircularProgressIndicator(color: Color(0xFFD4AF37),),
                )

                    :
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Color(0xFFD4AF37),
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                  onPressed: () {
                    controller.text = textController.text;
                    onClickdiacritizeme(); },
                  child: Text('شكلني', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),

            SizedBox(height: 20),
            // Arabic phrase text

            Container(
              height: 90, // Or any suitable height
              child: SingleChildScrollView(
                child: Text(
                  controller.diacritize_text.value,
                  style: TextStyle(
                    color: Color(0xFFD4AF37),
                    fontSize: 24,
                    fontFamily: 'Amiri',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _recordingButten(),
                const SizedBox(width: 50,),
                _buildUI(),
              ],
            ),

            // Mic + Audio player row
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     IconButton(
            //       icon: Icon(Icons.mic_none, color: Color(0xFFD4AF37)),
            //       onPressed: () {
            //         // Start recording
            //       },
            //     ),
            //     SizedBox(width: 16),
            //     Expanded(
            //       child: Container(
            //         height: 50,
            //         decoration: BoxDecoration(
            //           color: Colors.white10,
            //           borderRadius: BorderRadius.circular(12),
            //         ),
            //         child: Center(
            //           child: Text(
            //             'Audio Player Placeholder',
            //             style: TextStyle(color: Colors.white70),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),

            SizedBox(height: 24),

            controller.correctStatustoshow == true ?
            RichText(
            text: TextSpan(
            children: buildHighlightedSpans(controller.diacritize_text.value, controller.highlights),
        style: TextStyle(fontSize: 20, fontFamily: 'Amiri'),
            ),
           )
           : Text(" "),
           SizedBox(height: 24),

            // "صححلي" button
            controller.loading1 == true ?
            Center(
              child: CircularProgressIndicator(color: Color(0xFFD4AF37),),
            )

                :
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Color(0xFFD4AF37),
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              onPressed: () async {
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
              child: Text('صحح لي', style: TextStyle(fontSize: 18)),
            ),


          ],
        )
    ),
      )
      ),
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

  Widget   _buildUI(){
    return SizedBox(
      width: MediaQuery.sizeOf(context).width *.45,
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
            color: Colors.black,
            child:  Icon(isPlaying? Icons.pause_outlined :Icons.play_arrow_outlined, color: Color(0xFFD4AF37),),),
          if(Recordingpath == null)  Text(" ".tr),

        ],),
    );
  }
  Widget _recordingButten(){
    return FloatingActionButton(
      backgroundColor: Colors.black,
      foregroundColor: Colors.black,
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
      } ,child:  Icon(isRecoding? Icons.stop :Icons.mic , color: Color(0xFFD4AF37),),);
  }



  List<TextSpan> buildHighlightedSpans(String text, List<List<int>> highlights) {
    List<TextSpan> spans = [];

    // Sort to avoid overlapping and unordered ranges
    highlights.sort((a, b) => a[0].compareTo(b[0]));

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
}
