import 'package:bmsp/rsc/color_manager.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';

class Controller extends StatefulWidget {
  const Controller({
    super.key,
  });

  @override
  State<Controller> createState() => _ControllerState();
}

class _ControllerState extends State<Controller>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  List<bool> listStartStop = [false, false];
  bool tab = false;
  bool isStartPID = false;
  int selectLocal = 0;
  bool isStartVan = false;
  List<String> listValue = ['', '', '', '', '', '', ''];
  DatabaseReference databaseRef =
      FirebaseDatabase.instance.ref().child('Control iG5A');
  DatabaseReference databaseRefVanControl =
      FirebaseDatabase.instance.ref().child('control');
  DatabaseReference databaseRefMonitorValue =
      FirebaseDatabase.instance.ref().child('Monitor-Valve');
  @override
  void initState() {
    databaseRef.child('PIDselect').child('Data').onValue.listen((event) {
      setState(() {
        if (event.snapshot.value.toString() == "1") {
          isStartPID = true;
        } else {
          isStartPID = false;
        }
      });
    });
    databaseRef.child('Run').child('Data').onValue.listen((event) {
      setState(() {
        if (event.snapshot.value.toString() == "2") {
          isStartVan = true;
        } else {
          isStartVan = false;
        }
      });
    });
    databaseRefVanControl
        .child('Override Value DO1')
        .child('data')
        .onValue
        .listen((event) {
      setState(() {
        if (event.snapshot.value.toString() == "1") {
          listStartStop[0] = true;
        } else {
          listStartStop[0] = false;
        }
      });
    });
    databaseRefVanControl
        .child('Override Value DO2')
        .child('data')
        .onValue
        .listen((event) {
      setState(() {
        if (event.snapshot.value.toString() == "1") {
          listStartStop[1] = true;
        } else {
          listStartStop[1] = false;
        }
      });
    });

    databaseRefMonitorValue
        .child('Remote')
        .child('data')
        .onValue
        .listen((event) {
      setState(() {
        selectLocal = int.parse(event.snapshot.value.toString());
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          size.width < 490 ? _buildTabHeaders() : const SizedBox(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              size.width < 490 ? const SizedBox() : _renderDrawNav(),
              Flexible(
                flex: size.width > 490 ? 4 : 1,
                child: tab
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const SizedBox(width: 20),
                              SwitchExample(
                                isStart: isStartVan,
                                onTap: (val) {
                                  setState(() {
                                    isStartVan = val;
                                    if (isStartVan) {
                                      databaseRef
                                          .child('Run')
                                          .child('Data')
                                          .set(2);
                                    } else {
                                      databaseRef
                                          .child('Run')
                                          .child('Data')
                                          .set(1);
                                    }
                                  });
                                },
                                startTitle: 'Start',
                                stopTitle: 'Stop',
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: listStartStop
                                .asMap()
                                .map((index, value) => MapEntry(
                                    index,
                                    Column(
                                      children: [
                                        const SizedBox(height: 20),
                                        Image.asset(
                                          value
                                              ? 'assets/images/start_bms.png'
                                              : 'assets/images/stop_bms.png',
                                          height: 400,
                                        ),
                                        const SizedBox(height: 20),
                                        Material(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(8)),
                                          color: value
                                              ? AppColors.primary2
                                              : Colors.red,
                                          child: InkWell(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(8)),
                                            onTap: () {
                                              setState(() {
                                                listStartStop[index] =
                                                    !listStartStop[index];
                                                if (!value) {
                                                  databaseRefVanControl
                                                      .child(
                                                          'Override Value DO${index + 1}')
                                                      .child('data')
                                                      .set(1);
                                                } else {
                                                  databaseRefVanControl
                                                      .child(
                                                          'Override Value DO${index + 1}')
                                                      .child('data')
                                                      .set(0);
                                                }
                                              });
                                            },
                                            splashColor: AppColors.neutral,
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 30,
                                                      vertical: 10),
                                              child: Text(
                                                  value ? 'Start' : 'Stop'),
                                            ),
                                          ),
                                        )
                                      ],
                                    )))
                                .values
                                .toList(),
                          ),
                        ],
                      )
                    : _renderParameter(size, (val) {
                        setState(() {
                          isStartPID = val;
                          if (isStartPID) {
                            databaseRef.child('PIDselect').child('Data').set(1);
                          } else {
                            databaseRef.child('PIDselect').child('Data').set(0);
                          }
                        });
                      }, isStartPID),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabHeaders() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 3),
        InkWell(
          onTap: () => setState(() {
            tab = false;
          }),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    width: 1.5, color: tab ? Colors.grey : Colors.blue),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Setting Parameter'),
            ),
          ),
        ),
        const SizedBox(width: 15),
        InkWell(
          onTap: () => setState(() {
            tab = true;
          }),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    width: 1.5, color: tab ? Colors.blue : Colors.grey),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Control System'),
            ),
          ),
        ),
        const SizedBox(width: 15),
      ],
    );
  }

  Flexible _renderDrawNav() {
    return Flexible(
      flex: 1,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 255, 255, 255),
                AppColors.linear.withAlpha(100),
                const Color.fromARGB(255, 255, 255, 255),
              ],
              stops: const [
                0.1,
                0.5,
                1,
              ],
              tileMode: TileMode.clamp,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: Column(
          children: [
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Setting Parameter'),
                selected: tab == false,
                onTap: () {
                  setState(() {
                    tab = false;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ListTile(
                leading: const Icon(Icons.construction_outlined),
                title: const Text('Control System'),
                selected: tab == true,
                onTap: () {
                  setState(() {
                    tab = true;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderParameter(Size size, Function(bool)? onTap, bool isStart) {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 30),
            Column(
              children: [
                const SizedBox(height: 20),
                FlutterToggleTab(
                  icons: const [Icons.back_hand_rounded, Icons.monitor_sharp],
                  width: size.width > 490 ? 30 : size.width * 0.2,
                  borderRadius: 15,
                  height: 50,
                  selectedIndex: selectLocal,
                  selectedBackgroundColors: const [
                    Colors.blue,
                    Colors.blueAccent
                  ],
                  selectedTextStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                  unSelectedTextStyle: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                  labels: const ['Local', 'Remote'],
                  selectedLabelIndex: (index) {},
                  isScroll: false,
                ),
                const SizedBox(height: 20),
                _renderTextField(size, 'Frequency', onChange: (value) {
                  listValue[0] = value;
                }, onTap: () {
                  _dialogBuilder(context, () {
                    databaseRef
                        .child('Frequency')
                        .child('Data')
                        .set(listValue[0]);
                    Navigator.pop(context);
                  });
                }),
                const SizedBox(height: 20),
                _renderTextField(size, 'Acceleration', onChange: (value) {
                  listValue[1] = value;
                }, onTap: () {
                  _dialogBuilder(context, () {
                    databaseRef.child('Acc').child('Data').set(listValue[1]);
                    Navigator.pop(context);
                  });
                }),
                const SizedBox(height: 20),
                _renderTextField(size, 'Deceleration', onChange: (value) {
                  listValue[2] = value;
                }, onTap: () {
                  _dialogBuilder(context, () {
                    databaseRef.child('Dec').child('Data').set(listValue[2]);
                    Navigator.pop(context);
                  });
                }),
                const SizedBox(height: 20),
              ],
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
            size.width < 490
                ? const SizedBox()
                : _renderPID(isStart, onTap, size),
          ],
        ),
        size.width > 490
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.only(left: 30),
                child: _renderPID(isStart, onTap, size),
              ),
      ],
    );
  }

  Widget _renderPID(bool isStart, Function(bool)? onTap, Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: size.width < 490
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: [
            SwitchExample(
              isStart: isStart,
              onTap: onTap,
              startTitle: 'PID ON',
              stopTitle: 'PID OFF',
            ),
          ],
        ),
        const SizedBox(height: 20),
        _renderTextField(size, 'PID Ref', isEnable: isStart, onChange: (value) {
          listValue[3] = value;
        }, onTap: () {
          _dialogBuilder(context, () {
            databaseRef.child('PID Reference').child('Data').set(listValue[3]);
            Navigator.pop(context);
          });
        }),
        const SizedBox(height: 20),
        _renderTextField(size, 'P', isEnable: isStart, onChange: (value) {
          listValue[4] = value;
        }, onTap: () {
          _dialogBuilder(context, () {
            databaseRef.child('P gain').child('Data').set(listValue[4]);
            Navigator.pop(context);
          });
        }),
        const SizedBox(height: 20),
        _renderTextField(size, 'I', isEnable: isStart, onChange: (value) {
          listValue[5] = value;
        }, onTap: () {
          _dialogBuilder(context, () {
            databaseRef.child('I Gain').child('Data').set(listValue[5]);
            Navigator.pop(context);
          });
        }),
        const SizedBox(height: 20),
        _renderTextField(size, 'D', isEnable: isStart, onChange: (value) {
          listValue[6] = value;
        }, onTap: () {
          _dialogBuilder(context, () {
            databaseRef.child('D Gain').child('Data').set(listValue[6]);
            Navigator.pop(context);
          });
        }),
        const SizedBox(height: 20),
      ],
    );
  }

  SizedBox _renderTextField(Size size, String title,
      {bool? isEnable, VoidCallback? onTap, Function(String)? onChange}) {
    return SizedBox(
      height: 60,
      width: size.width > 490 ? size.width * 0.3 : size.width * 0.8,
      child: TextFormField(
        keyboardType: TextInputType.number,
        onChanged: onChange,
        decoration: InputDecoration(
            labelStyle: const TextStyle(fontSize: 25),
            labelText: title,
            fillColor: Colors.transparent,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(
                color: AppColors.primary2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(
                color: AppColors.primary2,
                width: 1.0,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(
                color: AppColors.primary2,
                width: 1.0,
              ),
            ),
            suffix: Material(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              color: AppColors.primary2,
              child: InkWell(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                onTap: onTap,
                splashColor: AppColors.neutral,
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: const Text('OK'),
                ),
              ),
            )),
        enabled: isEnable,
      ),
    );
  }
}

class SwitchExample extends StatefulWidget {
  const SwitchExample(
      {super.key,
      this.isStart = false,
      this.onTap,
      this.startTitle = '',
      this.stopTitle = ''});
  final Function(bool)? onTap;
  final bool isStart;
  final String startTitle;
  final String stopTitle;

  @override
  State<SwitchExample> createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<SwitchExample> {
  @override
  Widget build(BuildContext context) {
    return FlutterSwitch(
      width: 200.0,
      height: 55.0,
      valueFontSize: 25.0,
      toggleSize: 45.0,
      value: widget.isStart,
      borderRadius: 30.0,
      padding: 8.0,
      showOnOff: true,
      onToggle: widget.onTap ?? (va) {},
      inactiveColor: Colors.redAccent,
      activeText: widget.startTitle,
      inactiveText: widget.stopTitle,
      inactiveIcon: const Icon(
        Icons.stop_rounded,
        color: Colors.red,
      ),
      activeIcon: Icon(
        Icons.play_arrow_rounded,
        color: AppColors.primary2,
      ),
    );
  }
}

Future<void> _dialogBuilder(BuildContext context, VoidCallback? onTapConfirm) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm value change'),
        content: const Text('Are you sure you want to confirm this value?\n'),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Cancle'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Confirm'),
            onPressed: onTapConfirm,
          ),
        ],
      );
    },
  );
}
