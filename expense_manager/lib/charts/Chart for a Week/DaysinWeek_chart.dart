import 'package:charts_flutter/flutter.dart' as charts;
import 'DaysinWeek_class.dart';
import 'package:flutter/material.dart';

class DaysinWeekChart extends StatelessWidget {
  final List<DayExpenditure> data;

  DaysinWeekChart({@required this.data});
  @override
  Widget build(BuildContext context) {
    List<charts.Series<DayExpenditure, String>> series = [
      charts.Series(
          id: "Money",
          data: data,
          domainFn: (DayExpenditure series, _) => series.day,
          measureFn: (DayExpenditure series, _) => series.amt,
          colorFn: (DayExpenditure series, _) => series.barColor)
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
                "Average Expenditure Over the Week",
                style: Theme.of(context).textTheme.bodyText1,//body2,
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