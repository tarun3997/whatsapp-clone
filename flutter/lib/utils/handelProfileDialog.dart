import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../screens/main_screen/chat_screen.dart';
import '../themes/colors.dart';
import '../themes/textstyle.dart';

class ProfileDialog{
  void showProfileDialog(BuildContext context, String imageUrl, String name,id){
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero
        ),
        contentPadding: const EdgeInsets.all(0),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 6,vertical: 0),
        backgroundColor: AppColors.dialogBGColor,

        content: GestureDetector(onTap: (){
          Navigator.of(context).push(MaterialPageRoute<void>(builder: (context){
            return Scaffold(
              appBar: AppBar(
                title: Text(name,style: CustomTextStyle.textStyle8,),
                backgroundColor: Colors.black,
                iconTheme: const IconThemeData(color: Colors.white),
                elevation: 0.0,
                bottomOpacity: 0.0,
              ),
              body: Container(
                color: Colors.black,
                child: PhotoView(
                  imageProvider: CachedNetworkImageProvider(imageUrl),
                  minScale: PhotoViewComputedScale.contained * 0.8,
                  maxScale: PhotoViewComputedScale.covered * 2,
                  backgroundDecoration: const BoxDecoration(
                    color: Colors.black,
                  ),
                ),
              ),
            );
          }));
        },
          child: Stack(
            children: [

              CachedNetworkImage(
                imageUrl: imageUrl,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height* 0.36,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,

              ),
              Container(
                padding: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3)
                ),
                child: Text(name,style: CustomTextStyle.textStyle9,),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(userName: name, imageUrl: imageUrl,receiverId: id,)));
          }, icon: const Icon(Icons.message,size: 26,color: AppColors.greenCircle)),
          IconButton(onPressed: (){}, icon: const Icon(Icons.call,size: 26,color: AppColors.greenCircle)),
          IconButton(onPressed: (){}, icon: const Icon(Icons.videocam_rounded,size: 26,color: AppColors.greenCircle)),
          IconButton(onPressed: (){}, icon: const Icon(Icons.info_outline_rounded,size: 26,color: AppColors.greenCircle,)),
        ],
        actionsAlignment: MainAxisAlignment.spaceBetween,
      );
    });
  }
}