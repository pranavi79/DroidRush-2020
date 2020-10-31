import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/chat/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../home.dart';
final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
class AddMembers extends StatefulWidget{
  @override
  AddMembersState createState()=>AddMembersState();
}
class AddMembersState extends State<AddMembers>{
  Widget buildGroup() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Group Name',
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          height: 60.0,
          child: TextFormField(
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 14.0),
              hintText: 'Enter Full Name',
            ),
            onChanged: (input1)=> group = input1,
          ),
        ),
      ],
    );
  }
    Widget buildAdd() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Add Members',
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          height: 60.0,
              child:TextFormField(
            controller: addTextController,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 14.0),
                            suffixIcon: IconButton(
                  icon: Icon(
                    Icons.add_circle,
                    size: 30,
                    color: Colors.blueGrey[200],
                  ),
                  onPressed: () {
                    addTextController.clear();
                    lst.add(add);
                  }
                  ),
              hintText: 'Enter Member Email',
            ),
            onChanged: (input2)=> add = input2,
          ),
        ),
      ],
    );
  }
   Widget buildSubmitBtn() {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 25.0),
          width: double.infinity,
          child: RaisedButton(
            elevation: 5.0,
            onPressed:(){
              lst.add(_auth.currentUser?.email);
               _firestore.collection('groups').add({
                'group':group,
                'members':lst,
              });
               Navigator.pop(context);
            },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.blue,
        child: Text(
          'CREATE',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }
    final addTextController = TextEditingController();
    String group;
    String add;
    final lst=List();
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("New Group"),
      ),
      body:   AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
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
                      buildGroup(),
                      SizedBox(
                        height: 10.0,
                      ),
                      buildAdd(),
                      SizedBox(
                        height: 10.0,
                      ),
                      buildSubmitBtn(),
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
}