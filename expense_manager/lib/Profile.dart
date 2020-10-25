

import 'package:expense_manager/fireauth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';


class Profile extends StatefulWidget {
  final User curr;
  Profile({this.curr});


  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User curr;
  final _fire=fireauth();
  @override
  void initState() {
    curr=widget.curr;
    super.initState();
  }

  Widget build(BuildContext context) {
  //= curr.email==null?'John Appleseed':curr?.email;
  FirebaseAuth auth = FirebaseAuth.instance;
    String s=auth.currentUser?.displayName;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
        Center(
          child: Text(
            "Welcome to your profile, $s.",   //+ curr?.displayName==null?'John Appleseed':curr?.displayName,

          ),
        ),
          Container(
            child: Center(
               child: FlatButton(
                 color: Colors.blue,
                 textColor: Colors.white,
                 disabledColor: Colors.grey,
                 disabledTextColor: Colors.black,
                 padding: EdgeInsets.all(8.0),
                 splashColor: Colors.blueAccent,
                  onPressed: () {
                    _fire.out();
                    Phoenix.rebirth(context);
                  },
                  child: Text(
                    "Sign Out",
                  ),
                )            )
          )

    ],


    ),
    );

  }
}
