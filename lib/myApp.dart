// Creates/Initialises Projects Page

import 'package:flutter/material.dart';
import 'myHomePage.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Projects',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'My Projects'),
      debugShowCheckedModeBanner: false,
    );
  }
}
