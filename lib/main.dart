import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_18_firebase_login/firebase_options.dart';
import 'package:flutter_18_firebase_login/ui/login_screen.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_test_51NH4myFr9EinvGHT0augrvu2ig2OhjgFLvDrKUGF5U05X7Si06LmUfwEnwVTGCuF0X3MnwOmTwHEYMFfiUehrWBv00o8JHGRdD";
  await Stripe.instance.applySettings();
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
