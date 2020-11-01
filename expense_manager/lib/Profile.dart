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



  final List<WeekExpenditure> data1 = [
    WeekExpenditure(
      week: "Week 1",
      amt: 4,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    WeekExpenditure(
      week: "Week 2",
      amt: 1,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    WeekExpenditure(
      week: "Week 3",
      amt: 2,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    WeekExpenditure(
      week: "Week 4",
      amt: 3,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
  ];

  final List<DayExpenditure> data2 = [
    DayExpenditure(
      day: "Mon",
      amt: 4,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    DayExpenditure(
      day: "Tues",
      amt: 1,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    DayExpenditure(
      day: "Wed",
      amt: 2,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    DayExpenditure(
      day: "Thurs",
      amt: 3,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    DayExpenditure(
      day: "Fri",
      amt: 3,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    DayExpenditure(
      day: "Sat",
      amt: 3,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    DayExpenditure(
      day: "Sun",
      amt: 3,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),

  ];


  @override



  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
  FirebaseAuth auth = FirebaseAuth.instance;
  User curr = auth.currentUser;


  //print(lentlist[0].amt);


    return Scaffold(
      body:StreamBuilder(
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
          for(int i=0; i<a; i++){
          final lent = snapshot.data.documents[i];
          lentobject l= lentobject(
              comment:  lent.data()['comment'],
              amt:  lent.data()['amount'],
              barColor: charts.ColorUtil.fromDartColor(Colors.blue));
          lentlist.add(l);
          };

            /*return ListView.builder(
              itemCount:snapshot.data.documents.length,
              itemBuilder: (BuildContext context, int index)
              {
              final lent = snapshot.data.documents[index];
              lentobject l= lentobject(
                  comment:  lent.data()['comment'],
                  amt:  lent.data()['amount'],
                  barColor: charts.ColorUtil.fromDartColor(Colors.blue));
              lentlist.add(l);
              print(index);
*/
              return Padding(
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

                      lentchart(

                        data: lentlist,
                      ),

                      SizedBox(
                          height: 8.0
                      ),

                    ],
                  ),
                ),
              );

  //  }
  //  );



            ///////////////////WIDGET AND COLUMN AND SCROLL AND PADDING END HERE

          }
        }),


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



