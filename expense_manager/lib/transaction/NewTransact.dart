// AlertDialog to enter new transaction details.

//import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../class.dart';

class NewTransaction {
  //extends StatelessWidget {
  TextEditingController _amount = TextEditingController();
  TextEditingController _description = TextEditingController();
  final databaseReference = FirebaseFirestore.instance;

  List<String> groupMembers = ['caron', 'pranavi'];

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('New Transaction'),
            content: Column(
              children: <Widget>[
                TextField(
                  controller: _amount,
                  textInputAction: TextInputAction.go,
                  keyboardType: TextInputType.numberWithOptions(),
                  decoration: InputDecoration(hintText: 'Total Amount'),
                ),
                TextField(
                  controller: _description,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(hintText: 'What is this for?'),
                ),
                // ListView.builder(
                //   itemCount: groupMembers.length,
                //   itemBuilder: (context,index){
                //     return Card(
                //       child: Row(
                //         children: <Widget>[
                //           Text(groupMembers[index]),
                //           TextField(
                //             controller: _amount,
                //             textInputAction: TextInputAction.go,
                //             keyboardType: TextInputType.numberWithOptions(),
                //             decoration: InputDecoration(hintText: 'Total Amount'),
                //           ),
                //         ],
                //       ),
                //     );
                //   })
              ],
            ),
            actions: <Widget>[
              new RaisedButton(
                onPressed: () {
                  User user = FirebaseAuth.instance.currentUser;
                  Transactions transactions = Transactions();
                  transactions.amount = double.parse(_amount.text);
                  transactions.comment = _description.text;
                  transactions.receiver = user.email;
                  transactions.sender = {'caron': double.parse(_amount.text)};
                  pushNewTransaction(transactions);
                },
                child: Text('Submit'),
              ),
              new RaisedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              )
            ],
          );
        });
  }

  //@override
  void build(BuildContext context) {
    _displayDialog(context);
  }

  void pushNewTransaction(Transactions transaction) async {
    await databaseReference.collection("transactions").doc().set({
      'receiver': transaction.receiver,
      'amount': transaction.amount,
      'comment': transaction.comment,
      'sender': transaction.sender
    });
  }
}
