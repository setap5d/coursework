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
  final _formKey = GlobalKey<FormState>();
  List<dynamic> projectNames = [];
  List<dynamic> projectLeaders = [];
  TextEditingController projectNameController = TextEditingController();
  TextEditingController projectLeaderController = TextEditingController();

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
                  projectName: '${projectNames[index]}',
                  deadline: '24/08/20',
                  projectLeader: '${projectLeaders[index]}'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                    content: Stack(
                      clipBehavior: Clip.none,
                      children: <Widget>[
                        Positioned(
                          right: -40,
                          top: -40,
                          child: InkResponse(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const CircleAvatar(
                              backgroundColor: Colors.red,
                              child: Icon(Icons.close),
                            ),
                          ),
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: TextFormField(
                                    controller: projectNameController),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: TextFormField(
                                    controller: projectLeaderController),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: ElevatedButton(
                                  child: const Text('Submit'),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      projectNames
                                          .add(projectNameController.text);
                                      projectLeaders
                                          .add(projectLeaderController.text);
                                      _incrementCounter();
                                      Navigator.of(context).pop();
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ));
        },
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