import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class LentScreen extends StatelessWidget {
  final User curr;
  LentScreen({this.curr});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('transactions').where('reciever',isEqualTo: curr?.email).snapshots(),
    builder: (context, snapshot) {
                if (!snapshot.hasData) {
        return Center(
          child: CircularProgressIndicator(
			valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        );
      } else {
        return ListView.builder(
        itemCount:snapshot.data.documents.length,
        itemBuilder: (BuildContext context, int index) {
        final lent=snapshot.data.documents[index];
                        print(index);
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.90,
                    padding: EdgeInsets.only(
                      left: 20,
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                                Text(
                                  lent.data()['comment'],
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),

                                ),
                                 Text(
                                   lent['amount'].toString(),
                                   style:TextStyle(
                                     fontWeight:FontWeight.w300,
                                     color:Colors.grey,
                                   ),
                                   textAlign: TextAlign.end,
                                 )
                              ],
                            ),
                      ],
                    ),
                  ),
                ],
              ),
            );
      }
        );
        }
    })
    );
  }
}