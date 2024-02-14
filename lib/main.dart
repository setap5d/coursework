import 'package:flutter/material.dart';
import 'project_cards.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
        shrinkWrap: false,
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 20,
          mainAxisSpacing: 15,
          childAspectRatio: 1.2,
        ),
        itemCount: _counter, //item count
        itemBuilder: (conext, index) {
          //builds the page dynamically
          return InkWell(
              onTap: () {
                //opens project
                print(index + 1);
              },
              borderRadius: BorderRadius.circular(30),
              child: ProjectCard(
                  projectName: 'project ${index + 1}',
                  deadline: '24/08/20',
                  projectLeader: 'jermey'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'New Project',
        child: const Icon(Icons.add),
      ),
    );
  }
}

/* add:
3 buttons on bottom with options
shadows on boxes
space for sidebar
popup for adding a new project
*/