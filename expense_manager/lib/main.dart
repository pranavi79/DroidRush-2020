import 'dart:async';
import 'package:expense_manager/login/build.dart';
import 'package:flutter/material.dart';
void main() {
  runApp(MyApp());
}
 //Hello
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Settle',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
 
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3),()=>Navigator.pushReplacement(context,MaterialPageRoute(builder:(context) => LoginScreen())));
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
    );
  }
}