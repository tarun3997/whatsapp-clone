import 'package:dio/dio.dart';
import 'package:whatsapp/server/server-url.dart';
import 'package:whatsapp/utils/Helper.dart';

import '../../models/user_list_model.dart';

Future<List<Users>> getAllUsers() async {
  try {
    String? token = await Helper().getToken();
    print(token);
    final Dio dio = Dio();
    final response = await dio.get('$uri/user/api/user-list',
    options: Options(
      headers: {
        'authToken': '$token'
      }
    ));
    if (response.statusCode == 200) {
      final List<dynamic> userDataList = response.data;
      final List<Users> users = userDataList.map((userData) => Users.fromJson(userData)).toList();

      return users;
    } else {
      throw Exception('Failed to fetch data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Errors: $e');
  }
}

Future<List<Users>> getChatUserList() async {
  try{
    String? token = await Helper().getToken();
    final Dio dio = Dio();
    final response = await dio.get('$uri/user/api/chat-user-list',
        options: Options(
            headers: {
              'authToken': '$token'
            }
        ));
    if (response.statusCode == 200) {
      final List<dynamic> userDataList = response.data;
      final List<Users> users = userDataList.map((userData) => Users.fromJson(userData)).toList();

      return users;
    } else {
      throw Exception('Failed to fetch data. Status code: ${response.statusCode}');
    }
  }catch(e){
    throw Exception('Errors: $e');
  }
}
