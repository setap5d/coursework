// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'task_cards.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'project_format.dart';

class MyTasksPage extends StatefulWidget {
  const MyTasksPage(
      {Key? key,
      required this.title,
      required this.email,
      required this.taskNames,
      required this.taskAssignees,
      required this.taskDescriptions,
      required this.deadlines,
      required this.counter,
      required this.isCardExpanded,
      required this.projects,
      required this.profDetails,
      required this.projectID,
      required this.projectIDs,
      required this.settings,
      required this.activeColorScheme})
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
  final List<dynamic> projectIDs;
  final List<Project> projects;
  final List<dynamic> profDetails;
  final Map<String, dynamic> settings;
  final ColorScheme activeColorScheme;

  @override
  State<MyTasksPage> createState() => _MyTasksPageState(
      projectName: title,
      user: email,
      projectIDs: projectIDs,
      projects: projects,
      settings: settings,
      profDetails: profDetails,
      activeColorScheme: activeColorScheme);
}

class _MyTasksPageState extends State<MyTasksPage> {
  _MyTasksPageState(
      {required this.projectName,
      required this.user,
      required this.projectIDs,
      required this.projects,
      required this.settings,
      required this.profDetails,
      required this.activeColorScheme});
  int _counter = 0;
  final String projectName;
  final String user;
  final List<dynamic> projectIDs;
  final List<Project> projects;
  final Map<String, dynamic> settings;
  final List<dynamic> profDetails;
  final ColorScheme activeColorScheme;
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

    return Theme(
      data: ThemeData.from(colorScheme: activeColorScheme),
      child: Scaffold(
        appBar: AppBar(
          title: Text(projectName),
          // automaticallyImplyLeading: false,
        ),
        body: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    height: 700,
                    width: screenWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.inversePrimary,
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
                                FirebaseFirestore db =
                                    FirebaseFirestore.instance;
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
                                    isCardExpanded:
                                        widget.isCardExpanded[index],
                                    addTicket: _addTicket,
                                    index: index,
                                    activeColorScheme: activeColorScheme,
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
          backgroundColor: activeColorScheme.inversePrimary,
          onPressed: () async {
            await showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: activeColorScheme.background,
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
                        child: CircleAvatar(
                          backgroundColor: activeColorScheme.primary,
                          child: const Icon(Icons.close),
                        ),
                      ),
                    ),
                    Container(
                      color: activeColorScheme.background,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: TextFormField(
                                style: TextStyle(
                                    color: activeColorScheme.onBackground),
                                controller: taskNameController,
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(
                                      color: activeColorScheme.onBackground),
                                  labelText: 'Task Name',
                                  border: const OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a task name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: TextFormField(
                                style: TextStyle(
                                    color: activeColorScheme.onBackground),
                                controller: taskAssigneesController,
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(
                                      color: activeColorScheme.onBackground),
                                  labelText: 'Task Assignees',
                                  border: const OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter task assignees';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: TextFormField(
                                style: TextStyle(
                                    color: activeColorScheme.onBackground),
                                controller: taskDescriptionController,
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(
                                      color: activeColorScheme.onBackground),
                                  labelText: 'Task Description',
                                  border: const OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a task description';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                  activeColorScheme.inversePrimary,
                                )),
                                child: Text('Set Deadline',
                                    style: TextStyle(
                                        color: activeColorScheme.onBackground)),
                                onPressed: () {
                                  _selectDate(context, _counter);
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                  activeColorScheme.inversePrimary,
                                )),
                                child: Text('Submit',
                                    style: TextStyle(
                                        color: activeColorScheme.onBackground)),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    if (_counter <
                                        widget.taskDescriptions.length) {
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
                    ),
                  ],
                ),
              ),
            );
          },
          tooltip: 'New Task',
          child: Icon(
            Icons.add,
            color: activeColorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
