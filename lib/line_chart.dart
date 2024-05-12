// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'package:bmsp/rsc/color_manager.dart';
import 'package:bmsp/util/enum/unit_enum.dart';

class Result {
  String time;
  double value;
  Result({
    required this.time,
    required this.value,
  });
}

class LineChartSample2 extends StatefulWidget {
  const LineChartSample2({super.key, required this.unitType});
  final UnitEnum unitType;
  @override
  State<LineChartSample2> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  String data = '0';
  List<Color> gradientColors = [
    AppColors.primary,
    AppColors.primary2,
  ];
  List<double> _dataPoints = []; // Initial data points
  List<String> _axisX = [];
  List<Result> result = [];
  late Timer _timer;
  @override
  void initState() {
    DatabaseReference databaseRef = FirebaseDatabase.instance
        .ref()
        .child('Monitor')
        .child(widget.unitType.fetchString)
        .child('data');
    databaseRef.onValue.listen((event) {
      setState(() {
        if (_dataPoints.length > 9) {
          _dataPoints.removeAt(0);
          _axisX.removeAt(0);
          result.removeAt(0);
          addData(event);
        } else {
          addData(event);
        }
      });
    });
    super.initState();
  }

  void addData(DatabaseEvent event) {
    _dataPoints.add(widget.unitType == UnitEnum.pressure
        ? 5 * (double.parse(event.snapshot.value.toString())) / 100
        : double.parse(event.snapshot.value.toString()) /
            widget.unitType.divideNumber);

    _axisX.add(DateFormat('HH:mm:ss').format(DateTime.now()));

    result.add(Result(
        time: DateFormat('HH:mm:ss').format(DateTime.now()),
        value: double.parse(event.snapshot.value.toString())));
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 16,
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 500),
          child: DataTable(
              columns: [
                DataColumn(
                  label: Text(widget.unitType.nameString),
                ),
                const DataColumn(
                  label: Text('Time'),
                ),
              ],
              rows: result
                  .map(
                    (e) => DataRow(cells: [
                      DataCell(Text(
                          '${e.value.toString()} ${widget.unitType.unitString}')),
                      DataCell(Text(e.time)),
                    ]),
                  )
                  .toList()),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: VerticalDivider(
            width: 20,
            thickness: 1,
            indent: 20,
            endIndent: 0,
            color: Colors.grey,
          ),
        ),
        Expanded(
          child: Stack(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1.70,
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 18,
                    left: 12,
                    top: 24,
                    bottom: 12,
                  ),
                  child: LineChart(
                    duration: const Duration(seconds: 1),
                    showAvg ? avgData() : mainData(),
                  ),
                ),
              ),
              SizedBox(
                width: 60,
                height: 34,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      showAvg = !showAvg;
                    });
                  },
                  child: Text(
                    'avg',
                    style: TextStyle(
                      fontSize: 12,
                      color: showAvg
                          ? Colors.white.withOpacity(0.5)
                          : Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        if (_axisX.isNotEmpty) {
          text = Text(_axisX[0], style: style);
        } else {
          text = const Text("", style: style);
        }
        break;
      case 1:
        if (_axisX.length > 1) {
          text = Text(_axisX[1], style: style);
        } else {
          text = const Text("", style: style);
        }
        break;
      case 2:
        if (_axisX.length > 2) {
          text = Text(_axisX[2], style: style);
        } else {
          text = const Text("", style: style);
        }
        break;
      case 3:
        if (_axisX.length > 3) {
          text = Text(_axisX[3], style: style);
        } else {
          text = const Text("", style: style);
        }
        break;
      case 4:
        if (_axisX.length > 4) {
          text = Text(_axisX[4], style: style);
        } else {
          text = const Text("", style: style);
        }
        break;
      case 5:
        if (_axisX.length > 5) {
          text = Text(_axisX[5], style: style);
        } else {
          text = const Text("", style: style);
        }
        break;
      case 6:
        if (_axisX.length > 6) {
          text = Text(_axisX[6], style: style);
        } else {
          text = const Text("", style: style);
        }
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '${1 * widget.unitType.divideNumber}';
        break;
      case 2:
        text = '${2 * widget.unitType.divideNumber}';
        break;
      case 3:
        text = '${3 * widget.unitType.divideNumber}';
        break;
      case 4:
        text = '${4 * widget.unitType.divideNumber}';
        break;
      case 5:
        text = '${5 * widget.unitType.divideNumber}';
        break;
      case 6:
        text = '${6 * widget.unitType.divideNumber}';
        break;
      case 7:
        text = '${7 * widget.unitType.divideNumber}';
        break;
      case 8:
        text = '${8 * widget.unitType.divideNumber}';
        break;
      case 9:
        text = '${9 * widget.unitType.divideNumber}';
        break;
      case 10:
        text = '${10 * widget.unitType.divideNumber}';
        break;

      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: AppColors.primary,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: AppColors.primary,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: (widget.unitType == UnitEnum.speed ||
              widget.unitType == UnitEnum.pressure)
          ? 5
          : 10,
      lineBarsData: [
        LineChartBarData(
          spots: _dataPoints.asMap().entries.map((entry) {
            return FlSpot(entry.key.toDouble(), entry.value);
          }).toList(),
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
            ],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

List<FlSpot> spots = const [
  FlSpot(0, 3),
  FlSpot(2.6, 2),
  FlSpot(4.9, 5),
  FlSpot(6.8, 3.1),
  FlSpot(8, 4),
  FlSpot(9.5, 3),
  FlSpot(11, 4),
];
