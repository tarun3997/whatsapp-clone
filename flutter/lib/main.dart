import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/screens/home_screen.dart'; // Import your HomeScreen widget
import 'package:whatsapp/screens/login_screens/welcome_screen.dart';
import 'package:whatsapp/utils/Helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyCw576ZqWPfX58evRSC6Xt0qh9wv7x9dUI',
          appId: '1:979681065971:android:3e5c5dd3813ca386b4b086',
          messagingSenderId: '979681065971',
          projectId: 'whatsapp-9c01f')
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyAppWrapper(),
    );
  }
}

class MyAppWrapper extends StatefulWidget {
  const MyAppWrapper({Key? key}) : super(key: key);

  @override
  State<MyAppWrapper> createState() => _MyAppWrapperState();
}

class _MyAppWrapperState extends State<MyAppWrapper> {
  User? user;
  late String userToken = '';
  @override
  void initState() {
    super.initState();
    checkUserLoginStatus();
  }

  void checkUserLoginStatus()async {
    String? token = await Helper().getToken();
    // print('token $token');
    setState(() {
      user = FirebaseAuth.instance.currentUser;
      userToken = token ?? '';
    });

  }


  @override
  Widget build(BuildContext context) {
    if (userToken.isEmpty) {
      // User is not logged in
      return WelcomeScreen();
    } else {
      // User is logged in
      return const HomeScreen();
    }
  }
}
