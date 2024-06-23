import 'package:dio/dio.dart';
import 'package:whatsapp/models/message_model.dart';
import 'package:whatsapp/server/server-url.dart';
import 'package:whatsapp/utils/Helper.dart';

Future<List<Message>> getUserMessages() async{
  try{
    String? token = await Helper().getToken();
    final Dio dio = Dio();
    final response = await dio.get('$uri/message/user-messages',
    options: Options(
      headers: {
        'authToken': '$token'
      }
    ));
    if(response.statusCode == 200){
      final List<dynamic> userMessageList = response.data;
      final List<Message> message = userMessageList.map((e) => Message.fromJson(e)).toList();
      return message;
    }else {
      throw Exception('Failed to fetch data. Status code: ${response.statusCode}');
    }
  }catch(e){
    throw Exception('Errors in messages: $e');
  }
}