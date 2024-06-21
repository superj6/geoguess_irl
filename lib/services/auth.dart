import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import './url.dart';

class User {
  final String username;
  final String sessionCookie;

  User({required this.username, required this.sessionCookie});
}

class UserProvider extends ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;

  void setCurrentUser(User newUser) {
    _currentUser = newUser;
    notifyListeners();
  }

  void removeCurrentUser() {
    _currentUser = null;
    notifyListeners();
  }

  Future<void> loginUser({required String username, required String password}) async{
    final response = await http.post(
      Uri.parse('${gameUrl}/api/auth/login'),
      headers: <String, String>{
	'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
	'username': username,
        'password': password, 
      }),
    );

    if (response.statusCode == 200) {
      String sessionCookie = response.headers['set-cookie']!;
      User user = User(username: username, sessionCookie: sessionCookie);
      setCurrentUser(user);
    } else {
      print('invalid login');
    }
  }


  Future<void> registerUser({required String username, required String password}) async{
    final response = await http.post(
      Uri.parse('${gameUrl}/api/auth/register'),
      headers: <String, String>{
	'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
	'username': username,
        'password': password, 
      }),
    );

    print(response.headers);

    if (response.statusCode == 200) {
      String sessionCookie = response.headers['set-cookie']!;
      User user = User(username: username, sessionCookie: sessionCookie);
      setCurrentUser(user);
    } else {
      print('invalid register');
    }
  }


  Future<void> logoutUser() async{
    final response = await http.post(
      Uri.parse('${gameUrl}/api/auth/logout'),
      headers: <String, String>{
	'Content-Type': 'application/json; charset=UTF-8',
        'Cookie': _currentUser!.sessionCookie,
      },
    );

    if (response.statusCode == 200) {
      removeCurrentUser();
    } else {
      print('invalid logout');
    }
  }
}
