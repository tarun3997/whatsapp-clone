
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/screens/login_screens/welcome_screen.dart';
import 'package:whatsapp/utils/Helper.dart';

void deviceLogout({required BuildContext context})async{
  final FirebaseAuth auth = FirebaseAuth.instance;
  Helper().setToken('');
  auth.signOut();
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> WelcomeScreen()), (route) => false);
}