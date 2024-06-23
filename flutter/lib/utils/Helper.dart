import 'package:shared_preferences/shared_preferences.dart';

class Helper {
  static const String _tokenKey = 'token';

  Future<void> setToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
    } catch (e) {
      print('Failed to set token: $e');
    }
  }

  Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    } catch (e) {
      print('Failed to get token: $e');
      return null;
    }
  }
}
