import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quiz/screens/auth/logIn.dart';
import 'package:quiz/screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mkcl Quiz',
      initialRoute: '/', // Optionally define the initial route
      routes: {
        '/': (context) => Login(), // Route for the Home screen (index page)
        '/home': (context) => Home(), // Route for the Quiz screen
        // Add more routes here if you have other screens
      },
    );
  }
}
