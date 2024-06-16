import 'dart:developer';

import 'package:bmsp/line_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class DataModel extends ChangeNotifier {
  double _sumOutSide = 0.0;
  List<double> _dataPoints = [];
  List<String> _axisX = [];
  List<Result> _result = [];
  DatabaseReference _databaseRef;

  DataModel(this._databaseRef) {
    _databaseRef.onValue.listen((event) {
      _updateData(event);
    });
  }

  double get sumOutSide => _sumOutSide;
  List<double> get dataPoints => _dataPoints;
  List<String> get axisX => _axisX;
  List<Result> get result => _result;

  void _updateData(DatabaseEvent event) {
    log(event.snapshot.value.toString());
    var lastTime = DateTime.now();
    final theNextTime = DateTime.now();
    final day = DateTime.now().day;
    final month = DateTime.now().month;
    final year = DateTime.now().year;
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

    if (_axisX.isNotEmpty) {
      String lastTimeStr = _axisX.last;

      if (lastTimeStr != null && lastTimeStr.isNotEmpty) {
        try {
          String dateTimeStr = "$year-$month-$day $lastTimeStr";
          lastTime = dateFormat.parse(dateTimeStr);
        } catch (e) {
          print('Error parsing date: $e');
          return;
        }
      } else {
        return;
      }
    }

    final number = double.parse(event.snapshot.value.toString());
    final between2Time = theNextTime.difference(lastTime).inSeconds;
    _sumOutSide = (_sumOutSide + number / 60 * between2Time);

    log('between $between2Time');
    log('number: $number');
    log('_sumOutSide: $_sumOutSide');
    _dataPoints.add(_sumOutSide);
    _axisX.add(DateFormat('HH:mm:ss').format(DateTime.now()));
    _result.add(Result(
      time: DateFormat('HH:mm:ss').format(DateTime.now()),
      value: number,
    ));

    log(_sumOutSide.toString());
    notifyListeners();
  }
}
