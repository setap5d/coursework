// ignore_for_file: no_logic_in_create_state

import 'dart:async';

import 'package:flutter/material.dart';
import 'task_cards.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Creates [_MyTasksPageState]
///
/// Has attributes [projectName], [email]. [taskNames], [taskAssignees], [taskDescriptions], [deadlines], [counter], [isCardExpanded], [profDetails], [projectID], [projectIDs], [settings], [activeColorScheme]
class MyTasksPage extends StatefulWidget {
  const MyTasksPage(
      {Key? key,
      required this.projectName,
      required this.email,
      required this.taskNames,
      required this.taskAssignees,
      required this.taskDescriptions,
      required this.deadlines,
      required this.counter,
      required this.isCardExpanded,
      required this.profDetails,
      required this.projectID,
      required this.projectIDs,
      required this.settings,
      required this.activeColorScheme})
      : super(key: key);

  final String projectName;
  final String email;
  final List<dynamic> taskNames;
  final List<dynamic> taskAssignees;
  final List<dynamic> taskDescriptions;
  final List<DateTime?> deadlines;
  final int counter;
  final List<bool> isCardExpanded;
  final String projectID;
  final List<dynamic> projectIDs;
  final List<dynamic> profDetails;
  final Map<String, dynamic> settings;
  final ColorScheme activeColorScheme;

  @override
  State<MyTasksPage> createState() => _MyTasksPageState();
}

///Builds/calls widgets to display task and ticket information attached to access project
///
///Defines methods: [addTicket], [showDialog], [addNewTask], [initState], [selectDate], [incrementCounter]
class _MyTasksPageState extends State<MyTasksPage> {
  _MyTasksPageState();
  int _counter = 0;
  final _formKey = GlobalKey<FormState>();
  TextEditingController taskNameController = TextEditingController();
  TextEditingController taskAssigneesController = TextEditingController();
  TextEditingController taskDescriptionController = TextEditingController();
  List<List<String>> ticketNamesList = [];
  List<List<String>> ticketDescriptionsList = [];
  List<bool> ticketChecked = [];

void addTicket(BuildContext context, int index) async {
    final TextEditingController ticketNameController = TextEditingController();
    final TextEditingController ticketDescriptionController = TextEditingController();

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
                child: CircleAvatar(
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a ticket name';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      controller: ticketDescriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Ticket Description',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a ticket description';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          ticketNamesList[index].add(ticketNameController.text);
                          ticketDescriptionsList[index].add(ticketDescriptionController.text);

                          FirebaseFirestore db = FirebaseFirestore.instance;
                          DocumentReference ticketRef = db
                              .collection('Projects')
                              .doc(widget.projectID)
                              .collection('Tasks')
                              .doc(widget.taskNames[index])
                              .collection('Tickets')
                              .doc(ticketNameController.text);

                          ticketRef.set({
                            "Ticket Description": ticketDescriptionController.text,
                          });

                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text('Submit'),
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

  void addNewTask(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_counter < widget.taskDescriptions.length) {
        widget.taskDescriptions[_counter] = taskDescriptionController.text;
      } else {
        widget.taskDescriptions.add(taskDescriptionController.text);
      }
      Navigator.of(context).pop();
      incrementCounter();

      FirebaseFirestore db = FirebaseFirestore.instance;
      DocumentReference taskRef = db
          .collection('Projects')
          .doc(widget.projectID)
          .collection("Tasks")
          .doc(taskNameController.text);
      taskRef.set({
        "Task Assignees": taskAssigneesController.text,
        "Task Description": taskDescriptionController.text,
        "Deadline": widget.deadlines[_counter - 1]
      });

      taskNameController.clear();
      taskAssigneesController.clear();
      taskDescriptionController.clear();
      // Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    _counter = widget.counter;
    super.initState();
    ticketNamesList = List.generate(100, (index) => []);
    ticketDescriptionsList = List.generate(100, (index) => []);
    ticketChecked = List.generate(100, (index) => false);
  }

  Future<void> selectDate(BuildContext context, int index) async {
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

  void incrementCounter() {
    setState(() {
      _counter++;
      widget.isCardExpanded.add(false);
      widget.taskNames.add(taskNameController.text);
      widget.taskAssignees.add(taskAssigneesController.text);
      widget.taskDescriptions.add(taskDescriptionController.text);
      widget.deadlines.add(null);
    });
  }

  void triggerRebuild() {
    //triggers rebuild
    setState(() {});
  }

  void decrementIndex(int index) {
    //decrements the counter when a task is deleted
    _counter--;
    triggerRebuild();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      //remove this if not fixed
      triggerRebuild.call();
    });

    return Theme(
      data: ThemeData.from(colorScheme: widget.activeColorScheme),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.projectName),
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
                      //call this to rebuild after deleting or updating a project
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
                                for (var ticket in tasksQuery.docs) {
                                  if (ticket.id != "Placeholder Doc") {
                                    ticketNamesList[index].add(ticket.id);
                                    ticketDescriptionsList[index]
                                        .add(ticket.get('Ticket Description'));
                                  }
                                }
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
                                    isCardExpanded: widget.isCardExpanded,
                                    addTicket: addTicket,
                                    index: index,
                                    activeColorScheme: widget.activeColorScheme,
                                    formKey: _formKey,
                                    deadlines: widget.deadlines,
                                    projectID: widget.projectID,
                                    counter: _counter,
                                    taskNames: widget.taskNames,
                                    taskDescriptions: widget.taskDescriptions,
                                    allTaskAssignees: widget.taskAssignees,
                                    decrementIndex: decrementIndex,
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
          backgroundColor: widget.activeColorScheme.inversePrimary,
          onPressed: () async {
            await showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: widget.activeColorScheme.background,
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
                          backgroundColor: widget.activeColorScheme.primary,
                          child: const Icon(Icons.close),
                        ),
                      ),
                    ),
                    Container(
                      color: widget.activeColorScheme.background,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TaskTextField(
                              widget: widget,
                              taskNameController: taskNameController,
                              fieldName: "Task Name",
                              errorMessage: "Please enter task name",
                            ),
                            TaskTextField(
                              widget: widget,
                              taskNameController: taskAssigneesController,
                              fieldName: "Task Assignees",
                              errorMessage: "Please enter task assignees",
                            ),
                            TaskTextField(
                              widget: widget,
                              taskNameController: taskDescriptionController,
                              fieldName: "Task Description",
                              errorMessage: "Please enter task description",
                            ),
                            TaskButtonField(
                              widget: widget,
                              text: "Set Deadline",
                              onPressed: () => selectDate(context, _counter),
                            ),
                            TaskButtonField(
                              widget: widget,
                              text: "Submit",
                              onPressed: () => addNewTask(context),
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
            color: widget.activeColorScheme.secondary,
          ),
        ),
      ),
    );
  }
}

class TaskButtonField extends StatelessWidget {
  const TaskButtonField(
      {super.key,
      required this.widget,
      required this.text,
      required this.onPressed});

  final MyTasksPage widget;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
          widget.activeColorScheme.inversePrimary,
        )),
        onPressed: onPressed,
        child: Text(text,
            style: TextStyle(color: widget.activeColorScheme.onBackground)),
      ),
    );
  }
}

class TaskTextField extends StatelessWidget {
  const TaskTextField(
      {super.key,
      required this.widget,
      required this.taskNameController,
      required this.fieldName,
      required this.errorMessage});

  final MyTasksPage widget;
  final TextEditingController taskNameController;
  final String fieldName;
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        style: TextStyle(color: widget.activeColorScheme.onBackground),
        controller: taskNameController,
        decoration: InputDecoration(
          labelStyle: TextStyle(color: widget.activeColorScheme.onBackground),
          labelText: fieldName,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return errorMessage;
          }
          return null;
        },
      ),
    );
  }
}
