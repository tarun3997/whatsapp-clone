import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/models/user_list_model.dart';
import 'package:whatsapp/server/getRequest/userList.dart';
import 'package:whatsapp/server/server-url.dart';
import 'package:whatsapp/themes/colors.dart';
import 'package:whatsapp/utils/handelProfileDialog.dart';

import '../../themes/textstyle.dart';

class SelectContact extends StatefulWidget {
  const SelectContact({super.key});

  @override
  State<SelectContact> createState() => _SelectContactState();
}

class _SelectContactState extends State<SelectContact> {
  late Future<List<Users>> userList;
  int totalContacts = 0;


  @override
  void initState() {
    userList = getAllUsers().then((value) {
      setState(() {
        totalContacts = value.length;
      });
      return value;
    });
    super.initState();
  }
  ProfileDialog profileDialog = ProfileDialog();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appbarBG,
        titleSpacing: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select contact',style: TextStyle(fontSize: 12,color: Colors.white, fontWeight: FontWeight.bold),),
            Text('$totalContacts contact',style: TextStyle(fontSize: 10, color: Colors.white),),
          ],
        ),
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.search_rounded, color: Colors.white,)),
          IconButton(onPressed: (){}, icon: const Icon(Icons.more_vert_outlined, color: Colors.white)),
        ],
      ),
      backgroundColor: AppColors.darkBGColor,
      body: FutureBuilder<List<Users>>(
        future: userList,
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
          print(snapshot.error);
          return Text('Error: ${snapshot.error}',style: CustomTextStyle.textStyle1);
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No users available',style: CustomTextStyle.textStyle1,);
          }else{
            final List<Users> userLists = snapshot.data!;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              margin: const EdgeInsets.only(top: 10),
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Contacts on WhatsApp", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.greenCircle),),
                  ListView.builder(
                      itemCount: userLists.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index){
                        final Users users = userLists[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.all(0),
                          leading: GestureDetector(onTap: (){
                            profileDialog.showProfileDialog(context, '$uri/uploads/${users.profileImage!}', users.name,users.id);
                          },
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: '$uri/uploads/${users.profileImage!}',
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text(users.name,style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14,color: Colors.white),),
                          subtitle: const Text('bio',style: TextStyle(fontSize: 12, color: Colors.white),),
                        );
                      })
                ],
              ),
            );
          }
        },

      ),
    );
  }
}
