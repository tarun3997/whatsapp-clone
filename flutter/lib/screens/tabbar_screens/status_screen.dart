import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whatsapp/themes/textstyle.dart';
import 'package:whatsapp/widget/button_widget.dart';

import '../../themes/colors.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  final TextStyle textStyle1 = GoogleFonts.getFont('Roboto',
      color: const Color(0xffffffff), fontSize: 15);
  final TextStyle textStyle01 = GoogleFonts.getFont('Roboto',
      color: const Color(0xffffffff),
      fontSize: 15,
      fontWeight: FontWeight.w600);
  final TextStyle textStyle2 = GoogleFonts.getFont('Roboto',
      color: const Color(0xff8596a0),
      fontSize: 22,
      fontWeight: FontWeight.w600);
  final TextStyle textStyle3 =
  GoogleFonts.getFont('Roboto', fontSize: 18, fontWeight: FontWeight.w600);
  final TextStyle textStyle4 =
  GoogleFonts.getFont('Roboto', color: Colors.black);
  final TextStyle textStyle5 =
  GoogleFonts.getFont('Roboto', fontSize: 12, color: AppColors.fontColor1);
  final TextStyle textStyle6 =
  GoogleFonts.getFont('Roboto', fontSize: 14, color: AppColors.fontColor1);
  bool isTileVisible = true;
  bool isContactsToSeeStatus = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Status",
                style: CustomTextStyle.textStyle1,
              ),
              Icon(
                Icons.more_vert_outlined,
                size: 26,
                color: AppColors.fontColor1,
              )
            ],
          ),
        ),
        if(isTileVisible)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ListTile(
              tileColor: const Color(0xff26343d),
              leading: const CircleAvatar(backgroundColor: Color(0xff008069),radius: 23),
              title: RichText(
                text: const TextSpan(
                    style: TextStyle(color: AppColors.primary,fontSize: 17,fontWeight: FontWeight.w400),
                    text: "Use Status to share photos, text and videos that disappear in 24 hours.",
                    children: [
                      TextSpan(
                          style: TextStyle(color: Color(0xff01a884),fontSize: 17,fontWeight: FontWeight.w500),
                          text: " Status Privacy"
                      )
                    ]
                ),
              ),
              trailing: GestureDetector(onTap: (){
                setState(() {
                  isTileVisible = false;
                });

              },
                child: const Icon(
                  Icons.close,
                  color: AppColors.fontColor1,
                ),
              ),
            ),
          ),
        isContactsToSeeStatus ?
        ListTile(
          leading: Stack(
            children: [
              GestureDetector(onTap: (){
                setState(() {
                  isContactsToSeeStatus = !isContactsToSeeStatus;
                });
              },
                child: const CircleAvatar(
                  backgroundColor: AppColors.profileCircle,
                  radius: 28,

                  child: Icon(Icons.person,color: Color(0xffcfd8df),size: 40,),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xff00a884),
                      border: Border.all(
                          color: AppColors.darkBGColor, width: 2)),
                  child: const Icon(Icons.add,
                      color: Colors.white, size: 19.0),
                ),
              ),
            ],
          ),
          title: const Text("My status",),
          subtitle: const Text("Tap to add status update"),
          titleTextStyle: const TextStyle(fontSize: 18,fontWeight: FontWeight.w500),
          subtitleTextStyle: textStyle6,
        ) : isHaveContactsToSeeStatus(),
        const Divider(thickness: 0.11,),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Channels",
                style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
              Icon(
                Icons.add,
                size: 26,
                color: AppColors.fontColor1,
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text("Stay updated on topic that matters to you. Find channels to follow below.",style: textStyle6,),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Find Channels",
                style: TextStyle(
                    color: AppColors.fontColor1,
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 26,
                color: AppColors.fontColor1,
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: defaultButton("Explore more"),
        )

      ],
    );
  }
  Widget isHaveContactsToSeeStatus(){
    return Container(
      margin: const EdgeInsets.only(left: 16,top: 10,bottom: 10),
      height: 100,
      child: ListView.builder(
          itemCount: 10,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (context, index){
            if(index == 0){
               return Container(
                 width: 70,
                 margin: const EdgeInsets.only(right: 6.0),
                 child: Column(
                   children: [
                     Stack(
                      children: [
                        GestureDetector(onTap: (){
                          setState(() {
                            isContactsToSeeStatus = !isContactsToSeeStatus;
                          });
                        },
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.profileCircle
                            ),
                            child: const Icon(Icons.person,color: Color(0xffcfd8df),size: 40,),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xff00a884),
                                border: Border.all(
                                    color: AppColors.darkBGColor, width: 2)),
                            child: const Icon(Icons.add,
                                color: Colors.white, size: 19.0),
                          ),
                        ),
                      ],
                                   ),
                     Padding(
                       padding: const EdgeInsets.only(top: 4.0),
                       child: Text("My status",style: textStyle1,overflow: TextOverflow.ellipsis,),
                     )
                   ],
                 ),
               );
            }else {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),

                width: 70,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 2,color: Color(0xff23a763))
                      ),
                      child: Container(
                        width: 68,
                        height: 68,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.profileCircle
                        ),
                      ),
                    ),
                    Text("Name",style: textStyle1,overflow: TextOverflow.ellipsis,)

                  ],
                ),
              );
            }
      }),
    );
  }
}
