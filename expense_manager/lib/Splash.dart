import 'dart:async';
import 'package:expense_manager/login/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'fireauth.dart';
import 'package:expense_manager/home.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}
enum LoginStatus{
  NotDetermined,
  LoggedIn,
  NotLoggedIn
}
class _SplashPageState extends State<SplashPage> {
  LoginStatus status=LoginStatus.NotDetermined;
  User curr=null;
  @override

  void initState() {
    fireauth _fire=fireauth();
    Future.delayed(const Duration(seconds: 3), () {
      _fire.Current().then((current)
      {
        setState(() {
          status=current==null?LoginStatus.NotLoggedIn:LoginStatus.LoggedIn;
          curr=current;
        });
      });});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch(status)
    {
      case LoginStatus.NotDetermined:
        {
          return Scaffold(
              body: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          'Welcome to Settle: Never miss a payment',
                        )
                    ),

                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 50.0, left: 10.0, right: 10.0, top:20.0),
                        child:
                        SpinKitRipple(color: Colors.blue),

                      ),
                    )
                  ],
                ),
              )
          );
        }
      case LoginStatus.LoggedIn:
        {
          return HomeScreen(curr: null,);
        }
      case LoginStatus.NotLoggedIn:
        {
          return LoginScreen();
        }
    }
  }
}




















