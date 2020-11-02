import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/foundation.dart';

class Oweobject {
  final String name;
  final double amt;
  final charts.Color barColor;

  Oweobject
      ({@required this.name,
    @required this.amt,
    @required this.barColor});
}