import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_18_firebase_login/firebase_options.dart';
import 'package:flutter_18_firebase_login/screens/login_screen.dart';
import 'package:flutter_18_firebase_login/screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My account',
      theme: ThemeData(primarySwatch: Colors.grey),
      home: LoginWidget(),
      //ProfileWidget(),
    );
  }
}
