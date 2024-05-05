import 'package:bmsp/line_chart.dart';
import 'package:bmsp/rsc/color_manager.dart';
import 'package:bmsp/util/enum/unit_enum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Monitor extends StatefulWidget {
  const Monitor({
    super.key,
  });

  @override
  State<Monitor> createState() => _MonitorState();
}

class _MonitorState extends State<Monitor> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 255, 255, 255),
                          AppColors.linear.withAlpha(100),
                          AppColors.linear.withAlpha(150),
                          AppColors.linear.withAlpha(100),
                          Color.fromARGB(255, 242, 243, 247),
                        ],
                        stops: [
                          0.1,
                          0.4,
                          0.5,
                          0.6,
                          0.9
                        ],
                        tileMode: TileMode.clamp,
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter),
                  ),
                  child: ListView.builder(
                    itemCount: UnitEnum.values.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: ListTile(
                          leading: Image.asset(
                            UnitEnum.values[index].imageString,
                            height: 40,
                          ),
                          title: Text(UnitEnum.values[index].nameString),
                          selected: index == _selectedIndex,
                          onTap: () {
                            setState(() {
                              _selectedIndex = index;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              Flexible(
                flex: 4,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 16,
                    ),
                    DataTable(columns: [
                      DataColumn(
                        label: Text('Time'),
                      ),
                      DataColumn(
                        label: Text('Voltage'),
                      ),
                    ], rows: [
                      DataRow(cells: [
                        DataCell(Text('1')),
                        DataCell(Text('Arshik')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('1')),
                        DataCell(Text('Arshik')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('1')),
                        DataCell(Text('Arshik')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('1')),
                        DataCell(Text('Arshik')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('1')),
                        DataCell(Text('Arshik')),
                      ]),
                    ]),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      child: const VerticalDivider(
                        width: 20,
                        thickness: 1,
                        indent: 20,
                        endIndent: 0,
                        color: Colors.grey,
                      ),
                    ),
                    Expanded(child: LineChartSample2()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
