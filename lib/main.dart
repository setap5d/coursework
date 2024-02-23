import 'package:flutter/material.dart';
import 'project_cards.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Task Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final _formKey = GlobalKey<FormState>();
  List<dynamic> taskNames = [];
  List<dynamic> taskAssignees = [];
  TextEditingController taskNameController = TextEditingController();
  TextEditingController taskAssigneesController = TextEditingController();
  List<bool> isCardExpanded = [];
  List<DateTime?> deadlines = [];

  @override
  void initState() {
    super.initState();
    isCardExpanded = [];
    deadlines = List.generate(100, (index) => null); 
  }

  Future<void> _selectDate(BuildContext context, int index) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != deadlines[index]) {
      setState(() {
        deadlines[index] = picked;
      });
    }
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
      isCardExpanded.add(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth * 0.7;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Title'),
      ),
      body: Row(
        children: [
          SizedBox(
            width: 200,
            child: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children:  <Widget>[
                  ListTile(
                    title: const Text('Item 1'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Item 2'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 700,
                width: containerWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: const Color.fromARGB(255, 170, 170, 170),
                    width: 0.5,
                  ),
                ),
                child: ListView.builder(
                  itemCount: _counter,
                  itemBuilder: (context, index) {
                    double cardHeight = isCardExpanded[index] ? 200.0 : 70.0;

                    return InkWell(
                      onTap: () {
                        setState(() {
                          isCardExpanded[index] = !isCardExpanded[index];
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: cardHeight,
                        child: ProjectCard(
                          height: cardHeight,
                          taskName: '${taskNames[index]}',
                          deadline: deadlines[index] != null
                              ? '${deadlines[index]!.day}/${deadlines[index]!.month}/${deadlines[index]!.year}'
                              : 'No Deadline Set',
                          taskAssignees: '${taskAssignees[index]}',
                          width: 300,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
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
                            controller: taskNameController,
                            decoration: const InputDecoration(
                              labelText: 'Task Name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextFormField(
                            controller: taskAssigneesController,
                            decoration: const InputDecoration(
                              labelText: 'Task Assignees',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: ElevatedButton(
                            child: const Text('Set Deadline'),
                            onPressed: () {
                              _selectDate(context, _counter);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: ElevatedButton(
                            child: const Text('Submit'),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                taskNames.add(taskNameController.text);
                                taskAssignees.add(taskAssigneesController.text);
                                _incrementCounter();
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        tooltip: 'New Task',
        child: const Icon(Icons.add),
      ),
    );
  }
}
