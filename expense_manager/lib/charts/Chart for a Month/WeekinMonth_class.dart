import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/foundation.dart';

class WeekExpenditure {
  final String week;
  final int amt;
  final charts.Color barColor;

  WeekExpenditure(
      {@required this.week,
        @required this.amt,
        @required this.barColor});
}


