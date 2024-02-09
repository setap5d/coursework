import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '5D Teams',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Navbar Demo'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Row(
        children: <Widget>[
          NavigationDrawer(),
          const Expanded(
            child:  Center(
              child: Text(
                'Content Area',
                style: TextStyle(fontSize: 24.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250, // Adjust width as needed
      color: Colors.grey, // Background color of the navigation drawer
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.grey,
            ),
            child: Text(
              'Navigation',
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ListTile(
                  leading:const  Icon(Icons.home),
                  onTap: () {
                    // Handle Home button tap
                  },
                ),
                ListTile(
                  leading:const  Icon(Icons.notifications),
                  onTap: () {
                    // Handle Home button tap
                  },
                ),
                ListTile(
                  leading:const  Icon(Icons.settings),
                  onTap: () {
                    // Handle Settings button tap
                  },
                ),
                // Add more ListTile widgets for additional buttons
              ],
            ),
          ),
        ],
      ),
    );
  }
}

