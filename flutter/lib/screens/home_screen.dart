import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp/screens/floating_button_screen/select_contact.dart';
import 'package:whatsapp/screens/login_screens/services/logout.dart';
import 'package:whatsapp/screens/main_screen/setting_screen.dart';
import 'package:whatsapp/screens/tabbar_screens/call_screen.dart';
import 'package:whatsapp/screens/tabbar_screens/chat_tabbar_screen.dart';
import 'package:whatsapp/screens/tabbar_screens/status_screen.dart';
import 'package:whatsapp/server/server-url.dart';
import 'package:whatsapp/themes/colors.dart';
import 'package:whatsapp/themes/textstyle.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
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
  late TabController tabController;
  int currentTabIndex = 1;
  bool _isSelected = false;
  List<int> selectedTileIndices = [];
  int selectedTabsCount = 0;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this, initialIndex: 1);
    tabController.addListener(() {
      setState(() {
        currentTabIndex = tabController.index;
      });
    });
    super.initState();
  }

  bool _isChatAppbar = false;

  late File _image;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: AppColors.darkBGColor,
      body: TabBarView(
        controller: tabController,
        children: [
          const Tab(
            child: Center(
              child: Text('Community',style: CustomTextStyle.textStyle1,),
            ),
          ),
          Tab(
            child: ChatTabBarScreen(onChatAppbarChanged: (bool isChatAppbar){
              setState(() {
                _isChatAppbar = isChatAppbar;
              });
            }, selectedTileIndices: selectedTileIndices, ),
          ),
          const Tab(
            child: StatusScreen(),
          ),
          const Tab(
            child: CallScreen()
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(currentTabIndex),
    );
  }

  PreferredSizeWidget? _appBar() {
    if (_isChatAppbar) {
      return _chatSelectedAppBar();
    } else {
      return AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.appbarBG,
        title: Text(
          "WhatsApp",
          style: textStyle2,
        ),
        actions: [
          IconButton(
              onPressed: () {
                statusCamera(ImageSource.camera);
              },
              icon: const Icon(
                Icons.camera_alt_outlined,
                color: AppColors.fontColor1,
                size: 26,
              )),
          IconButton(
              onPressed: () {
                _auth.signOut();
              },
              icon: const Icon(
                Icons.search_rounded,
                color: AppColors.fontColor1,
                size: 26,
              )),
          // IconButton(onPressed: (){},
          //     icon: const Icon(Icons.more_vert_outlined,color: AppColors.fontColor1,size: 26,)),
          PopupMenuButton(
              icon: const Icon(
                Icons.more_vert_outlined,
                color: AppColors.fontColor1,
                size: 26,
              ),
              color: AppColors.appbarBG,
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    value: 'newGroup',
                    child: Text('New group', style: textStyle01),
                  ),
                  PopupMenuItem(
                    value: 'newGroup',
                    child: Text(
                      'New broadcast',
                      style: textStyle01,
                    ),
                  ),
                  PopupMenuItem(
                    value: 'linkedDevices',
                    child: Text('Linked devices', style: textStyle01),
                  ),
                  PopupMenuItem(
                    value: 'starredMessages',
                    child: Text('Starred messages', style: textStyle01),
                  ),
                  PopupMenuItem(
                    value: 'payments',
                    child: Text('Payments', style: textStyle01),
                    onTap: ()=> deviceLogout(context: context),
                  ),
                  PopupMenuItem(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingScreen()));
                    },
                    value: 'settings',
                    child: Text('Settings', style: textStyle01),
                  ),
                ];
              })
        ],
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(
              icon: Icon(
                Icons.groups_rounded,
                size: 30,
              ),
            ),
            Tab(
              text: "Chats",
            ),
            Tab(
              text: "Updates",
            ),
            Tab(
              text: "Calls",
            ),
          ],
          indicatorSize:
          TabBarIndicatorSize.tab, // Set indicator size to fit the tab
          indicator: UnderlineTabIndicator(
              borderSide: const BorderSide(width: 3, color: Color(0xff00a783)),
              borderRadius:
              BorderRadius.circular(10) // Set indicator width and color
          ),
          dividerColor: Colors.transparent,
          isScrollable: true,
          tabAlignment: TabAlignment.center,
          // labelPadding: EdgeInsets.symmetric(horizontal: 22),
          labelStyle: textStyle3,
          labelColor: const Color(0xff00a783),
          unselectedLabelColor: const Color(0xff8596a0),
        ),
      );
    }
  }

  Future<void> getPermission() async{
    final permission = await Permission.location.request();
    if(permission == PermissionStatus.granted){
      print("Allow");
    }else if(permission == PermissionStatus.denied){
      print("Denied");
    }else if(permission == PermissionStatus.permanentlyDenied){
      openAppSettings();
    }
  }
  Future<void> statusCamera(ImageSource source) async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }
  Future<void> _uploadImage()async{
    try{
      final dio = Dio();

      final formData = FormData.fromMap({
        'profileImage': await MultipartFile.fromFile(_image.path),
      });
      final response = await dio.post('$uri/upload',
          data: formData);
      if (response.statusCode == 200) {
        print('Image uploaded successfully');
      } else {
        print('Failed to upload image. Status code: ${response.statusCode}');
      }
    }catch(e){
      print('Error uploading image: $e');
    }

  }
  Widget _buildFloatingActionButton(int tabIndex) {
    if (tabIndex == 2) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            mini: true,
            onPressed: () {
              print('First Floating button pressed on tab 2');
            },
            backgroundColor: const Color(
              0xff3C4A55,
            ),
            child: const Icon(Icons.edit, color: Color(0xffCACFD5)),
          ),
          const SizedBox(
            height: 14,
          ),
          FloatingActionButton(
            onPressed: () {
              print('Second Floating button pressed on tab 2');
            },
            backgroundColor: const Color(0xff00a88a),
            child: const Icon(Icons.camera, color: AppColors.darkBGColor),
          ),
        ],
      );
    }else if(tabIndex == 1){
      return FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const SelectContact()));
        },
        backgroundColor: const Color(0xff00a88a),
        child: const Icon(Icons.message, color: AppColors.darkBGColor),
      );
    } else if (tabIndex != 0) {
      IconData iconData;
      switch (tabIndex) {
        case 3:
          iconData = Icons.call;
          break;
        default:
          iconData = Icons.add;
      }

      // Show a single floating action button for other tabs
      return FloatingActionButton(
        onPressed: () {
          // Handle button press for the specific tab
          print('Floating button pressed on tab $tabIndex');
          getPermission();
        },
        backgroundColor: const Color(0xff00a88a),
        child: Icon(iconData, color: AppColors.darkBGColor),
      );
    } else {
      return Container();
    }
  }
  PreferredSizeWidget _chatSelectedAppBar() {
    return AppBar(
        leading: IconButton(
          onPressed: () {
            setState(() {
              _isChatAppbar = false;
              _isSelected = !_isSelected;
              selectedTileIndices.clear();
            });
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.appbarBG,
        title: Text(
          '${selectedTileIndices.length}',
          style: GoogleFonts.getFont('Roboto',
              color: const Color(0xffffffff),
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.push_pin_rounded,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.delete_rounded,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.volume_off_rounded,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.archive,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert_outlined,
                color: Colors.white,
              )),
        ],
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(
              icon: Icon(
                Icons.groups_rounded,
                size: 30,
              ),
            ),
            Tab(
              text: "Chats",
            ),
            Tab(
              text: "Updates",
            ),
            Tab(
              text: "Calls",
            ),
          ],
          indicatorSize:
              TabBarIndicatorSize.tab, // Set indicator size to fit the tab
          indicator: UnderlineTabIndicator(
              borderSide: const BorderSide(width: 3, color: Color(0xff00a783)),
              borderRadius:
                  BorderRadius.circular(10) // Set indicator width and color
              ),
          dividerColor: Colors.transparent,
          isScrollable: true,
          tabAlignment: TabAlignment.center,
          // labelPadding: EdgeInsets.symmetric(horizontal: 22),
          labelStyle: textStyle3,
          labelColor: const Color(0xff00a783),
          unselectedLabelColor: const Color(0xff8596a0),
        ));
  }
}
