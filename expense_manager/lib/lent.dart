import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:expense_manager/charts/Lent/lent_class.dart';
import 'package:expense_manager/charts/Lent/lent_chart.dart';

class LentScreen extends StatefulWidget {
  final User curr;
  LentScreen({this.curr});
  @override
  _LentScreenState createState()=>_LentScreenState();
}
class _LentScreenState extends State<LentScreen> {
  final _auth = FirebaseAuth.instance;
  User curr;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }
  void getCurrentUser() async {
    try {
      User hey = _auth.currentUser;
      if (hey != null) {
        curr = hey;
      }
    } catch (e) {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('transactions').where('receiver',isEqualTo:  _auth.currentUser?.email).snapshots(),
        builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    );
                  }
                else {
                  return ListView.builder(
                      itemCount:snapshot.data.documents.length,
                      itemBuilder: (BuildContext context, int index) {
                        final lent=snapshot.data.documents[index];
                        final  lentlist=[];

                        /* lentobject l;

        l.setcomment(lent.data()['comment]']);
        l.setamt(lent['amount']);
        lentlist.add(l);*/
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

                                    /*lentchart(
                          data: lentlist,
                        ),*/
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