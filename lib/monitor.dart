import 'package:bmsp/data_manager.dart';
import 'package:bmsp/line_chart.dart';
import 'package:bmsp/rsc/color_manager.dart';
import 'package:bmsp/util/enum/unit_enum.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class Monitor extends StatefulWidget {
  const Monitor({
    super.key,
  });

  @override
  State<Monitor> createState() => _MonitorState();
}

class _MonitorState extends State<Monitor> {
  int _selectedIndex = 0;
  UnitEnum unitType = UnitEnum.voltage;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        size.width > 490
            ? SizedBox()
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(UnitEnum.values.length, (index) {
                    return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 8),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                              maxWidth: 200 // Adjust this width as necessary
                              ),
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
                                unitType = UnitEnum.values[index];
                              });
                            },
                          ),
                        ));
                  }),
                ),
              ),
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              size.width < 490
                  ? const SizedBox()
                  : Flexible(
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
                                    unitType = UnitEnum.values[index];
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
                child: LineChartSample2(
                    key: ValueKey(unitType.nameString), unitType: unitType),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
