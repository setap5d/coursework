import 'package:flutter/material.dart';
import 'task_cards.dart';

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
      home: const MyProjectPage(title: 'Flutter Demo Task Page'),
    );
  }
}

class MyProjectPage extends StatefulWidget {
  const MyProjectPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyProjectPage> createState() => _MyProjectPageState(projectName: title);
}

class _MyProjectPageState extends State<MyProjectPage> {
  _MyProjectPageState({Key? key, required this.projectName});

  final String projectName;

  int _counter = 0;
  final _formKey = GlobalKey<FormState>();
  List<dynamic> taskNames = [];
  List<dynamic> taskAssignees = [];
  List<dynamic> taskDescriptions = [];
  TextEditingController taskNameController = TextEditingController();
  TextEditingController taskAssigneesController = TextEditingController();
  TextEditingController taskDescriptionController = TextEditingController();
  List<bool> isCardExpanded = [];
  List<DateTime?> deadlines = [];
  List<List<String>> ticketNamesList = [];
  List<List<String>> ticketDescriptionsList = [];

  void _addTicket(BuildContext context, int index) async {
    TextEditingController ticketNameController = TextEditingController();
    TextEditingController ticketDescriptionController = TextEditingController();

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
                      controller: ticketNameController,
                      decoration: const InputDecoration(
                        labelText: 'Ticket Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton(
                      child: const Text('Submit'),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          setState(() {
                            ticketNamesList[index]
                                .add(ticketNameController.text);
                            ticketDescriptionsList[index]
                                .add(ticketDescriptionController.text);
                          });
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
  }

  @override
  void initState() {
    super.initState();
    isCardExpanded = [];
    deadlines = List.generate(100, (index) => null);
    taskDescriptions = List.generate(100, (index) => '');
    ticketNamesList = List.generate(100, (index) => []);
    ticketDescriptionsList = List.generate(100, (index) => []);
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
      taskNames.add(taskNameController.text);
      taskAssignees.add(taskAssigneesController.text);
      taskDescriptions.add(taskDescriptionController.text);
      deadlines.add(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth * 0.7;

    return Scaffold(
      appBar: AppBar(
        title: Text(projectName),
        // automaticallyImplyLeading: false,
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
              Expanded(
                child: Container(
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
                      double cardHeight = isCardExpanded[index] ? 300.0 : 70.0;
                      return Container(
                        constraints: BoxConstraints(maxHeight: cardHeight),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isCardExpanded[index] = !isCardExpanded[index];
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 0),
                            height: cardHeight,
                            child: Column(
                              children: [
                                TaskCard(
                                  height: cardHeight,
                                  taskName: '${taskNames[index]}',
                                  deadline: deadlines[index] != null
                                      ? '${deadlines[index]!.day}/${deadlines[index]!.month}/${deadlines[index]!.year}'
                                      : 'No Deadline Set',
                                  taskAssignees: '${taskAssignees[index]}',
                                  taskDescription: '${taskDescriptions[index]}',
                                  ticketNames: ticketNamesList[index],
                                  width: 300,
                                  isCardExpanded: isCardExpanded[index],
                                  addTicket: _addTicket,
                                  index: index,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
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
                          child: TextFormField(
                            controller: taskDescriptionController,
                            decoration: const InputDecoration(
                              labelText: 'Task Description',
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
                                if (_counter < taskDescriptions.length) {
                                  taskDescriptions[_counter] =
                                      taskDescriptionController.text;
                                } else {
                                  taskDescriptions
                                      .add(taskDescriptionController.text);
                                }
                                _incrementCounter();

                                taskNameController.clear();
                                taskAssigneesController.clear();
                                taskDescriptionController.clear();
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
