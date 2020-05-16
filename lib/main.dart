import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'login.dart';
void main(){

  runApp(MyApp());
}

String userId;



class MyApp extends StatefulWidget{

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool userExist = false;

  @override
  void initState(){
    super.initState();
    getUserData();
  }

  getUserData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.get('user');

    if(userId != null){
      print('LogIN');
      setState((){
        userExist = true;
      });
    }
  }

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.green,
        accentColor: Colors.blueAccent,
      ),
      home: userExist? Home(): LogIn(),

      routes: {
        '/login': (context) => LogIn(),
      },
    );
  }
}

