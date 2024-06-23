import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp/models/message_model.dart';
import 'package:whatsapp/server/getRequest/userMessagesList.dart';
import 'package:whatsapp/server/server-url.dart';
import 'package:whatsapp/themes/textstyle.dart';
import 'package:whatsapp/utils/Helper.dart';
import 'package:whatsapp/utils/audio/audioRecoder.dart';
import 'package:whatsapp/utils/formatTime.dart';
import 'package:audioplayers/audioplayers.dart' as audio;
import 'package:socket_io_client/socket_io_client.dart' as IO;


import '../../themes/colors.dart';

class ChatScreen extends StatefulWidget {
  final String userName;
  final String imageUrl;
  final String receiverId;
  const ChatScreen({super.key, required this.userName, required this.imageUrl, required this.receiverId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextStyle textStyle1 = GoogleFonts.getFont('Roboto',color: const Color(0xffffffff),fontSize: 15);
  final TextStyle textStyle01 = GoogleFonts.getFont('Roboto',color: const Color(0xffffffff),fontSize: 15,fontWeight: FontWeight.w600);
  final TextStyle textStyle2 = GoogleFonts.getFont('Roboto',color: AppColors.fontColor1,fontSize: 16,);
  final TextStyle textStyle3 = GoogleFonts.getFont('Roboto',fontSize: 18,fontWeight: FontWeight.w600);
  final TextStyle textStyle4 = GoogleFonts.getFont('Roboto',color: Colors.black);
  final TextStyle textStyle5 = GoogleFonts.getFont('Roboto',fontSize: 12,color: AppColors.fontColor1);
  final TextStyle textStyle6 = GoogleFonts.getFont('Roboto',fontSize: 14,color: AppColors.fontColor1);
  bool isMessaging = false;
  final _messageFocusNode = FocusNode();
  final formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _messageController = TextEditingController();
  late User? user;
  late String userId;
  late Future<List<Message>> userMessages;
  final audioPlayer = AudioPlayer();
  late AudioRecorder audioRecorder;
  late IO.Socket _socket;

  List<Message> messages = [];

  _connectSocket(){
    _socket.onConnect((data) => print('Connection established'));
    _socket.onConnectError((data) => print('Connect Error: $data'));
    _socket.onDisconnect((data) => print('Socket.IO server disconnected'));

  }
  
  _sendMessage(String text)async{
    try{
    _socket.emit('message',{
      'message': text,
      'receiverId': widget.receiverId
    });
    }catch(e){
      print(e);
    }
  }

  late String? audioFilePath;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  
  // bool isRecorderReady = false;
  void initializeSocket() async {
    String? token = await Helper().getToken();
    if (token != null) {
      _socket = IO.io(uri, IO.OptionBuilder()
          .setTransports(['websocket'])
          .setQuery({'authToken': token})
          .build());
      _connectSocket();
    }
  }

  @override
  void initState() {
    super.initState();
    initializeSocket();

    audioRecorder = AudioRecorder();
    initRecorder();
    userMessages = getUserMessages();
    user = FirebaseAuth.instance.currentUser;
    userId = user?.uid ?? '';
    setAudio();
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == audio.PlayerState.playing;
      });
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }
  Future<void> initRecorder() async {
    try {
      await audioRecorder.initRecorder();
    } catch (e) {
      print('Error initializing recorder: $e');
    }
  }
  Future<void> setAudio() async{
    // if (audioFilePath == null) return;
    audioPlayer.setReleaseMode(ReleaseMode.loop);
     // String url = 'https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3';
     // audioPlayer.setSourceUrl(url);
     // await audioPlayer.setSourceUrl(audioFilePath!);
     // await audioPlayer.setSourceAsset(audioFilePath!);
     // await audioPlayer.play(audioFilePath! as Source);
  }
  @override
  void dispose() {
    _messageFocusNode.dispose();
    audioRecorder.recorder.closeRecorder();
    audioPlayer.dispose();
    super.dispose();
  }
  final Dio dio = Dio();
  void sendMessage(String text, String receiverId) async{
    try {
      String? token = await Helper().getToken();
      await dio.post('$uri/message/send-message', data: {
        'text': text,
        'receiverId': receiverId
      },options: Options(
        headers: {
          'authToken': '$token'
        }
      ));
    }catch(e){
      throw Exception('Errors: $e');
    }
  }

  late String imageUrl = widget.imageUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBGColor,
      appBar: AppBar(
        backgroundColor: AppColors.appbarBG,

        leading: InkWell(onTap: (){
          Navigator.pop(context);
        },
          child: Row(children: [
            const Icon(Icons.arrow_back_rounded,color: Colors.white,),
            CircleAvatar(
              radius: 16,
              backgroundImage: CachedNetworkImageProvider(imageUrl),
            )
          ],),
        ),
        title: Text(widget.userName,style: textStyle1,overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(onPressed: ()async{
            await ImagePicker().pickImage(source: ImageSource.camera);
          },
              icon: const Icon(Icons.videocam,color: AppColors.primary,size: 26,)),
          IconButton(onPressed: (){},
              icon: const Icon(Icons.call_rounded,color: AppColors.primary,size: 26,)),
          PopupMenuButton(
              icon: const Icon(Icons.more_vert_outlined,color: AppColors.primary,size: 26,),
              color: AppColors.appbarBG,
              onSelected: (String value){
                if(value == 'subMenu'){
                  showSubmenu(context);
                }
              },
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    value: 'newGroup',
                    child: Text('View contact',style: textStyle01),
                  ),
                  PopupMenuItem(
                    value: 'newGroup',
                    child: Text('Media, links, and docs',style: textStyle01,),

                  ),
                  PopupMenuItem(
                    value: 'linkedDevices',
                    child: Text('Search',style: textStyle01),
                  ),
                  PopupMenuItem(
                    value: 'starredMessages',
                    child: Text('Mute notification',style: textStyle01),
                  ),
                  PopupMenuItem(
                    value: 'payments',
                    child: Text('Disappearing messages',style: textStyle01),
                  ),
                  PopupMenuItem(
                    value: 'settings',
                    child: Text('Wallpaper',style: textStyle01),
                  ),
                  PopupMenuItem(
                    value: 'subMenu',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('More',style: textStyle01),
                        const Icon(Icons.arrow_right,color: Colors.white,)
                      ],
                    ),
                  ),

                ];
              }
              )
        ],
      ),
      body: FutureBuilder<List<Message>>(
        future: userMessages,
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Text('Error: ${snapshot.error}',style: CustomTextStyle.textStyle8);
          }else{
            final List<Message> userMessages = snapshot.data!;
            _socket.on('receive_message', (data) {
              print('Received message: $data');
              // print('Received data structure: ${data.runtimeType} - $data');
              try{
                final message = Message(
                    text: data['text'],
                    sendingTime: DateTime.now(),
                    receiverId: data['receiverId'],
                    senderId: data['senderId']
                );      setState(() {
                  userMessages.add(message);
                  print('message is received');
                });
              }catch(e){
                print('error $e');
              }
            });
            // print(userMessages);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(child: GroupedListView<Message, DateTime>(
                  padding: const EdgeInsets.all(8),
                  reverse: true,
                  order: GroupedListOrder.DESC,
                  useStickyGroupSeparators: false,
                  floatingHeader: true,
                  elements: userMessages,
                  groupBy: (message) => DateTime(
                    message.sendingTime!.year,
                    message.sendingTime!.month,
                    message.sendingTime!.day,
                  ),
                  groupHeaderBuilder: (Message message) => SizedBox(

                    child: Center(child: Card(
                      color: AppColors.darkBGColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                        child: Text(DateFormat.yMMMd().format(message.sendingTime!),style: const TextStyle(color: Colors.white),),
                      ),
                    )),
                  ),
                  itemBuilder: (context, message) => Align(
                    alignment: message.receiverId == widget.receiverId ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Card(
                      color: message.receiverId == widget.receiverId ? const Color(0xff005d4b)
                          : const Color(0xff1f2c34),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(message.text!,style: textStyle1,),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(DateFormat('hh:mm a').format(message.sendingTime!),style: const TextStyle(color: Color(0xff92c1b9),fontSize: 11),),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )),

                Container(
                  margin: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  color: AppColors.darkBGColor,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,

                    children: [
                      Expanded(
                        child:FormBuilder(
                          key: formKey,
                          child: Container(
                            margin: const EdgeInsets.only(right: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(28.0), // Adjust the radius as needed
                              color: AppColors.appbarBG,
                            ),
                            child: audioRecorder.isRecorderReady
                                ? audioRecorder.recorder.isRecording ?
                            StreamBuilder<RecordingDisposition>(
                              stream: audioRecorder.recorder.onProgress,
                              builder: (context, snapshot) {
                                final duration = snapshot.hasData ? snapshot.data!.duration : Duration.zero;
                                String twoDigits(int n) => n.toString().padLeft(2, '0');
                                final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
                                final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                  child: Text('$twoDigitMinutes:$twoDigitSeconds', style: const TextStyle(color: Colors.white)),
                                );
                              },
                            )
                                : Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(onPressed: (){}, icon: const Icon(Icons.emoji_emotions,color: AppColors.fontColor1,)),
                                Expanded(
                                  child: FormBuilderTextField(
                                    name: 'message',
                                    focusNode: _messageFocusNode,
                                    controller: _messageController,
                                    maxLines: null,
                                    onChanged: (value) {
                                      setState(() {
                                        isMessaging = value!.isNotEmpty;
                                      });
                                    },
                                    onSubmitted: (text){

                                    },
                                    style: textStyle1,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Message",
                                        hintStyle: textStyle2
                                    ),
                                  ),
                                ),
                                isMessaging ? IconButton(onPressed: (){}, icon: const Icon(Icons.attach_file_rounded,color: AppColors.fontColor1,)) :
                                Row(children: [
                                  IconButton(onPressed: (){}, icon: const Icon(Icons.attach_file_rounded,color: AppColors.fontColor1,)),
                                  IconButton(onPressed: (){}, icon: const Icon(Icons.currency_rupee,color: AppColors.fontColor1,)),
                                  IconButton(onPressed: ()async{
                                    await ImagePicker().pickImage(source: ImageSource.camera);
                                  }, icon: const Icon(Icons.camera_alt,color: AppColors.fontColor1,)),
                                ]),
                              ],
                            ) : const SizedBox()
                          )
                        ),


                      ),

                      isMessaging ?
                      GestureDetector(onTap: (){
                        if(formKey.currentState!.saveAndValidate()){
                          final text = formKey.currentState!.fields['message']!.value;
                          final messages = Message(text: text, sendingTime: DateTime.now(), receiverId: widget.receiverId, senderId: 'tarun');
                          _sendMessage(text);
                          setState(() {
                            userMessages.add(messages);
                            _messageController.clear();
                          });
                          // sendMessage(text, widget.receiverId);

                        }
                      },

                        child: const CircleAvatar(
                          radius: 24,
                          backgroundColor: Color(0xff00a884),
                          child: Icon(Icons.send,color: Colors.white,),
                        ),
                      ) : GestureDetector(
                        onTapDown: (detail)async{
                          if(audioRecorder.recorder.isRecording){
                            await audioRecorder.stop();
                          }else{
                            await audioRecorder.record();
                          }
                          setState(() {

                          });
                      },

                        onTapUp: (detail)async{
                          if(audioRecorder.recorder.isRecording){
                            await audioRecorder.stop();
                          }else{
                            await audioRecorder.record();
                          }
                          setState(() {

                          });
                        },
                        onTapCancel: () async{
                          if(audioRecorder.recorder.isRecording){
                            await audioRecorder.stop();
                          }else{
                            await audioRecorder.record();
                          }
                          setState(() {

                          });
                        },
                        // onTap: ()async{
                        //   if(recorder.isRecording){
                        //     await stop();
                        //   }else{
                        //     await record();
                        //   }
                        //   setState(() {});
                        // },
                        child:  CircleAvatar(
                          radius: 24,
                          backgroundColor: const Color(0xff00a884),
                          child: audioRecorder.recorder.isRecording ? const Icon(Icons.stop, color: Colors.white) : const Icon(Icons.mic, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                )
              ],
            );
          }
        },

      ),
    );
  }
  void showSubmenu(BuildContext context) {
    showMenu(
      color: AppColors.appbarBG,
      context: context,
      position: const RelativeRect.fromLTRB(100, 100, 0, 0), // Adjust the position as needed
      items: [
        PopupMenuItem(
          value: 'report',
          child: Text('Report', style: textStyle01),
        ),
        PopupMenuItem(
          value: 'block',
          child: Text('Block', style: textStyle01),
        ),
        PopupMenuItem(
          value: 'clearChat',
          child: Text('Clear chat', style: textStyle01),
        ),
        PopupMenuItem(
          value: 'clearChat',
          child: Text('Export chat', style: textStyle01),
        ),
        PopupMenuItem(
          value: 'clearChat',
          child: Text('Add shortcut', style: textStyle01),
        ),
      ],
    );
  }}
