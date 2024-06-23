import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whatsapp/screens/login_screens/profile_info_screen.dart';
import '../../themes/colors.dart';

class VerifyingScreen extends StatefulWidget {
  final String number;
  final String verificationId;
  const VerifyingScreen({super.key, required this.number, required this.verificationId});

  @override
  State<VerifyingScreen> createState() => _VerifyingScreenState();
}

class _VerifyingScreenState extends State<VerifyingScreen> {
  final TextStyle textStyle1 = GoogleFonts.getFont('Roboto',color: const Color(0xffffffff),fontSize: 15);
  final TextStyle textStyle2 = GoogleFonts.getFont('Roboto',color: const Color(0xff56ACD1),fontSize: 15,fontWeight: FontWeight.w500);
  final TextStyle textStyle3 = GoogleFonts.getFont('Roboto',color: const Color(0xff000000),fontSize: 16,fontWeight: FontWeight.w600);
  final TextStyle textStyle5 = GoogleFonts.getFont('Roboto',color: const Color(0xffffffff),fontSize: 16,fontWeight: FontWeight.w600);
  final TextStyle textStyle4 = const TextStyle(color: Color(0xff0b9d7e));

  final formKey = GlobalKey<FormBuilderState>();
  final List<FocusNode> _focusNode = [];
  final List<TextEditingController> _controller = [];
  late Timer timer;
  int timeDuration = 60;

  @override
  void initState() {
    super.initState();
    for(int i = 0; i < 6; i++){
      _focusNode.add(FocusNode());
      _controller.add(TextEditingController());
    }
    startTimer();
  }
  @override
  void dispose() {
    for (var controller in _controller) {
      controller.dispose();
    }
    for (var focusNode in _focusNode) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (timeDuration > 0) {
          timeDuration--;
        } else {
          timeDuration = 60;
        }
      });
    });
  }
  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

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
              margin: const EdgeInsets.symmetric(vertical: 40,horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(flex: 2),
                        Text("Verifying your number",style: GoogleFonts.getFont('Roboto',color: Colors.white, fontSize: 20,fontWeight: FontWeight.w600),),
                        const Spacer(),
                        const Icon(Icons.more_vert_outlined,color: Color(0xff8596a0),)
                      ],
                    ),
                  ),
                  Text.rich(textAlign: TextAlign.center,TextSpan(
                      text: 'Waiting to automatically detect an SMS sent to ',
                      style: textStyle1,
                      children: [
                        TextSpan(text: '+91 ${widget.number}. ',style: textStyle5),
                        TextSpan(text: 'Wrong number?',style: textStyle2),
                      ]
                  ))
                ],)
              ,),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 60),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(6, (index) => Container(
                    width: 15,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: TextField(
                      controller: _controller[index],
                      focusNode: _focusNode[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      onChanged: (value){
                        if(value.isNotEmpty && index < 5){
                          _focusNode[index + 1].requestFocus();
                        }else if(value.isEmpty && index > 0){
                          _focusNode[index - 1].requestFocus();
                        }

                        if(index == 5 && value.isNotEmpty){
                          print('Entered OTP: ${_controller.map((controller) => controller.text).join()}');
                          _verifyOTP();
                        }
                      },
                      cursorColor: const Color(0xff0aa382),
                      showCursor: false,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        counterText: "",
                        hintText: '-',
                        hintStyle: TextStyle(color: Color(0xff0aa382),fontSize: 24,fontWeight: FontWeight.w600),
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                      ),
                    ),
                  )),
                ),
                Container(
                    decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: Color(0xff189d81),width: 3))
                    ),
                    margin: const EdgeInsets.only(bottom: 16),
                    width: width * 0.5,
                    ),
                const Text("Enter 6-digit code",style: TextStyle(color: AppColors.fontColor1),),
                const SizedBox(height: 6,),
                const Text("Didn't receive code?",style: TextStyle(color: AppColors.fontColor1,fontWeight: FontWeight.w600,fontSize: 16),),
                Text("You may request a new code in ${formatTime(timeDuration)}",style: const TextStyle(color: AppColors.fontColor1),),
              ],),
            ),
            const Spacer(),
          ]),
    );
  }
  void _showVerifyDialog(context){
    showDialog(context: context,
        builder: (context){
      return const AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        backgroundColor: AppColors.dialogBGColor,
        contentPadding: EdgeInsets.all(12.0), // Set content padding
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(Icons.check_circle_outline_rounded,color: AppColors.fontColor1,size: 50,),
            Text("Verification complete",style: TextStyle(color: AppColors.fontColor1,fontSize: 14),)
          ],
        ),
      );
        });

  }
  Future<void> _verifyOTP() async{

    String enteredOTP = _controller.map((controller) => controller.text).join();
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: enteredOTP,
    );
    try{
      await _auth.signInWithCredential(credential);
      print('Verification successful: ${_auth.currentUser?.uid}');
      _showVerifyDialog(context);
      sendUserInfoToNode();


    }catch(e){
      print('Verification failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error verifying OTP. Please try again.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void sendUserInfoToNode() async{

    // String nodeJSEndpointUser = '$uri/storeUser';
    String uid = _auth.currentUser?.uid ?? '';
    String phoneNum = widget.number;
    //
    // Map<String, String> userInfo = {
    //   'uid': uid,
    //   'phoneNum': phoneNum,
    // };
    // try{
    //   Dio dio = Dio();
    //
    //   Response response = await dio.post(nodeJSEndpointUser, data: userInfo);
    //   print('User information sent to Node js');
    //   print('Server response: ${response.data}');
    // }catch(e){
    //   print('Error sending user information: $e');
    // }
    Future.delayed( const Duration(seconds: 2),(){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  ProfileInfoScreen(uid: uid, phoneNum: phoneNum,)),
      );
    });  }

}

