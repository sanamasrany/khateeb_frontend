import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';



const Color firstBackColor = Color(0xFFFFFFFF)  ;
const Color secondBackColor = Color(0xff04315b)  ;
const Color thirdBackColor = Color(0xfffef2e5) ;
const Color fourthBackColor = Color(0xffbe9962)  ;
const Color fifthBackColor =  Color(0xFF3dbfb7) ;
const Color sixBackColor = Color(0xFF191919) ;

const Color white = Color(0xFFFFFFFF) ;
const BoxDecoration gradientBackground = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [
        firstBackColor,
        firstBackColor,

      ],
      tileMode: TileMode.clamp,
    )

);

Widget buildWerPieChart(double? wer) {
  if (wer == null) {
    return const Text("No score available");
  }

  final correct = (1 - wer).clamp(0.0, 1.0);
  final error = wer.clamp(0.0, 1.0);

  return SizedBox(
    width: 80,
    height: 80,
    child: PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            value: correct,
            color: Color(0xFF3AA76D),
            title: "${(correct * 100).toStringAsFixed(0)}%",
            radius: 28,
            titleStyle: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          PieChartSectionData(
            value: error,
            color: Color(0xFFC94C4C),
            title: "${(error * 100).toStringAsFixed(0)}%",
            radius: 28,
            titleStyle: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
        sectionsSpace: 0,
        centerSpaceRadius: 12,
      ),
    ),
  );
}


Widget defaultTextField({
  required TextEditingController controller,
  required TextInputType type,
  Function? onSubmit,
  Function? onChange,
  bool isPassword = false,
  required validate,
  String? label,
  String? hint,
  required IconData prefix,
  IconData? suffix,
  Function()?suffixPressed,
  double width = double.infinity,
  double height = 60,
  Color color = fifthBackColor,


}) =>
    Container(
        width: width,
        height:height ,
        child:
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.multiline,
          maxLines: null, // Allows the field to grow with input
          minLines: 1,    // Minimum visible lines
          validator: validate,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            hintStyle: TextStyle(
              fontSize: 14,
              color: Color(0xff6C6D72),
              overflow: TextOverflow.visible,
            ),
            isDense: false,
            alignLabelWithHint: false,
            filled: true,
            fillColor: Color(0xffE5E4E2),
            labelText: label,
            hintText: hint,
            focusColor: color,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(35),
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10),
              child: Icon(prefix, color: color),
            ),
            suffixIcon: suffix != null
                ? IconButton(
              icon: Icon(suffix, color: color),
              onPressed: suffixPressed,
            )
                : null,
          ),
        )
    );

Widget searchTextField({
  required TextEditingController controller,
  required Function(String) onChanged,
  String hint = "ابحث...",
}) {
  return TextField(
    controller: controller,
    onChanged: onChanged, // ✅ this works
    decoration: InputDecoration(
      hintText: hint,
      prefixIcon: const Icon(Icons.search , color: fifthBackColor),
      suffixIcon: controller.text.isNotEmpty
          ? IconButton(
        icon: const Icon(Icons.clear , color: fifthBackColor,),
        onPressed: () {
          controller.clear();
          onChanged(""); // clear search results too
        },
      )
          : null,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
  );
}



Widget defaultTextFieldfortext({
  required TextEditingController controller,
  required TextInputType type,
  Function? onSubmit,
  Function? onChange,
  bool isPassword = false,
  required validate,
  String? label,
  String? hint,
  required IconData prefix,
  IconData? suffix,
  Function()?suffixPressed,
  double width = double.infinity,
  double height = 60,
  Color color = fifthBackColor,


}) =>
    Container(
        width: width,
        height:height ,
        child:
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.multiline,
          maxLines: null, // Allows the field to grow with input
          minLines: 3,    // Minimum visible lines
          validator: validate,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            hintStyle: TextStyle(
              fontSize: 14,
              color: Color(0xff6C6D72),
              overflow: TextOverflow.visible,
            ),
            isDense: false,
            alignLabelWithHint: false,
            filled: true,
            fillColor: Color(0xffE5E4E2),
            labelText: label,
            hintText: hint,
            focusColor: color,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(35),
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10),
              child: Icon(prefix, color: color),
            ),
            suffixIcon: suffix != null
                ? IconButton(
              icon: Icon(suffix, color: color),
              onPressed: suffixPressed,
            )
                : null,
          ),
        )
    );
var secure = true.obs;
Widget defaultTextFieldPassword({
  required TextEditingController controller,
  required TextInputType type,
  Function? onSubmit,
  Function? onChange,
  bool isPassword = true,
  required validate,
  String? label,
  String? hint,
  required IconData prefix,
  IconData? suffix,
  Function()?suffixPressed,


}) =>

    Obx(() =>  TextFormField(
      //cursorColor: PharmacyColor,
        controller: controller,
        keyboardType: type,
        obscureText: secure.value ,
        // onFieldSubmitted: onSubmit!(),
        //onChanged: onChange!(),
        validator: validate,
        decoration: InputDecoration(
          contentPadding: EdgeInsetsDirectional.zero,
          hintStyle: TextStyle(
            fontSize: 14,
            color: Color(0xff6C6D72),
            overflow: TextOverflow.visible,
          ),
          isDense: false,
          alignLabelWithHint: false,
          filled: true,
          fillColor: Color(0xffE5E4E2),
          labelText: label,
          hintText: hint,
          focusColor:fifthBackColor,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(35),

          ) ,
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 10.0,right:10),
            child:   Icon(prefix,color:fifthBackColor,),
          ),
          suffixIcon:GestureDetector(
            onTap: (){
              secure.value =! secure.value ;

            },
            child:  Icon (
              secure == true ? Icons.visibility : Icons.visibility_off
              ,color:fifthBackColor,
            ),
          ),


        )));


Widget newDefaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  Color c1 = fifthBackColor,
  Color c2 =  fifthBackColor ,
  bool isAppbar = true,
  required Function function,
  required String text,
}) =>
    Container(
      height: 47,
      width: width,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(35),
        gradient:LinearGradient(

          begin:  Alignment.topCenter,
          end:Alignment.bottomCenter ,

          colors: [
            c1,
            c2,

          ],


        ),
      ),
      child: MaterialButton(
        onPressed: () {
          function();
        },
        child: Text(
          isAppbar ? text.toUpperCase() : text,
          style:const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.normal
          ),
        ),
      ),
    );

Widget defaultTextButton({
  required VoidCallback? function,
  required String text,
  required Color color,
})=>TextButton(onPressed:function, child:Text(text,
    style:TextStyle(fontSize:14,color:color,fontWeight: FontWeight.bold)));




class PickedBox extends StatelessWidget {
  final String menuoptionName;
  final String pickedimage;
  VoidCallback? onClick;

  PickedBox({
    super.key,
    required this.menuoptionName,
    required this.pickedimage,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(15.0),
        child:
        GestureDetector(
          onTap: onClick,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: secondBackColor ,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 25.0 ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // icon
                  Image(image:
                  AssetImage(pickedimage) ,width: 90,height: 90,),


                ],
              ),
            ),
          ),)

    );
  }
}


void showToast({
  required String text,
  required ToastStates state,
  double fontsize = 15.0,
  int timeinsec = 10,
})=>Fluttertoast.showToast(
  msg: text,
  toastLength: Toast.LENGTH_SHORT,
  gravity: ToastGravity.BOTTOM,//ظهور
  timeInSecForIosWeb: timeinsec,
  backgroundColor: chooseToastColor(state),
  textColor: Colors.white,
  fontSize: fontsize,

);
enum ToastStates{
  SUCCESS,EROOR,WARNING
}
Color chooseToastColor(ToastStates state)
{  Color color;
switch(state){
  case ToastStates.SUCCESS:
    color= fifthBackColor;

    break;
  case ToastStates.EROOR:
    color=  Colors.redAccent;
    break;
  case ToastStates.WARNING:
    color=  Colors.amber;
    break;

}
return color;

}

