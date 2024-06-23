import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/screens/login_screens/verifying_screen.dart';
import 'package:whatsapp/utils/error_handel.dart';

class FirebasePhoneAuth{
Future<void>verifyPhoneNumber({required context, required phoneNum})async{
  final FirebaseAuth auth = FirebaseAuth.instance;
  try{
    await auth.verifyPhoneNumber(verificationCompleted: (PhoneAuthCredential authCredential) async{
      await auth.signInWithCredential(authCredential);
    },
        verificationFailed: ((e){
          ErrorHandler.showError(context, e);
        }), codeSent: (String verificationId, [int? forceResendingToken]){
          Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyingScreen(number: '$phoneNum', verificationId: verificationId,)));

        }, codeAutoRetrievalTimeout: (String verificationId) {},
        phoneNumber: phoneNum
    );
  }catch(e){
    ErrorHandler.showError(context, e);

  }
}
}