import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khateeb/pages/URL/url_controller.dart';
import 'package:khateeb/utiles.dart';
import '../../custom.dart';

class URLPage extends StatelessWidget{


  var urltextController=TextEditingController();
  urlController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: h(),
      backgroundColor: Colors.black,
      body:Container(
        height:MediaQuery.of(context).size.height ,
        width: MediaQuery.of(context).size.width,
        child:SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 150),
              child:
              Obx(() =>
                  Column(

                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:  [
                      Text("URL :".tr,style: TextStyle(fontSize: 45,color:Color(0xFFD4AF37), ),),
                      const  SizedBox(height: 20),

                      defaultTextField(

                          controller:urltextController,
                          type: TextInputType.emailAddress,
                          hint: "URL".tr,
                          validate:(value){
                            if(value.isEmpty)
                            {
                              return "Your email must not be empty";
                            }
                            else{
                              return null;
                            }
                          },
                          prefix:Icons.network_check_outlined , color: Color(0xFFD4AF37),),
                      SizedBox(height: 30,),
                      controller.loading == true ?
                      Center(
                        child: CircularProgressIndicator(),
                      )
                          :
                      newDefaultButton(
                          c1: Color(0xFFD4AF37),
                          text: "Continue".tr,
                          //  background: HexColor(green.toString()),
                          function: (){
                            controller.url = urltextController.text;
                            onClickContinue();
                          },

                          width: double.infinity,
                          isAppbar: false
                      ),
                        //  fallback: (context) =>
                        //  const Center(child: CircularProgressIndicator()),
                        // ),
                      const  SizedBox(height:30,),
                      newDefaultButton(
                          c1: Color(0xFFD4AF37),
                          text: "stick with basic url".tr,
                          function: (){
                            controller.url = Utiles.baseurl;
                            onClickContinue();
                          },

                          width: double.infinity,
                          isAppbar: false
                      ),



                    ],
                  ),
              )
          ),
        ),

    )
    );
  }

  void onClickContinue() async {
    await controller.urlOnClick();
      Get.offNamed('/mvp');
      print("go /mvp");
  }

}