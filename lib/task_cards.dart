import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Creates widget used to display task/tickets to user in more organised format
///
/// Defines method: [handleMenuSelection]
class TaskCard extends StatefulWidget {
  final String taskName;
  final String deadline;
  final String taskAssignees;
  final String taskDescription;
  final List<String> ticketNames;
  final double width;
  final double height;
  final List<bool> isCardExpanded;
  final Function(BuildContext context, int index) addTicket;
  final int index;
  final ColorScheme activeColorScheme;
  final dynamic formKey;
  final List<DateTime?> deadlines;
  final String projectID;
  final int counter;
  final List<dynamic> taskNames;
  final List<dynamic> taskDescriptions;
  final List<dynamic> allTaskAssignees;
  final Function(int) decrementIndex;

  const TaskCard({
    Key? key,
    required this.taskName,
    required this.deadline,
    required this.taskAssignees,
    required this.taskDescription,
    required this.ticketNames,
    required this.width,
    required this.height,
    required this.isCardExpanded,
    required this.addTicket,
    required this.index,
    required this.activeColorScheme,
    required this.formKey,
    required this.deadlines,
    required this.projectID,
    required this.counter,
    required this.taskNames,
    required this.taskDescriptions,
    required this.allTaskAssignees,
    required this.decrementIndex,
  }) : super(key: key);

  @override
  State<TaskCard> createState() => _MyTasksPageState();
}

class _MyTasksPageState extends State<TaskCard> {
  _MyTasksPageState();
  TextEditingController taskNameController = TextEditingController();
  TextEditingController taskAssigneesController = TextEditingController();
  TextEditingController taskDescriptionController = TextEditingController();

  void handleMenuSelection(String value) {
    if (value == 'Edit') {
      showTaskEditDialog(context);
    } else if (value == 'Delete') {
      showTaskDeleteDialog(context);
    } else if (value == 'Add Assignee') {
      showTaskAssigneeDialog(context);
    }
  }

  void updateAssignees(BuildContext context) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference taskRef = db
        .collection('Projects')
        .doc(widget.projectID)
        .collection("Tasks")
        .doc(widget.taskNames[widget.index]);
    taskRef.update({
      "Task Assignees": taskAssigneesController.text,
    });
    widget.allTaskAssignees[widget.index] = (taskAssigneesController.text);
    taskAssigneesController.clear();
    Navigator.of(context).pop();
  }

  void updateTask(BuildContext context) async {
    if (widget.formKey.currentState!.validate()) {
      widget.formKey.currentState!.save();
      if (widget.counter < widget.taskDescriptions.length) {
        widget.taskDescriptions[widget.counter] =
            taskDescriptionController.text;
      } else {
        widget.taskDescriptions[widget.index] =
            (taskDescriptionController.text);
      }
      Navigator.of(context).pop();

      FirebaseFirestore db = FirebaseFirestore.instance;

      if (widget.taskNames[widget.index] != taskNameController.text) {
        DocumentReference newTaskRef = db
            .collection('Projects')
            .doc(widget.projectID)
            .collection("Tasks")
            .doc(taskNameController.text);
        final QuerySnapshot<Map<String, dynamic>> tasksQuery = await db
            .collection('Projects')
            .doc(widget.projectID)
            .collection('Tasks')
            .doc(widget.taskNames[widget.index])
            .collection('Tickets')
            .get();
        for (var ticket in tasksQuery.docs) {
          newTaskRef.collection('Tickets').doc(ticket.id).set(ticket.data());
        }
        DocumentReference taskRef = db
            .collection('Projects')
            .doc(widget.projectID)
            .collection("Tasks")
            .doc(widget.taskNames[widget.index]);
        await taskRef.delete();
        incrementCounter();
        newTaskRef.set({
          "Task Assignees": "",
          "Task Description": taskDescriptionController.text,
          "Deadline": widget.deadlines[widget.index]
        });
      } else {
        DocumentReference taskRef = db
            .collection('Projects')
            .doc(widget.projectID)
            .collection("Tasks")
            .doc(taskNameController.text);
        taskRef.update({
          "Task Assignees": "",
          "Task Description": taskDescriptionController.text,
          "Deadline": widget.deadlines[widget.index]
        });
      }

      taskNameController.clear();
      taskDescriptionController.clear();
    }
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
      //widget.isCardExpanded[widget.index] = false;
      widget.taskNames[widget.index] = (taskNameController.text);
      widget.taskDescriptions[widget.index] = (taskDescriptionController.text);
      widget.deadlines.add(null);
    });
  }

  Future<void> showTaskAssigneeDialog(BuildContext context) async {
    taskAssigneesController = TextEditingController(text: widget.taskAssignees);
    return showDialog<void>(
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
                key: widget.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TaskTextField(
                      taskNameController: taskAssigneesController,
                      fieldName: "Task Assignees",
                      activeColorScheme: widget.activeColorScheme,
                    ),
                    TaskButtonField(
                      text: "Submit",
                      onPressed: () => updateAssignees(context),
                      activeColorScheme: widget.activeColorScheme,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showTaskDeleteDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                FirebaseFirestore db = FirebaseFirestore.instance;
                DocumentReference taskRef = db
                    .collection('Projects')
                    .doc(widget.projectID)
                    .collection("Tasks")
                    .doc(widget.taskNames[widget.index]);
                await taskRef.delete();
                widget.taskNames.removeAt(widget.index);
                widget.allTaskAssignees.removeAt(widget.index);
                widget.taskDescriptions.removeAt(widget.index);
                widget.deadlines.removeAt(widget.index);
                widget.decrementIndex(widget.index);
                //add post frame callback here
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showTaskEditDialog(BuildContext context) async {
    taskDescriptionController =
        TextEditingController(text: widget.taskDescription);
    taskNameController = TextEditingController(text: widget.taskName);

    return showDialog<void>(
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
                key: widget.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TaskTextField(
                      taskNameController: taskNameController,
                      fieldName: "Task Name",
                      activeColorScheme: widget.activeColorScheme,
                    ),
                    TaskTextField(
                      taskNameController: taskDescriptionController,
                      fieldName: "Task Description",
                      activeColorScheme: widget.activeColorScheme,
                    ),
                    TaskButtonField(
                      text: "Set Deadline",
                      onPressed: () => selectDate(context, widget.index),
                      activeColorScheme: widget.activeColorScheme,
                    ),
                    TaskButtonField(
                      text: "Submit",
                      onPressed: () => updateTask(context),
                      activeColorScheme: widget.activeColorScheme,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.from(colorScheme: widget.activeColorScheme),
      child: Expanded(
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: const Color.fromARGB(255, 170, 170, 170),
                    width: 0.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Task Name: ${widget.taskName}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                              overflow: widget.isCardExpanded[widget.index]
                                  ? null
                                  : TextOverflow.ellipsis,
                            ),
                            Text(
                              'Task Assignees: ${widget.taskAssignees}',
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                              overflow: widget.isCardExpanded[widget.index]
                                  ? null
                                  : TextOverflow.ellipsis,
                            ),
                            Visibility(
                              visible: widget.isCardExpanded[widget.index],
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Task Description: ${widget.taskDescription}',
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Display ticket names here
                                  if (widget.ticketNames.isNotEmpty)
                                    ...widget.ticketNames
                                        .map((ticketName) => Text(
                                              'Ticket: $ticketName',
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )),
                                ],
                              ),
                            ),
                            if (widget.isCardExpanded[widget.index])
                              const Spacer(),
                            if (widget.isCardExpanded[widget.index])
                              ElevatedButton(
                                onPressed: () {
                                  widget.addTicket(context, widget.index);
                                },
                                child: const Text('Add Ticket'),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: SizedBox(
                        width: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Deadline',
                              style: TextStyle(
                                color: widget.activeColorScheme.onBackground,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              widget.deadline,
                              style: TextStyle(
                                color: widget.activeColorScheme.onBackground,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              child: PopupMenuButton<String>(
                onSelected: handleMenuSelection,
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem<String>(
                    value: 'Edit',
                    child: Text('Edit'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Delete',
                    child: Text('Delete'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Add Assignee',
                    child: Text('Add Assignee'),
                  ),
                ],
                icon: const Icon(Icons.more_vert),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskButtonField extends StatelessWidget {
  const TaskButtonField(
      {super.key,
      required this.text,
      required this.onPressed,
      required this.activeColorScheme});

  final String text;
  final VoidCallback onPressed;
  final ColorScheme activeColorScheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
          activeColorScheme.inversePrimary,
        )),
        onPressed: onPressed,
        child:
            Text(text, style: TextStyle(color: activeColorScheme.onBackground)),
      ),
    );
  }
}

class TaskTextField extends StatelessWidget {
  const TaskTextField(
      {super.key,
      required this.taskNameController,
      required this.fieldName,
      required this.activeColorScheme});

  final TextEditingController taskNameController;
  final String fieldName;
  final ColorScheme activeColorScheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        style: TextStyle(color: activeColorScheme.onBackground),
        controller: taskNameController,
        decoration: InputDecoration(
          labelStyle: TextStyle(color: activeColorScheme.onBackground),
          labelText: fieldName,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
