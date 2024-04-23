import 'package:flutter/material.dart';
import 'task_cards.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      //home: const MyProjectPage(
      //title: 'Flutter Demo Task Page'),
    );
  }
}

class MyProjectPage extends StatefulWidget {
  const MyProjectPage(
      {Key? key,
      required this.title,
      required this.email,
      required this.taskNames,
      required this.taskAssignees,
      required this.taskDescriptions,
      required this.deadlines,
      required this.counter,
      required this.isCardExpanded,
      required this.projectID})
      : super(key: key);

  final String title;
  final String email;
  final List<dynamic> taskNames;
  final List<dynamic> taskAssignees;
  final List<dynamic> taskDescriptions;
  final List<DateTime?> deadlines;
  final int counter;
  final List<bool> isCardExpanded;
  final String projectID;

  @override
  State<MyProjectPage> createState() => _MyProjectPageState(projectName: title);
}

class _MyProjectPageState extends State<MyProjectPage> {
  _MyProjectPageState({Key? key, required this.projectName});
  int _counter = 0;
  final String projectName;
  final _formKey = GlobalKey<FormState>();
  //List<dynamic> taskNames = [];
  //List<dynamic> taskAssignees = [];
  //List<dynamic> taskDescriptions = [];
  TextEditingController taskNameController = TextEditingController();
  TextEditingController taskAssigneesController = TextEditingController();
  TextEditingController taskDescriptionController = TextEditingController();
  //List<bool> isCardExpanded = [];
  //List<DateTime?> deadlines = [];
  List<List<String>> ticketNamesList = [];
  List<List<String>> ticketDescriptionsList = [];
  List<bool> ticketChecked = [];

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
                          FirebaseFirestore db = FirebaseFirestore.instance;
                          DocumentReference ticketRef = db
                              .collection('Projects')
                              .doc(widget.projectID)
                              .collection('Tasks')
                              .doc(widget.taskNames[index])
                              .collection('Tickets')
                              .doc(ticketNameController.text);
                          ticketRef.set({
                            "Ticket Description":
                                ticketDescriptionController.text,
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
    _counter = widget.counter;
    super.initState();
    //isCardExpanded = [];
    //deadlines = List.generate(100, (index) => null);
    //taskDescriptions = List.generate(100, (index) => '');
    ticketNamesList = List.generate(100, (index) => []);
    ticketDescriptionsList = List.generate(100, (index) => []);
    ticketChecked = List.generate(100, (index) => false);
  }

  Future<void> _selectDate(BuildContext context, int index) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != widget.deadlines[index]) {
      setState(() {
        widget.deadlines[index] = picked;
      });
    }
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
      widget.isCardExpanded.add(false);
      widget.taskNames.add(taskNameController.text);
      widget.taskAssignees.add(taskAssigneesController.text);
      widget.taskDescriptions.add(taskDescriptionController.text);
      widget.deadlines.add(null);
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
                      //Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Item 2'),
                    onTap: () {
                      //Navigator.pop(context);
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
                      double cardHeight =
                          widget.isCardExpanded[index] ? 300.0 : 70.0;
                      return Container(
                        constraints: BoxConstraints(maxHeight: cardHeight),
                        child: InkWell(
                          onTap: () async {
                            if (ticketChecked[index] == false) {
                              FirebaseFirestore db = FirebaseFirestore.instance;
                              final QuerySnapshot<Map<String, dynamic>>
                                  tasksQuery = await db
                                      .collection('Projects')
                                      .doc(widget.projectID)
                                      .collection('Tasks')
                                      .doc(widget.taskNames[index])
                                      .collection('Tickets')
                                      .get();
                              tasksQuery.docs.forEach((ticket) {
                                if (ticket.id != "Placeholder Doc") {
                                  ticketNamesList[index].add(ticket.id);
                                  ticketDescriptionsList[index]
                                      .add(ticket.get('Ticket Description'));
                                }
                              });
                              ticketChecked[index] = true;
                              await Future.delayed(
                                  const Duration(milliseconds: 100));
                            }
                            setState(() {
                              widget.isCardExpanded[index] =
                                  !widget.isCardExpanded[index];
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 0),
                            height: cardHeight,
                            child: Column(
                              children: [
                                TaskCard(
                                  height: cardHeight,
                                  taskName: '${widget.taskNames[index]}',
                                  deadline: widget.deadlines[index] != null
                                      ? '${widget.deadlines[index]!.day}/${widget.deadlines[index]!.month}/${widget.deadlines[index]!.year}'
                                      : 'No Deadline Set',
                                  taskAssignees:
                                      '${widget.taskAssignees[index]}',
                                  taskDescription:
                                      '${widget.taskDescriptions[index]}',
                                  ticketNames: ticketNamesList[index],
                                  width: 300,
                                  isCardExpanded: widget.isCardExpanded[index],
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
                                if (_counter < widget.taskDescriptions.length) {
                                  widget.taskDescriptions[_counter] =
                                      taskDescriptionController.text;
                                } else {
                                  widget.taskDescriptions
                                      .add(taskDescriptionController.text);
                                }
                                Navigator.of(context).pop();
                                _incrementCounter();

                                FirebaseFirestore db =
                                    FirebaseFirestore.instance;
                                DocumentReference taskRef = db
                                    .collection('Projects')
                                    .doc(widget.projectID)
                                    .collection("Tasks")
                                    .doc(taskNameController.text);
                                taskRef.set({
                                  "Task Assignees":
                                      taskAssigneesController.text,
                                  "Task Description":
                                      taskDescriptionController.text,
                                  "Deadline": widget.deadlines[_counter - 1]
                                });
                                //_incrementCounter();

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
