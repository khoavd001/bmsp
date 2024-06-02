import 'dart:developer';

import 'package:bmsp/controller.dart';
import 'package:bmsp/login_screen.dart';
import 'package:bmsp/monitor.dart';
import 'package:bmsp/rsc/color_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late final TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    Image.asset('assets/images/logo.png'),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      'UTE',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          fontSize: 50),
                    ),
                    const Spacer(),
                    Material(
                      color: AppColors.primary2,
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
                      child: InkWell(
                        splashColor: AppColors.primary.withAlpha(50),
                        onTap: () {
                          _signOut();
                        },
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25)),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 10),
                          child: Text(
                            'Log out',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                const Spacer(),
                SizedBox(
                  width: 700,
                  child: TabBar(
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        10.0,
                      ),
                      border: Border.all(color: AppColors.primary),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    splashBorderRadius: BorderRadius.circular(
                      10.0,
                    ),
                    labelColor: AppColors.primary,
                    labelStyle: const TextStyle(fontWeight: FontWeight.w700),
                    unselectedLabelColor: AppColors.neutral,
                    controller: _tabController,
                    tabs: <Widget>[
                      Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          border: Border.all(
                            color: Colors.grey.withAlpha(50),
                          ),
                        ),
                        width: double.infinity,
                        child: const Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.monitor_rounded),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24),
                                child: Text('Controller'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          border: Border.all(
                            color: Colors.grey.withAlpha(50),
                          ),
                        ),
                        width: double.infinity,
                        child: const Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.construction),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24),
                                child: Text('Mornitor'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          border: Border.all(
                            color: Colors.grey.withAlpha(50),
                          ),
                        ),
                        width: double.infinity,
                        child: const Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.description_outlined),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24),
                                child: Text('About'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  Controller(),
                  Monitor(),
                  Center(
                    child: Text(
                      'Place Bid',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _signOut() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      await _auth.signOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => LoginScreen()));
    } catch (e) {
      log(e.toString());
    }
  }
}
