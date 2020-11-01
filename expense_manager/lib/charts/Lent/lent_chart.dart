import 'package:charts_flutter/flutter.dart' as charts;
import 'lent_class.dart';
import 'package:flutter/material.dart';

class lentchart extends StatelessWidget {
  final List<lentobject> data;

  lentchart({@required this.data});
  @override
  Widget build(BuildContext context) {
    List<charts.Series<lentobject, String>> series = [
      charts.Series(
          id: "Money",
          data: data,
          domainFn: (lentobject series, _) => series.comment,
          measureFn: (lentobject series, _) => series.amt,
          colorFn: (lentobject series, _) => series.barColor)
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
                "Amount Lent",
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