import 'package:flutter/material.dart';
import 'Login/Login.dart';
import 'HomePages/Options.dart';

void main(){
  runApp(new MaterialApp(
    title:"Traveller",
    home: new login_page(),
    debugShowCheckedModeBanner: false,
  ));
}