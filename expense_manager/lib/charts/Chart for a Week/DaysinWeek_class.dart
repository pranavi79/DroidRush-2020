import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/foundation.dart';

class DayExpenditure {
  final String day;
  final int amt;
  final charts.Color barColor;

  DayExpenditure(
      {@required this.day,
        @required this.amt,
        @required this.barColor});
}

