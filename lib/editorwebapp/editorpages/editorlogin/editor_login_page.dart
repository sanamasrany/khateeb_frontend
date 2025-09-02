
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khateeb/custom.dart';

import 'editor_login_controller.dart';

class EditorLoginPage extends StatelessWidget{

  EditorloginController controller = Get.find(); //find me the controller

  var emailController=TextEditingController();
  var passwordController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: h(),
      body:Container(
        height:MediaQuery.of(context).size.height ,
        width: MediaQuery.of(context).size.width,
        decoration: gradientBackground,
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
                      Text("Login".tr,style: TextStyle(fontSize: 45,color:sixBackColor, ),),
                      const  SizedBox(height: 20),

                      Text("أصنع تأثيرًا بصوتك مع خطيب".tr
                        ,style: TextStyle(
                          color: sixBackColor,
                        ),),
                      const  SizedBox(height: 34),

                      defaultTextField(

                          controller:emailController,
                          type: TextInputType.emailAddress,
                          hint: "Email".tr,
                          validate:(value){
                            if(value.isEmpty)
                            {
                              return "Your email must not be empty";
                            }
                            else{
                              return null;
                            }
                          },
                          prefix:Icons.email_outlined),
                      const SizedBox(height: 20,),
                      defaultTextFieldPassword(
                        controller: passwordController,
                        type: TextInputType.emailAddress,
                        hint: "Password".tr,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return "Your password must not be empty";
                          }
                          return null;
                        },
                        prefix:Icons.lock_outline,
                      ),


                      SizedBox(height: 30,),

                      controller.loading == true ?
                      Center(
                        child: CircularProgressIndicator(),
                      )

                          :
                      newDefaultButton(

                          background: sixBackColor,
                          text: "Continue".tr,
                          //  background: HexColor(green.toString()),
                          function: (){
                            controller.email = emailController.text;
                            controller.password = passwordController.text;
                            onClickContinue();
                          },

                          width: double.infinity,
                          isAppbar: false
                      ),
                      //    fallback: (context) =>
                      //    const Center(child: CircularProgressIndicator()),
                      //   ),
                      const  SizedBox(height:10,),


                      const  SizedBox(height:10,),
                      Row(
                        mainAxisAlignment:MainAxisAlignment.center,
                        children:  [
                          Text("Don`t have an account ?".tr,style:TextStyle(
                            color: sixBackColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,

                          ),),
                          defaultTextButton(
                              color: sixBackColor,
                              function:(){
                                Get.offAllNamed('/register');
                              }
                              , text: "Register".tr
                          ),


                        ],
                      ),
                      const  SizedBox(height:5,),


                    ],
                  ),
              )
          ),
        ),
      ),

    );
  }

  void onClickContinue() async {

    await controller.LoginOnClick();
    if (controller.loginStatus) {
      Get.offNamed('/editorhome');
      print("go /home");
    }else{
      print('error');
    }
  }

}