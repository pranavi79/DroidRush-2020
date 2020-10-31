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
  TextEditingController _amount = TextEditingController(text: "0");
  TextEditingController _description = TextEditingController();
  final databaseReference = FirebaseFirestore.instance;

  Map<String, double> dividedAmount = {};
  Map<String, TextEditingController> amountValues = {};

  _displayDialog(BuildContext context, List<String> usernames) async {
    return showDialog(
      context: context,
      child: _SystemPadding(
          child: AlertDialog(
        //scrollable: true,
        title: Text('New Transaction'),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        content: Container(
          // height: 1000,
          // width: 400,
          // child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(flex: 3, child: Text("Total Bill")),
                  Expanded(
                    flex: 4,
                    child: TextField(
                      textAlign: TextAlign.right,
                      controller: _amount,
                      textInputAction: TextInputAction.go,
                      keyboardType: TextInputType.numberWithOptions(),
                      decoration: InputDecoration(hintText: 'Total Amount'),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(flex: 3, child: Text("Description")),
                  Expanded(
                    flex: 4,
                    child: TextField(
                      controller: _description,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      decoration:
                          InputDecoration(hintText: 'What is this for?'),
                    ),
                  ),
                ],
              ),
              Card(
                margin: EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  "Division",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Expanded(
                child: Container(
                  height: 300,
                  width: double.maxFinite,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: usernames.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 3,
                                child: Text(usernames[index]),
                              ),
                              Expanded(
                                flex: 2,
                                child: TextField(
                                  keyboardType:
                                      TextInputType.numberWithOptions(),
                                  decoration:
                                      InputDecoration(hintText: 'Amount'),
                                  controller: amountValues[usernames[index]],
                                  onTap: () {
                                    var textEditingController =
                                        new TextEditingController(text: "0");
                                    amountValues.putIfAbsent(usernames[index],
                                        () => textEditingController);
                                  },
                                  onChanged: (value) {
                                    takeDivision(value, usernames[index]);
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                ),
              )
            ],
          ),
          // ),
        ),
        actions: <Widget>[
          new RaisedButton(
            onPressed: () {
              double total = double.parse(_amount.text);
              double eachShare = total / (1 + usernames.length);
              for (var username in usernames) {
                var textEditingController =
                    new TextEditingController(text: eachShare.toString());
                amountValues.putIfAbsent(username, () => textEditingController);
                takeDivision(textEditingController.text, username);
              }
            },
            child: Text('Split Equally'),
          ),
          new RaisedButton(
            onPressed: () {
              User user = FirebaseAuth.instance.currentUser;
              Transactions transactions = Transactions();
              transactions.amount = double.parse(_amount.text);
              transactions.comment = _description.text;
              transactions.receiver = user.email;
              transactions.sender = dividedAmount;
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
      )),
    );
  }

  //@override
  void build(BuildContext context, List<String> usernames) {
    _displayDialog(context, usernames);
  }

  void takeDivision(String text, String username) {
    double amount = double.parse(text);
    dividedAmount.putIfAbsent(username, () => amount);
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

class _SystemPadding extends StatelessWidget {
  final Widget child;
  _SystemPadding({this.child});
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(
        padding: mediaQuery.padding,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}
