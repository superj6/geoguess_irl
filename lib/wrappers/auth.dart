import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/home.dart';
import '../screens/auth_home.dart';
import '../services/auth.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = context.watch<UserProvider>().currentUser;
    print(user);

    if(user == null){
      //see if user in storage
    }
  
    if (user != null) return HomeScreen();
    return AuthHomeScreen();
  }
}
