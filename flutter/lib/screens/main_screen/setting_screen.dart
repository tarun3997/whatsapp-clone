import 'package:flutter/material.dart';
import 'package:whatsapp/themes/colors.dart';
import 'package:whatsapp/themes/textstyle.dart';
import 'package:whatsapp/widget/similar_listtile_widget.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings",style: CustomTextStyle.textStyle10,),
        backgroundColor: AppColors.appbarBG,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 1,
        actions: [
          IconButton(onPressed: (){}, icon: const Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Icon(Icons.search_rounded,size: 28,),
          ))],
      ),
      backgroundColor: AppColors.darkBGColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white
                ),
              ),
              title: const Text("Tarun Lohar",style: CustomTextStyle.textStyle10,),
              subtitle: Text("Urgent call only",style: CustomTextStyle.textStyle5,),
              trailing: const SizedBox(
                width: 68,
                child: Row(children: [
                  Padding(
                    padding: EdgeInsets.only(right: 12.0),
                    child: Icon(Icons.qr_code,size: 28,color: AppColors.greenCircle, ),
                  ),
                  Icon(Icons.expand_circle_down_outlined,size: 28,color: AppColors.greenCircle ),
                ],),
              ),
            ),
            const Divider(thickness: 0.15,),
            customListTile(const Icon(Icons.key), 'Account ', 'Security notification, change number'),
            customListTile(const Icon(Icons.lock), 'Privacy ', 'Block contacts, disappearing messages'),
            customListTile(const Icon(Icons.emoji_emotions_sharp), 'Avatar ', 'Create, edit, profile photo'),
            customListTile(const Icon(Icons.message), 'Chats ', 'Theme, wallpapers, chat history'),
            customListTile(const Icon(Icons.notifications_rounded), 'Notification ', 'Message, group & call tones'),
            customListTile(const Icon(Icons.storage), 'Storage and data ', 'Network usage, auto-download'),
            customListTile(const Icon(Icons.key), 'App language ', "English (device's language"),
            customListTile(const Icon(Icons.key), 'Help ', 'Help center, contact us, privacy policy'),
          ],
        ),
      ),
    );
  }
}
