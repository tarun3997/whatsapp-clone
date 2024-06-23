import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp/screens/home_screen.dart';
import 'package:whatsapp/utils/Helper.dart';
import 'package:whatsapp/utils/error_handel.dart';

import '../../server/server-url.dart';
import '../../themes/colors.dart';

class ProfileInfoScreen extends StatefulWidget {
  final String uid;
  final String phoneNum;
  const ProfileInfoScreen({super.key, required this.uid, required this.phoneNum});

  @override
  State<ProfileInfoScreen> createState() => _ProfileInfoScreenState();
}

class _ProfileInfoScreenState extends State<ProfileInfoScreen> {
  final TextStyle textStyle1 = GoogleFonts.getFont('Roboto',color: const Color(0xffffffff),fontSize: 15);
  final TextStyle textStyle2 = GoogleFonts.getFont('Roboto',color: const Color(0xff56ACD1),fontSize: 15,fontWeight: FontWeight.w500);
  final TextStyle textStyle3 = GoogleFonts.getFont('Roboto',color: const Color(0xff000000),fontSize: 16,fontWeight: FontWeight.w600);
  final TextStyle textStyle4 = const TextStyle(color: Color(0xff0b9d7e));

  File ? selectedImage;
  final formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.darkBGColor,
      body:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 30,horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Text("Profile info",style: GoogleFonts.getFont('Roboto',color: Colors.white, fontSize: 20,fontWeight: FontWeight.w600),),
                        const Spacer(),
                        const Icon(Icons.more_vert_outlined,color: Color(0xff8596a0),)
                      ],
                    ),
                  ),
                  Text("Please provide your name and an optional profile photo",style: textStyle1,textAlign: TextAlign.center,)
                ],)
              ,),
            GestureDetector(
              onTap: () {
                _pickProfileImage();
              },
              child: ClipOval(
                child: SizedBox(
                  width: 120,
                  height: 120,
                  child: selectedImage != null
                      ? Image.file(selectedImage!, fit: BoxFit.cover)
                      : Container(
                    color: const Color(0xff283339),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Color(0xff60717B),
                      size: 60,
                    ),
                  ),
                ),
              ),
            ),


            Container(
              width: width,
              margin: const EdgeInsets.only(left: 20,right: 20,top: 30),
              child: Row(children: [
                SizedBox(
                  width: width * 0.78,
                  child: FormBuilder(
                    key: formKey,
                    child: FormBuilderTextField(
                      name: 'name',
                      cursorColor: AppColors.fontColor1,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Type your name here',
                        hintStyle: TextStyle(color: AppColors.fontColor1),
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff8596a0),width: 1.5)
                        ),
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(errorText: 'Please enter your name')
                      ]),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.emoji_emotions,color: Color(0xff8596a0),),
                )
              ],),
            ),
            const Spacer(),
            GestureDetector(
              onTap: (){
                if(formKey.currentState?.saveAndValidate() ?? false){
                  final name = formKey.currentState?.fields['name']?.value;
                  sendProfileInfoToNode(name);

                }

              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 14),
                width: 100,
                height: 45,
                decoration: BoxDecoration(
                    color: const Color(0xff00a884),
                    borderRadius: BorderRadius.circular(50)
                ),
                child: Center(child: Text("Next",style: textStyle3,)),
              ),
            )

          ]),
    );
  }
  void _pickProfileImage() {
    showModalBottomSheet(
      backgroundColor: AppColors.dialogBGColor,
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.camera,color: Colors.white,),
              title: const Text('Take a photo',style: TextStyle(color: Colors.white),),
              onTap: () {
                Navigator.pop(context);
                _getImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library,color: Colors.white,),
              title: const Text('Choose from gallery',style: TextStyle(color: Colors.white),),
              onTap: () {
                Navigator.pop(context);
                _getImage(ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }


  void sendProfileInfoToNode(String? name) async{
    String  nodeJSEndpointProfile = '$uri/auth/register';

    String uid = widget.uid;
    String phoneNum = widget.phoneNum;
    // Map<String, String> profileInfo = {'uid': uid, 'number': phoneNum, 'name' : name ?? ''};

    FormData formData = FormData.fromMap({
      'uid': uid,
      'name': name ?? '',
      'number': phoneNum,
      'profileImage': await MultipartFile.fromFile(selectedImage!.path),
    });

    try{
      Dio dio = Dio();
      Response response = await dio.post(nodeJSEndpointProfile, data: formData);
      String token = response.data['token'];
      Helper().setToken(token);
      print('Token: $token');
       Navigator.push(context, MaterialPageRoute(builder: (context)=> InitializingScreen()));
    }catch(e){
      print('this $e');
      ErrorHandler.showError(context, e);
    }
  }
}

class InitializingScreen extends StatelessWidget {
  InitializingScreen({super.key});

  final TextStyle textStyle1 = GoogleFonts.getFont('Roboto',color: const Color(0xff81919A));
  final TextStyle textStyle2 = GoogleFonts.getFont('Roboto',color: const Color(0xff56ACD1),fontSize: 14,fontWeight: FontWeight.w500);
  final TextStyle textStyle3 = GoogleFonts.getFont('Roboto',color: const Color(0xff000000),fontSize: 16,fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3),(){
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false);
    });
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.darkBGColor,
        body:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 30),
                width: width,
                  child: Column(
                    children: [
                      Text("Initializing...",style: GoogleFonts.getFont('Roboto',color: Colors.white, fontSize: 20,fontWeight: FontWeight.w600),),
                      Text("Please wait a moment",style: textStyle1,),
                    ],
                  )),
              const Spacer(),
              const CircleAvatar(
                radius: 120,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage('assets/images/welcome-screen.png'),
              ),
              const Spacer(flex: 2),
              const CircularProgressIndicator(color: AppColors.fontColor1,),
              const SizedBox(height: 50,)

            ]),
      ),
    );
  }
}

