import 'package:flutter/material.dart';
import 'package:smartjewelry/Home.dart';
import 'package:smartjewelry/Signin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      // home:  const Text("home"),
      routes: {
        "/": (context) => Signin(),
        "/home": (context) => Home(),
        "/signup": (context) => const Text("signup")
      },
    );
  }
}