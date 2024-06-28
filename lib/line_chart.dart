// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:math';

import 'package:bmsp/data_manager.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'package:bmsp/rsc/color_manager.dart';
import 'package:bmsp/util/enum/unit_enum.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

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

class _LineChartSample2State extends State<LineChartSample2>
    with TickerProviderStateMixin {
  String data = '0';
  List<Color> gradientColors = [
    AppColors.primary,
    AppColors.primary2,
  ];
  List<double> _dataPoints = []; // Initial data points
  List<String> _axisX = [];
  List<Result> result = [];
  double sumoutSide = 0;
  // Create an AnimationController
  late AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    DatabaseReference databaseRef = FirebaseDatabase.instance
        .ref()
        .child(widget.unitType == UnitEnum.flowWater ||
                widget.unitType == UnitEnum.volume
            ? 'Monitor-Valve'
            : 'Monitor')
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
    var lastTime = DateTime.now();
    final theNextTime = DateTime.now();
    final day = DateTime.now().day;
    final month = DateTime.now().month;
    final year = DateTime.now().year;
    double sum = 0;
    final dateFormat = DateFormat(
        'yyyy-MM-dd HH:mm:ss'); // Custom date format with date and time

    if (_axisX.isNotEmpty) {
      String lastTimeStr = _axisX.last;

      if (lastTimeStr != null && lastTimeStr.isNotEmpty) {
        try {
          // Prepend a default date to the time string
          String dateTimeStr =
              "$year-$month-$day $lastTimeStr"; // Use a specific date, or DateTime.now().toString().split(' ')[0] for today's date
          lastTime = dateFormat.parse(dateTimeStr);
          sum = _dataPoints.reduce((value, element) => value + element);
          print('sum: $sum');
        } catch (e) {
          print('Error parsing date: $e');
          // Handle error
          return;
        }
      } else {
        print('The last time string is null or empty');
        return;
      }
    }
    final number = double.parse(event.snapshot.value.toString()) /
        widget.unitType.divideNumber;
    final between2Time = theNextTime.difference(lastTime).inSeconds;
    print('sum: $sum');
    _dataPoints.add(widget.unitType == UnitEnum.pressure
        ? (double.parse(event.snapshot.value.toString())) / 10
        : widget.unitType == UnitEnum.volume
            ? sum + number / 60 * between2Time
            : number);
    setState(() {
      // Update the animation progress when Slider value changes

      sumoutSide = (sum + number / 60 * between2Time) * 10;
    });
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
    _controller.dispose();

    super.dispose();
  }

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        size.width < 490 ? _renderChart() : const SizedBox(),
        Row(
          mainAxisAlignment: size.width < 490
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            const SizedBox(
              width: 16,
            ),
            SizedBox(
              height: 250,
              child: SingleChildScrollView(
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 500),
                  child: DataTable(
                      columns: [
                        DataColumn(
                          label: Text(widget.unitType.nameString == 'Volume'
                              ? 'Flow Water'
                              : widget.unitType.nameString),
                        ),
                        const DataColumn(
                          label: Text('Time'),
                        ),
                      ],
                      rows: (size.width < 490 ? result.reversed : result)
                          .map(
                            (e) => DataRow(cells: [
                              DataCell(Text(
                                  '${e.value.toString()} ${widget.unitType.unitString}')),
                              DataCell(Text(e.time)),
                            ]),
                          )
                          .toList()),
                ),
              ),
            ),
            size.width < 490
                ? const SizedBox()
                : const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: VerticalDivider(
                      width: 20,
                      thickness: 1,
                      indent: 20,
                      endIndent: 0,
                      color: Colors.grey,
                    ),
                  ),
            size.width < 490 ? const SizedBox() : _renderChart(),
          ],
        ),
      ],
    );
  }

  Expanded _renderChart() {
    final size = MediaQuery.of(context).size;
    return Expanded(
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
              child: widget.unitType == UnitEnum.volume
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Stack(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(left: 10),
                                      width: 140,
                                      height: 160,
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 47, 130, 246),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color.fromARGB(
                                                      255, 17, 104, 255)
                                                  .withOpacity(0.5),
                                              blurRadius: 10,
                                              offset: const Offset(0, 15),
                                            ),
                                          ]),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          const Text(
                                            'Volume',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white),
                                          ),
                                          Consumer<DataModel>(
                                              builder: (_, dataModel, child) {
                                            if (!mounted) {
                                              _controller.value =
                                                  dataModel.sumOutSide / 1000;
                                            }
                                            return Row(
                                              children: [
                                                Text(
                                                  '${dataModel.sumOutSide.toStringAsFixed(2).replaceAll(RegExp(r"([.]*00)(?!.*\d)"), "")} ',
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white),
                                                ),
                                                const Text(
                                                  'L',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white),
                                                ),
                                              ],
                                            );
                                          }),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const SizedBox(height: 50),
                                    Lottie.asset('assets/images/cloud.json',
                                        height: 120),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        Lottie.asset(
                          'assets/images/volumn.json',
                          controller: _controller,
                        ),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.only(left: 16, bottom: 16),
                      child: LineChart(
                        duration: const Duration(seconds: 1),
                        mainData(),
                      ),
                    ),
            ),
          ),
          widget.unitType == UnitEnum.volume || size.width < 490
              ? SizedBox()
              : Positioned.fill(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RotatedBox(
                        quarterTurns: -1,
                        child: Text(
                          '${widget.unitType.nameString} (${widget.unitType.unitString})',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
          widget.unitType == UnitEnum.volume
              ? SizedBox()
              : const Positioned.fill(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Time',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final size = MediaQuery.of(context).size;
    if (size.width < 490) return const SizedBox();
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
    final size = MediaQuery.of(context).size;
    var style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: size.width < 490 ? 10 : 15,
    );
    String text;
    final dividerNumber =
        widget.unitType != UnitEnum.current && widget.unitType != UnitEnum.power
            ? widget.unitType.divideNumber.toInt()
            : widget.unitType.divideNumber;
    switch (value.toInt()) {
      case 1:
        text = '${1 * dividerNumber}';
        break;
      case 2:
        text = '${2 * dividerNumber}';
        break;
      case 3:
        text = '${3 * dividerNumber}';
        break;
      case 4:
        text = '${4 * dividerNumber}';
        break;
      case 5:
        text = '${5 * dividerNumber}';
        break;
      case 6:
        text = '${6 * dividerNumber}';
        break;
      case 7:
        text = '${7 * dividerNumber}';
        break;
      case 8:
        text = '${8 * dividerNumber}';
        break;
      case 9:
        text = '${9 * dividerNumber}';
        break;
      case 10:
        text = '${10 * dividerNumber}';
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
          axisNameSize: 24,
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
      maxY: (widget.unitType == UnitEnum.speed) ? 5 : 10,
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
