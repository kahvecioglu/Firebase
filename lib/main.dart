import 'dart:io';

import 'package:firebase/page/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
          apiKey: "AIzaSyC7x0CcqWQna2VZgPq1Gg9QElZH10-lnic",
          appId: "1:853285569882:android:629fcf22fa869aff9f1f63",
          messagingSenderId: "853285569882",
          projectId: "instagramkendim",
        ))
      : await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
