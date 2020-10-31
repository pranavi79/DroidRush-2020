import 'package:expense_manager/fireauth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'charts/Chart for a Month/WeekinMonth_class.dart';
import 'charts/Chart for a Month/LineCharts.dart';
import 'charts/Chart for a Month/WeekinMonth_chart.dart';
import 'charts/Chart for a Week/DaysinWeek_chart.dart';
import 'charts/Chart for a Week/DaysinWeek_class.dart';



class Profile extends StatefulWidget {
  final User curr;
  Profile({this.curr});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User curr;
  final _fire=fireauth();

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
    //curr=widget.curr;
    super.initState();
  }

  Widget build(BuildContext context) {
  //= curr.email==null?'John Appleseed':curr?.email;
  FirebaseAuth auth = FirebaseAuth.instance;
  User curr = auth.currentUser;
    String s=curr?.displayName;



    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[

            Center(
              child: Text(
                "Welcome to your profile, $s.",   //+ curr?.displayName==null?'John Appleseed':curr?.displayName,

              ),
            ),
              SizedBox(
                height:100.0
              ),
              //LineCharts(),
              Text('Hello'),

              WeekinMonthChart(
                data: data1,
              ),

              SizedBox(
                  height:100.0
              ),
              //LineCharts(),
              Text('Great chart, huh?'),
              SizedBox(
                  height:100.0
              ),
              DaysinWeekChart(
                data: data2,
              ),
              SizedBox(
                  height:500.0
              ),
              //LineCharts(),
              Text('Yeah, ik ikkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk'),
              SizedBox(
                  height:8.0
              ),


              /*Container(
                child: Center(
                   child: FlatButton(
                     color: Colors.blue,
                     textColor: Colors.white,
                     disabledColor: Colors.grey,
                     disabledTextColor: Colors.black,
                     padding: EdgeInsets.all(8.0),
                     splashColor: Colors.blueAccent,
                      onPressed: () {
                        _fire.out();
                        Phoenix.rebirth(context);
                      },
                      child: Text(
                        "Sign Out",
                      ),
                    ),
                ),
              ),*/
            ],
          ),
        ),
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
