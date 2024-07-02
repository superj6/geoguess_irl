import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import './url.dart';

class User {
  final String username;
  final String sessionCookie;

  User({required this.username, required this.sessionCookie});

  User.fromJson(Map<String, dynamic> json) 
      : username = json['username'], 
        sessionCookie = json['sessionCookie'];

  Map<String, dynamic> toJson() => {
        'username': username,
        'sessionCookie': sessionCookie,
      };
}

class UserProvider extends ChangeNotifier {
  User? _currentUser;
  final _storage = const FlutterSecureStorage();

  User? get currentUser => _currentUser;

  void setCurrentUser(User newUser) {
    _currentUser = newUser;
    _storage.write(key: "currentUser", value: jsonEncode(_currentUser!.toJson()));
    notifyListeners();
  }

  void removeCurrentUser() {
    _currentUser = null;
    _storage.delete(key: 'currentUser');
    notifyListeners();
  }

  void getUserFromStorage(){
    _storage.read(key: 'currentUser').then((user){
      print(user);
      if(user != null){
         _currentUser = User.fromJson(jsonDecode(user));
         notifyListeners();
      }
    });
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
      throw Exception('invalid login, wrong user/pass');
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
      throw Exception('invalid register, dup user');
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

    if(response.statusCode != 200){
      print('invalid logout');
    }

    removeCurrentUser();
  }
}
