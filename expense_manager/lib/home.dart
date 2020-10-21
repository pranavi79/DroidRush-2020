import 'package:expense_manager/chat/home_screen.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}
class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
     return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.blue,
            elevation: 0,
            bottom: TabBar(
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.label,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    color: Colors.white),
                tabs: [
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Owe"),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Lent"),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Groups"),
                    ),
                  ),
                ]
            ),
          ),
          body: TabBarView(children: [
            Icon(Icons.money_off),
            Icon(Icons.attach_money),
            HomeScreen2()
          ]),
        )
     );
  }
}