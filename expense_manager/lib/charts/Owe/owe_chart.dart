
import 'package:charts_flutter/flutter.dart' as charts;
import 'owe_class.dart';
import 'package:flutter/material.dart';

class owechart extends StatelessWidget {
  final List<Oweobject> data;

  owechart({@required this.data});
  @override
  Widget build(BuildContext context) {
    List<charts.Series<Oweobject, String>> series = [
      charts.Series(
          id: "Money",
          data: data,
          domainFn: (Oweobject series, _) => series.name,
          measureFn: (Oweobject series, _) => series.amt,
          colorFn: (Oweobject series, _) => series.barColor)
    ];

    return Container(
      height: 400,
      padding: EdgeInsets.all(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            children: <Widget>[
              Text(
                "Amount Owed",
                //style: Theme.of(context).textTheme.bodyText1,//body2,
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,

                ),
              ),
              Expanded(
                child: charts.BarChart(series, animate: true),
              )
            ],
          ),
        ),
      ),
    );


  }
}