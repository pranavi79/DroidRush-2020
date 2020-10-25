import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'utilities.dart';
import 'package:expense_manager/login/loginScreen.dart';
import 'package:expense_manager/class.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expense_manager/fireauth.dart';
import 'package:expense_manager/home.dart';


Person u = Person();
String _email=u.email;
String _password=u.pass;
String _name=u.name;
String _username=u.username;
AlertDialog alertDialog=AlertDialog(
                         title: Text("Welcome"),
                         content: Text("Verification link has been sent to your email"),
                 );
class SignUpScreen extends StatefulWidget {
  @override
  SignUpScreenState createState() => SignUpScreenState();
}
class SignUpScreenState extends State<SignUpScreen> {

  fireauth _fire=fireauth();

Widget buildSignUp() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Sign Up',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'OpenSans',
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget buildName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Name',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.account_box,
                color: Colors.grey,
              ),
              hintText: 'Enter Full Name',
              hintStyle: kHintTextStyle,
            ),
            onChanged: (String input1)=> _name = input1,
          ),
        ),
      ],
    );
  }
   Widget buildUsername() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Username',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.account_box,
                color: Colors.grey,
              ),
              hintText: 'Enter Username',
              hintStyle: kHintTextStyle,
            ),
            onChanged: (String input2) => _username = input2,
          ),
        ),
      ],
    );
  }

  Widget buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.grey,
              ),
              hintText: 'Enter your Email',
              hintStyle: kHintTextStyle,
            ),
            onChanged: (String input3) => _email = input3,
          ),
        ),
      ],
    );
  }

  Widget buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            obscureText:true,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.grey,
              ),
              hintText: 'Enter a Strong Password',
              hintStyle: kHintTextStyle,
            ),
            onChanged: (String input4) => _password = input4,
          ),
        ),
      ],
    );
  }
  Widget buildSignUpBtn() {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 25.0),
          width: double.infinity,
          child: RaisedButton(
            elevation: 5.0,
            onPressed:
                        signUp,
                //         AlertDialog(
                //         title: Text("Welcome"),
                //         content: Text("Verification link has been sent to your email"),
                // ),
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'SIGN UP',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF73AEF5),
                      Color(0xFF61A4F1),
                      Color(0xFF478DE0),
                      Color(0xFF398AE5),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 120.0,
                  ),
                  child: Column(
                    children: <Widget>[
                      buildSignUp(),
                      SizedBox(
                        height: 10.0,
                      ),
                      buildName(),
                      SizedBox(
                        height: 10.0,
                      ),
                      buildEmailTF(),
                      SizedBox(
                        height: 10.0,
                      ),
                      buildPasswordTF(),
                      SizedBox(
                        height: 10.0,
                      ),
                      buildUsername(),
                      buildSignUpBtn(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
void signUp() async {
      try{
       // AuthResult
        UserCredential user=await _fire.Create(_email, _password);
        await user.user.updateProfile(displayName: _name,);
        await user.user.updateEmail(_email);
        _fire.Reload();
        User curr=await _fire.Current();

        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(curr: curr)));
/*
      UserCredential result = await _fire.Create( _email, _password);
        FirebaseUser user = result.user;
        user.sendEmailVerification();
        Firestore.instance.collection('users').document().setData({ 'name':_name , 'username':_username ,});
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
      */}
      catch(e){
        print(e.message);
      }
    }
  }

