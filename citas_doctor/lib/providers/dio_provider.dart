import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioProvider {
  Future<dynamic> getToken(String email, String password) async {
    try {
      var response = await Dio().post('http://127.0.0.1:8000/api/login',
          data: {'email': email, 'password': password});
      if (response.statusCode == 200 && response.data != '') {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response.data);
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return error;
    }
  }
}
