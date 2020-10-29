// AlertDialog to enter new transaction details.

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class NewTransaction extends StatelessWidget {
  TextEditingController _amount = TextEditingController();
  TextEditingController _description = TextEditingController();

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
                )
              ],
            ),
            actions: <Widget>[
              new RaisedButton(
                onPressed: () {},
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

  @override
  Widget build(BuildContext context) {
    return _displayDialog(context);
  }
}
