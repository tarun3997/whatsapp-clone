import 'package:flutter/material.dart';
import 'package:whatsapp/utils/formatTime.dart';

class AudioFileWidget extends StatelessWidget {
  final isPlaying;
  final audioPlayer;
  final duration;
  final position;
  const AudioFileWidget({super.key, this.isPlaying, this.audioPlayer, this.duration, this.position});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width/1.2,
        child: Card(

          color: const Color(0xff005d4b),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Stack(children:
                [
                  CircleAvatar( radius: 24,),
                  Positioned(
                      right: -5,
                      bottom: 0,
                      child: Icon(Icons.mic, color: Color(0xff92c1b9),))
                ]),
                GestureDetector(onTap: () async{
                  if(isPlaying){
                    await audioPlayer.pause();
                  }else{
                    await audioPlayer.resume();
                  }
                }
                    ,child: isPlaying ?
                    const Icon(Icons.pause, size: 36, color: Color(0xff92c1b9),) :
                    const Icon(Icons.play_arrow_rounded, size: 36, color: Color(0xff92c1b9),)
                ),
                Stack(
                  children: [
                    Slider(
                        min: 0,
                        max: duration.inSeconds.toDouble(),
                        value: position.inSeconds.toDouble(),
                        onChanged: (value) async{
                          final position = Duration(seconds: value.toInt());
                          await audioPlayer.seek(position);

                          await audioPlayer.resume();
                        }),
                    Positioned(
                        bottom: -2,
                        left: 20,
                        child: Text(formatTime(position), style: const TextStyle(color: Color(0xff92c1b9),fontSize: 11))),
                    const Positioned(
                        bottom: -2,
                        right: 20,
                        child: Text('12:19 PM', style: TextStyle(color: Color(0xff92c1b9),fontSize: 11))),

                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
