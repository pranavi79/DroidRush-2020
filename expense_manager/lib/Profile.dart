import 'package:expense_manager/fireauth.dart';
import 'package:expense_manager/home.dart';
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
import 'edit_profile.dart';


class Profile extends StatefulWidget {
  final User curr;

  Profile({this.curr});

  @override
  _ProfileState createState() => _ProfileState();

}


class _ProfileState extends State<Profile> {
  final _fire=fireauth();
  final List<lentobject> lentlist= List<lentobject>();
  final List<Oweobject> owelist= List<Oweobject>();
  FirebaseAuth auth = FirebaseAuth.instance;
  User curr;
  String username;

  @override
  void initState() {
    super.initState();

  }

  Widget build(BuildContext context) {
    curr= auth.currentUser;
    username=curr.displayName;
  
    return Scaffold(
      body:Column(
          children: <Widget>[
           Expanded(
             flex: 1,
             child: Container(
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.only(bottomRight: Radius.circular(30.0), bottomLeft: Radius.circular(30.0)),
                 color: Colors.blueAccent,
               ),
               width: (MediaQuery.of(context).size.width),
               child: SafeArea(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: [
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Padding(
                           padding: EdgeInsets.only(left: 15.0,top: 20.0,right:15.0),// EdgeInsets.all(15.0),
                           child: Text(
                             "Welcome to Your Profile",
                             style: TextStyle(
                               fontSize: 25.0,
                               fontWeight: FontWeight.bold,
                               color: Colors.white, //blueAccent,
                             ),
                           ),
                         ),
                         Padding(
                           padding: const EdgeInsets.all(15.0),
                           child: BackButton(
                             color: Colors.white,
                             onPressed: (){
                               Navigator.push(context, MaterialPageRoute(
                                 builder: (context) => HomeScreen(curr: curr),
                               )
                               );
                             },
                           ),
                         )
                       ],
                     ),
                     Padding(
                       padding: const EdgeInsets.all(15.0),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Row(
                             children: [
                               Image.asset(
                                 'images/defaultProfile.png',
                                 colorBlendMode: BlendMode.colorDodge,
                                 width: 75,
                                 height: 75,
                               ),
                               SizedBox(
                                 width: 10,
                               ),
                               Text(
                                 '$username',
                                 style: TextStyle(
                                   fontSize: 25.0,
                                   fontWeight: FontWeight.bold,
                                   color: Colors.white, //blueAccent,
                                 ),
                               ),
                             ],
                           ),
                           ElevatedButton(
                             onPressed:(){
                               Navigator.push(context, MaterialPageRoute(
                                   builder: (context) => EditProfile(),
                               )
                               );
                               },
                             child: Text(
                               'Edit Profile',
                               style: TextStyle(
                                 color: Colors.blueAccent
                               ),
                             ),
                             style: ButtonStyle(
                               backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                             ),


                           ),

                         ],
                       ),
                     ),
                   ],
                 ),
               ),
             ),
           ),

            Expanded(
              flex:3,
              child: Container(
                child: ListView(
                  children: <Widget>[
                    Center(
                      child: Text(
                        'Graphs Depicting Expenditure',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 25,
                        ),
                      ),
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
                        }
                        return lentchart(                                   // CALLING THE LENT CHART CLASS
                          data: lentlist,
                        );
                      }
                    }
                  ),
                  SizedBox(
                      height: 55.0
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
                        }
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
                       // ],
                      ),
                    ),
                  ),
          ]
      ),

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



