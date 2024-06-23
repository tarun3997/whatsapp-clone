import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioRecorder{
  late FlutterSoundRecorder recorder;
  bool isRecorderReady = false;
  String audioPath = "";

  Future<void> record() async{
    if(!isRecorderReady) return;
    final DateTime now = DateTime.now();
    final String formattedDate = DateFormat('yyyyMMdd_HHmmss').format(now);
    final String audioFileName = 'audio_$formattedDate.aac'; // Example file name format: audio_20240505_120000.aac
    await recorder.startRecorder(toFile: audioFileName);
  }
  Future<void> stop() async {
    if (!isRecorderReady) return;
    // final path = await recorder.stopRecorder();
    String? path = await recorder.stopRecorder();
    print('file path is $path');

  }
  Future initRecorder() async{
    final status = await Permission.microphone.request();
    if(status != PermissionStatus.granted){
      throw 'Microphone permission not granted';
    }
    recorder = FlutterSoundRecorder();

    await recorder.openRecorder();
    isRecorderReady = true;
    recorder.setSubscriptionDuration(
        const Duration(milliseconds: 500)
    );
  }

}