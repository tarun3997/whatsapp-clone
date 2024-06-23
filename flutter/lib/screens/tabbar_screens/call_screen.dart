import 'package:flutter/material.dart';
import 'package:whatsapp/themes/colors.dart';
import 'package:whatsapp/themes/textstyle.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({super.key});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  bool isHaveContacts = false;
  @override
  Widget build(BuildContext context) {
    return  isHaveContacts ? haveWhatsappContacts() : noWhatsappContacts();
  }
  Widget noWhatsappContacts(){
    return Column(
      children: [
        GestureDetector(onTap: (){
          setState(() {
            isHaveContacts = !isHaveContacts;
          });
        },
          child: Padding(
            padding: const EdgeInsets.symmetric( vertical: 16),
            child: ListTile(
              leading: const CircleAvatar(radius: 30,
                backgroundColor: AppColors.greenCircle,
                child: Icon(Icons.link,size: 30,color: Colors.black,),
              ),
              title: const Text("Create call link"),
              subtitle: const Text("Share a link for your WhatsApp call"),
              titleTextStyle: CustomTextStyle.textStyle1,
              subtitleTextStyle: CustomTextStyle.textStyle2,
            ),
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text("To start calling contacts who have WhatsApp, tap 📞 at the bottom of your screen.",style: CustomTextStyle.textStyle3,
            textAlign: TextAlign.center,),
        ),
        const Spacer()
      ],
    );
  }
  Widget haveWhatsappContacts(){
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(onTap: (){
            setState(() {
              isHaveContacts = !isHaveContacts;
            });
          },
            child: Padding(
              padding: const EdgeInsets.symmetric( vertical: 16),
              child: ListTile(
                leading: const CircleAvatar(radius: 30,
                  backgroundColor: AppColors.greenCircle,
                  child: Icon(Icons.link,size: 30,color: Colors.black,),
                ),
                title: const Text("Create call link"),
                subtitle: const Text("Share a link for your WhatsApp call"),
                titleTextStyle: CustomTextStyle.textStyle1,
                subtitleTextStyle: CustomTextStyle.textStyle2,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text("Recent",style: CustomTextStyle.textStyle1,),
          ),
          ListView.builder(
            shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 15,
              itemBuilder: (context, index){
            return ListTile(
              leading: CircleAvatar(radius: 25),
              title: Text("Name"),
              subtitle: Text("minutes ago"),
              trailing: Icon(Icons.videocam_rounded,size: 30,color: AppColors.greenCircle,),
              titleTextStyle: CustomTextStyle.textStyle4,
              subtitleTextStyle: CustomTextStyle.textStyle5,
            );
          })
        ],
      ),
    );
  }
}

