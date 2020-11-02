import 'package:expense_manager/fireauth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'charts/Chart_Month/WeekinMonth_class.dart';
import 'charts/Chart_Month/LineCharts.dart';
import 'charts/Chart_Month/WeekinMonth_chart.dart';
import 'charts/Chart_Week/DaysinWeek_chart.dart';
import 'charts/Chart_Week/DaysinWeek_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expense_manager/charts/Lent/lent_class.dart';
import 'package:expense_manager/charts/Lent/lent_chart.dart';
import 'package:expense_manager/charts/Owe/owe_class.dart';
import 'package:expense_manager/charts/Owe/owe_chart.dart';


class Profile extends StatefulWidget {
  final User curr;
  Profile({this.curr});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User curr;
  final _fire=fireauth();
  final List<lentobject> lentlist= List<lentobject>();
  final List<Oweobject> owelist= List<Oweobject>();

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
  FirebaseAuth auth = FirebaseAuth.instance;
  User curr = auth.currentUser;
    return Scaffold(
      body:
               Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Center(
                        child: Text(
                          "Welcome to your profile",
                          //+ curr?.displayName==null?'John Appleseed':curr?.displayName,
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                      SizedBox(
                          height: 100.0
                      ),
                      StreamBuilder(              //STREAM FOR THE LENT CHART
                        stream: FirebaseFirestore.instance.collection('transactions').where('receiver',isEqualTo:  auth.currentUser?.email).snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData){
                            return Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                ),
                              );
                          }
                          else {
                            int a= snapshot.data.documents.length;
                            for(int i=0; i<a; i++){                               //MAKING THE LIST FOR THE CHART
                              final lent = snapshot.data.documents[i];
                              lentobject l= lentobject(
                                comment: lent.data()['comment'],
                                amt: lent.data()['amount'],
                                barColor: charts.ColorUtil.fromDartColor(Colors.blue)
                              );
                              lentlist.add(l);
                            };
                            return lentchart(                                   // CALLING THE LENT CHART CLASS
                              data: lentlist,
                            );
                          }
                        }
                      ),
                      SizedBox(
                          height: 25.0
                      ),
                      StreamBuilder(                              //STREAM FOR THE OWE CHART
                        stream: FirebaseFirestore.instance
                          .collection('transactions')
                          .where('member', arrayContains: auth.currentUser?.email)
                          .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.blue),
                              ),
                            );
                          }
                          else {
                            int b = snapshot.data.documents.length;

                            for (int i = 0; i < b; i++) {                           //MAKING THE LIST FOR THE CHART
                              final t = snapshot.data.documents[i];
                              Map<dynamic, dynamic> sender = Map.from(t['sender']);
                              Oweobject o = Oweobject(
                                  name: t.data()['receiver'],
                                  amt: sender[auth.currentUser?.email],
                                  barColor: charts.ColorUtil.fromDartColor(Colors.blue)
                              );
                              owelist.add(o);
                            };
                            return owechart(                                        //CALLING OWECHART CLASS
                              data: owelist,
                            );
                          }
                        }
                      ),

                      SizedBox(
                          height: 8.0
                      ),
                    ],
                  ),
                ),
              ),

            ///////////////////WIDGET AND COLUMN AND SCROLL AND PADDING END HERE
    /*      }
        }),*/


      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          _fire.out();
          Phoenix.rebirth(context);
        },
        label: Text('Sign Out'),
        //icon: Icon(Icons.thumb_up),
        backgroundColor: Colors.blueAccent,
      ),

      bottomNavigationBar: SafeArea(
        child: BottomAppBar(
          color: Colors.blue,
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {},
                color: Colors.blue,
              ),

            ],
          ),
          //child: bottomAppBarContents,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,


    );
  }
}



