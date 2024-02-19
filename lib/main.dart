import 'package:flutter/material.dart';
import 'project_cards.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key); // Move the key parameter to the end

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
  const MyHomePage({Key? key, required this.title}) : super(key: key); // Move the key parameter to the end

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
  DateTime? selectedDeadline;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDeadline) {
      setState(() {
        selectedDeadline = picked;
      });
    }
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
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
              children: <Widget>[
                ListTile(
                  title: const Text('Item 1'),
                  onTap: () {
                    // 
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('Item 2'),
                  onTap: () {
                    //
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
              child: GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const ScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10,
                  childAspectRatio: 11.0,
                ),
                itemCount: _counter,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      // expand functionality
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: ProjectCard(
                      taskName: '${taskNames[index]}',
                      deadline: selectedDeadline != null
                          ? '${selectedDeadline!.day}/${selectedDeadline!.month}/${selectedDeadline!.year}'
                          : 'No Deadline Set',
                      taskAssignees: '${taskAssignees[index]}',
                      width: 300,
                      height: 100,
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
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextFormField(
                            controller: taskAssigneesController,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: ElevatedButton(
                            child: const Text('Set Deadline'),
                            onPressed: () {
                              _selectDate(context);
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
