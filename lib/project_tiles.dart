// projectTiles.dart

// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'project_format.dart';
import 'shared.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Creates [_ProjectTileState]
///
/// Has attributes [project], [onDelete], [projectIDs], [projectIndex], [email]
class ProjectTile extends StatefulWidget {
  final Project project;
  final VoidCallback onDelete;
  final List<dynamic> projectIDs;
  final int projectIndex;
  final String email;

  const ProjectTile({
    Key? key,
    required this.project,
    required this.onDelete,
    required this.projectIDs,
    required this.projectIndex,
    required this.email,
  }) : super(key: key);

  @override
  _ProjectTileState createState() => _ProjectTileState();
}

/// Builds widget to display [Project] information to the user
/// 
/// Defines methods: [showAddAssigneesDialog], [showErrorDialog], [showEditDialog]
class _ProjectTileState extends State<ProjectTile> {

  Future<void> showAddAssigneesDialog(BuildContext context) async {
    TextEditingController emailController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Assignees'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add'),
              onPressed: () async {
                String enteredEmail = emailController.text.trim();
                if (enteredEmail.isEmpty) {
                  showErrorDialog('Please enter an email.');
                  return;
                }

                bool alreadyAssignee = false;
                final otherUserRef = await FirebaseFirestore.instance
                    .collection('Profiles')
                    .doc(enteredEmail)
                    .get();
                if (!otherUserRef.exists) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: const Text("Email doesn't exist"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  // Email exists, proceed with adding assignee
                  List<dynamic> emailProjectIDs =
                      otherUserRef.get('Project IDs');
                  for (int i = 0; i < emailProjectIDs.length; i++) {
                    if (emailProjectIDs[i] ==
                        widget.projectIDs[widget.projectIndex]) {
                      alreadyAssignee = true;
                      break;
                    }
                  }
                  if (!alreadyAssignee) {
                    // Add the project ID to the other user's profile
                    emailProjectIDs.add(widget.projectIDs[widget.projectIndex]);
                    await FirebaseFirestore.instance
                        .collection('Profiles')
                        .doc(enteredEmail)
                        .update({"Project IDs": emailProjectIDs});
                    Navigator.of(context).pop();
                  } else {
                    // User is already an assignee
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: const Text("User is already an assignee"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                }
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showEditDialog(BuildContext context) async {
    DateTime selectedDate = DateTime.now();

    TextEditingController projectNameController =
        TextEditingController(text: widget.project.projectName);
    TextEditingController leaderController =
        TextEditingController(text: widget.project.leader.split(": ").last);

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Project'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: projectNameController,
                  onChanged: (value) {
                    widget.project.projectName = value;
                  },
                  decoration: const InputDecoration(labelText: 'Project Name'),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Deadline:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                TextButton(
                  onPressed: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );

                    if (pickedDate != null && pickedDate != selectedDate) {
                      selectedDate = pickedDate;

                      widget.project.deadline =
                          '${pickedDate.day} ${getMonthName(pickedDate.month)} ${pickedDate.year}';
                    }
                  },
                  child: Text(
                    'Select Deadline',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: leaderController,
                  onChanged: (value) {
                    widget.project.leader = 'Leader: $value';
                  },
                  decoration: const InputDecoration(labelText: 'Leader'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Save'),
              onPressed: () async {
                // Check if the edited project name is empty or already exists
                if (widget.project.projectName.trim().isEmpty ||
                    widget.project.projectName.trim() == 'Project Name') {
                  showErrorDialog('Please enter a valid project name.');
                  return;
                }

                // Check if the edited project name already exists in Firebase
                final docSnapshot = await FirebaseFirestore.instance
                    .collection('Projects')
                    .where('Title', isEqualTo: widget.project.projectName)
                    .get();

                if (docSnapshot.docs.isNotEmpty &&
                    docSnapshot.docs.first.id !=
                        widget.projectIDs[widget.projectIndex]) {
                  showErrorDialog(
                      'There is already a project with that name in the database.');
                  return;
                }

                final projID = FirebaseFirestore.instance
                    .collection('Projects')
                    .doc(widget.projectIDs[widget.projectIndex]);
                projID.update({
                  "Title": widget.project.projectName,
                  "Deadline": widget.project.deadline,
                  "Project Leader": widget.project.leader
                });
                setState(() {});
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.inversePrimary,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    'Project Name: ${widget.project.projectName}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Deadline: ${widget.project.deadline}',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    widget.project.leader,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (String value) {
                if (value == 'remove') {
                  showDeleteConfirmationDialog(context, widget.onDelete,
                      widget.projectIDs, widget.projectIndex, widget.email);
                } else if (value == 'edit') {
                  showEditDialog(context);
                } else if (value == 'add_assignees') {
                  showAddAssigneesDialog(context);
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'edit',
                  child: ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('Edit'),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'archive',
                  child: ListTile(
                    leading: Icon(Icons.archive),
                    title: Text('Archive'),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'remove',
                  child: ListTile(
                    leading: Icon(Icons.delete),
                    title: Text('Remove'),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'add_assignees',
                  child: ListTile(
                    leading: Icon(Icons.person_add),
                    title: Text('Add Assignees'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
