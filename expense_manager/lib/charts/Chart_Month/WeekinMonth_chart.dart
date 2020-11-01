import 'package:charts_flutter/flutter.dart' as charts;
import 'WeekinMonth_class.dart';
import 'package:flutter/material.dart';

class WeekinMonthChart extends StatelessWidget {
  final List<WeekExpenditure> data;

  WeekinMonthChart({@required this.data});
  @override
  Widget build(BuildContext context) {
    List<charts.Series<WeekExpenditure, String>> series = [
      charts.Series(
          id: "Money",
          data: data,
          domainFn: (WeekExpenditure series, _) => series.week,
          measureFn: (WeekExpenditure series, _) => series.amt,
          colorFn: (WeekExpenditure series, _) => series.barColor)
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
                "Average Expenditure Over the Month",
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