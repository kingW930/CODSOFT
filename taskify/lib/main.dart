import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskify/pages/addtolist.dart';
import 'package:taskify/pages/homepage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taskify/pages/timeofday.dart';
import 'package:taskify/pages/todolist.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TodolistAdapter());
  Hive.registerAdapter(TimeofdayAdapter());
  await Hive.openBox<Todolist>('tasks'); 
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
      routes: {
        '/addtolist': (bcontext) => const AddToList(),
        '/homepage': (context) => const HomePage(),
      },
    );
  }
}


// Splash Screen that shows the app's logo or name on launch
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Adding a delay before navigating to the homepage
    Future.delayed(const Duration(seconds: 3), () {
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed(
            '/homepage');
      }
    });

    return const Scaffold(
      body: Center(
        child: Row( 
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Icon(Icons.notes_rounded, size: 60 , color: Colors.blueAccent, )),
            Center(
              child: Text(
                'Taskify',
                style: TextStyle(
                  fontSize: 75,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
