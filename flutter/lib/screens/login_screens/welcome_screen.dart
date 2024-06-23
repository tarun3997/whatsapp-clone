import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whatsapp/screens/login_screens/enter_number_screen.dart';
import 'package:whatsapp/themes/colors.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  final TextStyle textStyle1 = GoogleFonts.getFont('Roboto',color: const Color(0xff81919A));
  final TextStyle textStyle2 = GoogleFonts.getFont('Roboto',color: const Color(0xff56ACD1),fontSize: 13,fontWeight: FontWeight.w500);
  final TextStyle textStyle3 = GoogleFonts.getFont('Roboto',color: const Color(0xff000000),fontSize: 16,fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.darkBGColor,
      body:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
        const CircleAvatar(
          radius: 150,
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage('assets/images/welcome-screen.png'),
        ),
            Container(
              margin: const EdgeInsets.only(top: 40,left: 45,right: 45),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text("Welcome to WhatsApp",style: GoogleFonts.getFont('Roboto',color: Colors.white, fontSize: 22,fontWeight: FontWeight.w600),),
                ),
                Text.rich(textAlign: TextAlign.center,TextSpan(
                  text: 'Read our ',
                  style: textStyle1,
                  children: [
                    TextSpan(text: 'Privacy Policy.',style: textStyle2),
                    TextSpan(text: 'Tap "Agree and continue" to accept the ',style: textStyle1),
                    TextSpan(text: 'Terms of Service.',style: textStyle2),
                  ]
                ))
              ],)
              ,),
            const Spacer(),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => EnterNumberScreen()));
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 14),
                width: width,
                height: 50,
                decoration: BoxDecoration(
                    color: const Color(0xff00a884),
                  borderRadius: BorderRadius.circular(50)
                ),
                child: Center(child: Text("Agree and continue",style: textStyle3,)),
              ),
            )

          ]),
    );
  }
}
