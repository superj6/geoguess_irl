import 'package:flutter/material.dart';

class AuthInputDecoration extends InputDecoration{
  AuthInputDecoration({String? hintText, IconData? iconData}) : super(
    hintText: hintText,
    filled: true,
    fillColor: Colors.blueGrey.shade900,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blueGrey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue.shade700),
    ),
    prefixIcon: Icon(
      iconData,
      color: Colors.blueGrey.shade300,
    ),
  );
}
