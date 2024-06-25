import 'dart:developer';

import 'package:bmsp/controller.dart';
import 'package:bmsp/data_manager.dart';
import 'package:bmsp/firebase_options.dart';
import 'package:bmsp/home_page.dart';
import 'package:bmsp/login_screen.dart';
import 'package:bmsp/monitor.dart';
import 'package:bmsp/rsc/color_manager.dart';
import 'package:bmsp/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBEv-R-ldgNqPRe9bISG8ldIx3ntbKl7ok",
            appId: "1:541058254186:web:8f82c95d07c87629cf5113",
            messagingSenderId: "541058254186",
            projectId: "datapump-9d6d8",
            databaseURL: "https://datapump-9d6d8-default-rtdb.firebaseio.com"));
  } else {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late DatabaseReference databaseRef;

  @override
  void initState() {
    super.initState();
    databaseRef = FirebaseDatabase.instance
        .ref()
        .child('Monitor-Valve')
        .child('Flow Water')
        .child('data');
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DataModel(databaseRef),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
