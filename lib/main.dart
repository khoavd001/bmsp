import 'dart:developer';

import 'package:bmsp/controller.dart';
import 'package:bmsp/home_page.dart';
import 'package:bmsp/login_screen.dart';
import 'package:bmsp/monitor.dart';
import 'package:bmsp/rsc/color_manager.dart';
import 'package:bmsp/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBEv-R-ldgNqPRe9bISG8ldIx3ntbKl7ok",
          appId: "1:541058254186:web:8f82c95d07c87629cf5113",
          messagingSenderId: "541058254186",
          projectId: "datapump-9d6d8",
          databaseURL: "https://datapump-9d6d8-default-rtdb.firebaseio.com"));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: MyHomePage());
  }
}
