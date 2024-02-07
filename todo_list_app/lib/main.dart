import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'splash_screen.dart';

import 'package:hive/hive.dart';
import 'models/database.dart';

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  //  Firebase.initializeApp();

  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<Task>('mybox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: SplashScreen(), // Use SplashScreen as the initial screen
    );
  }
}
