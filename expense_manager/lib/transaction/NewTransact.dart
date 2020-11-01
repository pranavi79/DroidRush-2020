// AlertDialog to enter new transaction details.

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../class.dart';

class NewTransact extends StatefulWidget {
  final List<String> usernames;
  NewTransact({Key key, @required this.usernames}) : super(key: key);
  @override
  _NewTransactState createState() => _NewTransactState();
}

class _NewTransactState extends State<NewTransact> {
  TextEditingController _amount = TextEditingController(text: "0");
  TextEditingController _description = TextEditingController();
  final databaseReference = FirebaseFirestore.instance;

  Map<String, double> dividedAmount = {};
  Map<String, TextEditingController> amountValues = {};

  @override
  void initState() {
    for (var username in widget.usernames) {
      var textEditingController = new TextEditingController(text: "0");
      amountValues.putIfAbsent(username, () => textEditingController);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New"),
        actions: <Widget>[
          new FlatButton(
            onPressed: () {
              double total = double.parse(_amount.text);
              double eachShare = total / (1 + widget.usernames.length);
              for (var username in widget.usernames) {
                amountValues[username].text = eachShare.toString();
              }
            },
            child: Text(
              'Split Equally',
              style: TextStyle(
                color: Colors.white,
              ),
              ),
          ),
          new FlatButton(
            onPressed: () {
              User user = FirebaseAuth.instance.currentUser;
              amountValues.forEach((k, v) {
                takeDivision(v.text, k);
              });
              Transactions transactions = Transactions();
              transactions.amount = double.parse(_amount.text);
              transactions.comment = _description.text;
              transactions.receiver = user.email;
              transactions.sender = dividedAmount;
              pushNewTransaction(transactions);
              Navigator.of(context).pop();
            },
            child: Text(
              'Submit',
              style: TextStyle(
                color: Colors.white,
              ),),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(15),
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
                    decoration: InputDecoration(hintText: 'What is this for?'),
                  ),
                ),
              ],
            ),
            Card(
              margin: EdgeInsets.only(top: 25, bottom: 15),
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
                    itemCount: widget.usernames.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: Text(widget.usernames[index]),
                            ),
                            Expanded(
                              flex: 2,
                              child: TextField(
                                keyboardType: TextInputType.numberWithOptions(),
                                decoration: InputDecoration(hintText: 'Amount'),
                                controller:
                                    amountValues[widget.usernames[index]],
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
    );
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
      'sender': transaction.sender,
      'member':widget.usernames.remove(transaction.receiver),
    });
  }
}
