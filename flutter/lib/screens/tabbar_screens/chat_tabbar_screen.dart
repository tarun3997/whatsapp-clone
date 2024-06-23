import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:whatsapp/server/getRequest/userList.dart';
import 'package:whatsapp/server/server-url.dart';
import 'package:whatsapp/themes/textstyle.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:whatsapp/utils/handelProfileDialog.dart';
import '../../models/user_list_model.dart';
import '../../themes/colors.dart';
import '../main_screen/chat_screen.dart';

class ChatTabBarScreen extends StatefulWidget {
  final List<int> selectedTileIndices;
  final Function(bool) onChatAppbarChanged;


  const ChatTabBarScreen({super.key, required this.selectedTileIndices, required this.onChatAppbarChanged});

  @override
  State<ChatTabBarScreen> createState() => _ChatTabBarScreenState();
}

class _ChatTabBarScreenState extends State<ChatTabBarScreen> {
  late Future<List<Users>> userListFuture;
  @override
  void initState() {
    userListFuture = getChatUserList();
    super.initState();
  }
  void _longPress(int index) {
    setState(() {
      if (widget.selectedTileIndices.contains(index)) {
        widget.selectedTileIndices.remove(index);
      } else {
        widget.selectedTileIndices.add(index);
      }
      if (widget.selectedTileIndices.isEmpty) {
        widget.onChatAppbarChanged(false);
      }
    });
  }
  ProfileDialog profileDialog = ProfileDialog();

  @override
  Widget build(BuildContext context ) {
    return FutureBuilder<List<Users>>(
      future: userListFuture,
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return Text('Error: ${snapshot.error}',style: CustomTextStyle.textStyle8);
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No users available',style: CustomTextStyle.textStyle8,);
        }else{
          final List<Users> userList = snapshot.data!;

          return ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                final Users users = userList[index];
                bool isSelected = widget.selectedTileIndices.contains(index);
                return ListTile(
                  onTap: () {
                    if (widget.selectedTileIndices.isNotEmpty) {
                      widget.onChatAppbarChanged(true);
                      _longPress(index);
                    } else {
                      String profileImageUrl = users.profileImage != null
                          ? '$uri/uploads/${users.profileImage!}'
                          : 'https://www.pngall.com/wp-content/uploads/12/Avatar-Profile-Vector-PNG-Pic.png';
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatScreen(userName: users.name, imageUrl: profileImageUrl,receiverId: users.id,)));
                    }
                  },
                  onLongPress: () {
                    setState(() {
                      widget.onChatAppbarChanged(true);
                      _longPress(index);
                    });
                  },
                  leading: Stack(children: [
                    if (users.profileImage != null)
                      GestureDetector(onTap: (){
                        profileDialog.showProfileDialog(context, '$uri/uploads/${users.profileImage!}', users.name, users.id);
                      },
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: '$uri/uploads/${users.profileImage!}',
                            progressIndicatorBuilder: (context, url, downloadProgress) =>
                                Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    if (users.profileImage == null)
                      GestureDetector(onTap: (){
                        profileDialog.showProfileDialog(context, 'https://www.pngall.com/wp-content/uploads/12/Avatar-Profile-Vector-PNG-Pic.png', users.name, users.id);
                      },
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: "https://www.pngall.com/wp-content/uploads/12/Avatar-Profile-Vector-PNG-Pic.png",
                            progressIndicatorBuilder: (context, url, downloadProgress) =>
                                Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                    if (isSelected)
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
                          child: const Icon(Icons.check,
                              color: Colors.white, size: 16.0),
                        ),
                      ),
                  ]),
                  title: Text(
                    users.name,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: const Text(
                    "Message",
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          '12:19 PM',
                          style: CustomTextStyle.textStyle6,
                        ),
                      ),
                      Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Color(0xff00a884)),
                        child: Center(
                            child: Text(
                              '99',
                              style: CustomTextStyle.textStyle7,
                            )),
                      )
                    ],
                  ),
                  titleTextStyle: CustomTextStyle.textStyle4,
                  subtitleTextStyle: CustomTextStyle.textStyle5,
                );
              });
        }
      },
    );
  }
}
