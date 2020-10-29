import 'package:flutter/material.dart';

class DivideAmount extends StatefulWidget {
  @override
  _DivideAmountState createState() => _DivideAmountState();
}

class _DivideAmountState extends State<DivideAmount> {
  Map<String, double> payableAmount = {
    'Apple': 78.5,
    'Orange': 90.5,
  };

  TextEditingController _controller;

  Future<Map<String, double>> _amountPayable() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text('Divide Amount'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    //Push money to firestore
                  },
                  child: Text('Done'),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context, null);
                  },
                  child: Text('Cancel'),
                ),
              ],
              content: Container(
                width: double.minPositive,
                height: 300,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: payableAmount.length,
                    itemBuilder: (BuildContext context, int index) {
                      String _key = payableAmount.keys.elementAt(index);
                      _controller = TextEditingController(
                          text:
                              payableAmount[_key].toString());
                      return TextField(
                        controller: _controller,
                        textInputAction: TextInputAction.go,
                        keyboardType: TextInputType.numberWithOptions(),
                        onChanged: (value) {
                          setState(() {
                            payableAmount[_key] = double.parse(value);
                          });
                        },
                      );
                    }),
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return _amountPayable();
  }
}
