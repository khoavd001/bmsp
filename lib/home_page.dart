import 'dart:developer';

import 'package:bmsp/controller.dart';
import 'package:bmsp/data_manager.dart';
import 'package:bmsp/login_screen.dart';
import 'package:bmsp/monitor.dart';
import 'package:bmsp/rsc/color_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: size.width < 490 ? _renderTabBar() : null,
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
                    Image.asset(
                      'assets/images/logo_ute.png',
                      height: 70,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    size.width < 490
                        ? const SizedBox()
                        : Text(
                            'UTE',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                                fontSize: 50),
                          ),
                    const Spacer(),
                    Material(
                      color: size.width < 490 ? null : AppColors.primary2,
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
                  child: size.width < 490 ? null : _renderTabBar(),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  const Controller(),
                  const Monitor(),
                  const Center(
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

  TabBar _renderTabBar() {
    final size = MediaQuery.of(context).size;
    return TabBar(
      dividerColor: Colors.transparent,
      indicator: size.width < 490
          ? null
          : BoxDecoration(
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
      tabs: size.width < 490
          ? [
              const Tab(
                text: "Controller",
                icon: Icon(Icons.construction),
              ),
              const Tab(
                text: "Mornitor",
                icon: Icon(Icons.monitor_rounded),
              ),
              const Tab(
                text: "About",
                icon: Icon(Icons.description_outlined),
              ),
            ]
          : <Widget>[
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
                      Icon(Icons.monitor_rounded),
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
    );
  }

  void _signOut() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      await _auth.signOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    } catch (e) {
      log(e.toString());
    }
  }
}
