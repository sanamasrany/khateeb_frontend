import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:birth_picker/birth_picker.dart';
import 'package:khateeb/custom.dart';
import 'package:khateeb/editorwebapp/editorpages/editorrigester/editor_rgester_controller.dart';
import 'package:khateeb/pages/register/register_controller.dart';
import 'package:image_picker/image_picker.dart';

class EditorRegisterPage extends StatelessWidget{

  var firstnameController=TextEditingController();
  var lastnameController=TextEditingController();
  var emailController=TextEditingController();
  var passwordController=TextEditingController();
  var bioController=TextEditingController();



  EditorRegisterController  controller = Get.find();


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
                    Text("Register".tr,style: TextStyle(fontSize: 45,color:sixBackColor, ),),
                    const  SizedBox(height: 20),

                    Text("أصنع تأثيرًا بصوتك مع خطيب".tr
                      ,style: TextStyle(
                        color: sixBackColor,
                      ),),
                    const  SizedBox(height: 34),
                    Center(child:
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: controller.profileImage.value != null
                              ? FileImage(controller.profileImage.value!)
                              : AssetImage('assets/images/logo1.jpg') as ImageProvider,
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

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        defaultTextField(
                            width: MediaQuery.of(context).size.width *0.42,
                            controller:firstnameController,
                            type: TextInputType.emailAddress,
                            hint: "First name".tr,
                            validate:(value){
                              if(value.isEmpty)
                              {
                                return "Your First name must not be empty";
                              }
                              else{
                                return null;
                              }
                            },
                            prefix:Icons.person_outline),
                        const SizedBox(width: 5,),
                        defaultTextField(
                            width: MediaQuery.of(context).size.width *0.42,
                            controller:lastnameController,
                            type: TextInputType.emailAddress,
                            hint: "Last name".tr,
                            validate:(value){
                              if(value.isEmpty)
                              {
                                return "Your Last name must not be empty";
                              }
                              else{
                                return null;
                              }
                            },
                            prefix:Icons.person_outline),
                      ],
                    ),



                    const SizedBox(height: 20,),
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

                    const SizedBox(height: 20,),
                    defaultTextField(
                        controller:bioController,
                        type: TextInputType.emailAddress,
                        hint: "السيرة الذاتية".tr,
                        validate:(value){
                          if(value.isEmpty)
                          {
                            return null;
                          }
                          else{
                            return null;
                          }
                        },
                        prefix:Icons.create_outlined),

                    const SizedBox(height: 20,),
                    RadioListTile<String>(
                      activeColor: fifthBackColor,
                      title:  Text('ذكر'.tr , style: TextStyle(color: sixBackColor),),
                      value: 'MALE',
                      groupValue: controller.selectedGender.value,
                      onChanged: (value) => controller.selectedGender.value = value,
                    ),
                    RadioListTile<String>(
                      activeColor: fifthBackColor,
                      title:  Text('أنثى'.tr, style: TextStyle(color: sixBackColor),),
                      value: 'FEMALE',
                      groupValue: controller.selectedGender.value,
                      onChanged: (value) => controller.selectedGender.value = value,
                    ),
                    const SizedBox(height: 20,),

                    Text("الجنسية".tr
                      ,style: TextStyle(
                        color: Colors.white,
                      ),),
                    const SizedBox(height: 10,),
                    controller.countries.isEmpty ?
                    Center(child: CircularProgressIndicator())
                        : Center(child:
                    SizedBox(
                      width: 200, // set to whatever width you like
                      child: DropdownButtonFormField<String>(
                        isExpanded: true, // still lets text wrap inside
                        decoration: InputDecoration(labelText: "اختر بلدك",labelStyle:  TextStyle( color: Colors.white),),
                        items: controller.countries.map((country) {
                          return DropdownMenuItem<String>(
                            value: country.cca2,
                            child: Text(
                              country.name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 14, color: fifthBackColor),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          controller.selectedCountryCode.value = value ?? '';
                          print(controller.selectedCountryCode.value);
                        },
                      ),
                    )),
                    const SizedBox(height: 40,),

                    Text("هل العربية هي لغتك الأم ؟".tr
                      ,style: TextStyle(
                        color: Colors.white,
                      ),),
                    const SizedBox(height: 10,),


                    RadioListTile<String>(
                      activeColor: fifthBackColor,
                      title:  Text('نعم'.tr , style: TextStyle(color: sixBackColor),),
                      value: 'true',
                      groupValue: controller.native_arabic.value,
                      onChanged: (value) => controller.native_arabic.value = value,
                    ),
                    RadioListTile<String>(
                      activeColor: fifthBackColor,
                      title:  Text('لا'.tr, style: TextStyle(color: sixBackColor),),
                      value: 'false',
                      groupValue: controller.native_arabic.value,
                      onChanged: (value) => controller.native_arabic.value = value,
                    ),

                    const SizedBox(height: 20,),
                    Text("تاريخ الميلاد".tr
                      ,style: TextStyle(
                        color: Colors.white,
                      ),),
                    const SizedBox(height: 10,),
                    BirthPicker(
                      iconColor: sixBackColor,
                      textStyle: TextStyle(color: sixBackColor),
                      onChanged: (dateTime) {
                        if (dateTime != null) {
                          controller.birthdate = '${dateTime.year}-${dateTime.month}-${dateTime.day}';
                        } else {
                          print('Invalid Date');
                        }
                      },
                    ),

                    const SizedBox(height: 30,),
                    controller.loading == true ?

                    Center(
                      child: CircularProgressIndicator(),
                    )

                        :newDefaultButton(

                        background: sixBackColor,
                        text: "Continue".tr,
                        //  background: HexColor(green.toString()),
                        function: ()async{
                          controller.email = emailController.text;
                          controller.password = passwordController.text;
                          controller.first_name = firstnameController.text;
                          controller.last_name = lastnameController.text;
                          controller.bio = bioController.text;

                          onClickContinueregister();
                        },

                        width: double.infinity,
                        isAppbar: false
                    ),

                    const  SizedBox(height:10,),

                    Row(
                      mainAxisAlignment:MainAxisAlignment.center,
                      children:  [
                        Text("Already have an account ?".tr,style:TextStyle(
                          color: sixBackColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,

                        ),),
                        defaultTextButton(
                            color: sixBackColor,
                            function:(){
                              Get.offAllNamed('/login');
                            }
                            , text: "Login".tr
                        ),


                      ],
                    ),
                    const  SizedBox(height:5,),


                  ],
                )),
          ),
        ),
      ),

    );
  }

  void onClickContinueregister() async {

    await controller.RegisterOnClick();
    if (controller.registerStatus) {
      Get.offNamed('/editorhome');
    }else{
      print('error');
    }
  }


}