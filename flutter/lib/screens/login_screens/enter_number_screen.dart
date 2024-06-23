import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whatsapp/screens/login_screens/services/phone_auth.dart';
import 'package:whatsapp/screens/login_screens/verifying_screen.dart';
import 'package:whatsapp/themes/colors.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class EnterNumberScreen extends StatefulWidget {
  const EnterNumberScreen({super.key});

  @override
  State<EnterNumberScreen> createState() => _EnterNumberScreenState();
}

class _EnterNumberScreenState extends State<EnterNumberScreen> {
  final TextStyle textStyle1 = GoogleFonts.getFont('Roboto',color: const Color(0xffffffff),fontSize: 15);
  final TextStyle textStyle2 = GoogleFonts.getFont('Roboto',color: const Color(0xff56ACD1),fontSize: 15,fontWeight: FontWeight.w500);
  final TextStyle textStyle3 = GoogleFonts.getFont('Roboto',color: const Color(0xff000000),fontSize: 16,fontWeight: FontWeight.w600);
  final TextStyle textStyle4 = const TextStyle(color: Color(0xff0b9d7e));

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _verifiactionId = '';

  Future<void> _verifyPhone(mobileNumber) async{
    await _auth.verifyPhoneNumber(
      phoneNumber: '$mobileNumber',
        verificationCompleted: (PhoneAuthCredential credential) async{
          await _auth.signInWithCredential(credential);
          print('Verification Done ${_auth.currentUser?.uid}');
        },
        verificationFailed: (FirebaseAuthException e){
        if(e.code == 'invalid-phone-number'){
          const SnackBar(content: Text('The provide phone number is not valid.'),);
        }else{
          const SnackBar(content: Text("Something went wrong"),);
        }
          print("Verification failed $e");
        },
        codeSent: (String verificationId, int? resendToken){
          setState(() {
            _verifiactionId = verificationId;
            print("Verification ID: $_verifiactionId");

          });
        },
        codeAutoRetrievalTimeout: (String verificationId){
          setState(() {
            _verifiactionId = verificationId;
          });
        },
        timeout: const Duration(seconds: 60),
        );
    print(mobileNumber);
  }



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
              margin: const EdgeInsets.symmetric(vertical: 40,horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(flex: 2),
                        Text("Enter your phone number",style: GoogleFonts.getFont('Roboto',color: Colors.white, fontSize: 20,fontWeight: FontWeight.w600),),
                        const Spacer(),
                        const Icon(Icons.more_vert_outlined,color: Color(0xff8596a0),)
                      ],
                    ),
                  ),
                  Text.rich(textAlign: TextAlign.center,TextSpan(
                      text: 'WhatsApp will need to verify your account. ',
                      style: textStyle1,
                      children: [
                        TextSpan(text: 'Whats my number?',style: textStyle2),
                      ]
                  ))
                ],)
              ,),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 60),
              child: Column(children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  width: width,
                  decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Color(0xff189d81),width: 1))
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      Center(child: Text("India",style: textStyle1,)),
                      const Spacer(),
                      const Icon(Icons.arrow_drop_down_outlined,color: Color(0xff00a884),size: 28,)
                    ],),
                ),
                FormBuilder(
                  key: formKey,
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: Color(0xff189d81),width: 1))
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(Icons.add,color: Color(0xff8595a0),size: 18,),
                            const Spacer(),
                            Center(child: Text("91",style: textStyle1,)),
                            const Spacer()
                          ],),
                      ),
                      Container(
                          margin: const EdgeInsets.only(left: 10),
                          width: width * 0.452,
                          child: FormBuilderTextField(name: 'number',
                            style: const TextStyle(color: Colors.white),
                            cursorColor: const Color(0xff8596a0),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                hintText: 'phone number',
                                hintStyle: TextStyle(color: Color(0xff8596a0),fontWeight: FontWeight.w400),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xff8596a0),width: 1.5)
                                ),
                                isDense: true,
                                contentPadding: EdgeInsets.zero
                            ),
                            inputFormatters: [LengthLimitingTextInputFormatter(10)],
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(errorText: 'Please Enter Number'),
                              FormBuilderValidators.minLength(10,errorText: 'Enter full number')
                            ]),
                          ))
                    ],
                  ),
                )
              ],),
            ),
            const Spacer(),
            GestureDetector(
              onTap: (){
                if(formKey.currentState?.saveAndValidate() ?? false){
                  final number = formKey.currentState?.fields['number']?.value;
                  print(number);
                  _showCustomPopup(context, number);
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
  void _showCustomPopup(BuildContext context, String? phoneNumber) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero
          ),
          backgroundColor: AppColors.dialogBGColor,
          title: const Text('Is this the correct number?',style: TextStyle(color: Color(0xff80919c),fontSize: 14),),
          content: Text('+91$phoneNumber',style: const TextStyle(color: Colors.white, fontSize: 20),),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the popup
              },
              child: Text('Edit',style: textStyle4,),
            ),
            TextButton(
              onPressed: () {
                FirebasePhoneAuth().verifyPhoneNumber(context: context,  phoneNum: '+91$phoneNumber');
              },
              child: Text('Yes',style: textStyle4,),
            ),
          ],
        );
      },
    );
  }
}

