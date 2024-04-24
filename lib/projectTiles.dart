// projectTiles.dart

import 'package:flutter/material.dart';
import 'projectFormat.dart';
import 'shared.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

class _ProjectTileState extends State<ProjectTile> {
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
                    style: TextStyle(fontWeight: FontWeight.bold),
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
              icon: Icon(Icons.more_vert),
              onSelected: (String value) {
                if (value == 'remove') {
                  showDeleteConfirmationDialog(context, widget.onDelete,
                      widget.projectIDs, widget.projectIndex, widget.email);
                } else if (value == 'edit') {
                  _showEditDialog(context);
                } else if (value == 'add_assignees') {
                  _showAddAssigneesDialog(context);
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

  Future<void> _showAddAssigneesDialog(BuildContext context) async {
    TextEditingController emailController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Assignees'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Add'),
              onPressed: () async {
                List<dynamic> emailProjectIDs;
                bool alreadyAssignee = false;
                final otherUserRef = await FirebaseFirestore.instance
                    .collection('Profiles')
                    .doc(emailController.text)
                    .get();
                if (otherUserRef.exists == false) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text("Email doesn't exist"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  emailProjectIDs = otherUserRef.get('Project IDs');
                  for (int i = 0; i < emailProjectIDs.length; i++) {
                    if (emailProjectIDs[i] ==
                        widget.projectIDs[widget.projectIndex]) {
                      alreadyAssignee = true;
                    }
                  }
                  if (alreadyAssignee != true) {
                    emailProjectIDs.add(widget.projectIDs[widget.projectIndex]);
                    await FirebaseFirestore.instance
                        .collection('Profiles')
                        .doc(emailController.text)
                        .update({"Project IDs": emailProjectIDs});
                    Navigator.of(context).pop();
                    // where adding the email to the specified project functionality would go
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text("User is already assignee"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
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
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditDialog(BuildContext context) async {
    DateTime selectedDate = DateTime.now();

    TextEditingController projectNameController =
        TextEditingController(text: widget.project.projectName);
    TextEditingController leaderController =
        TextEditingController(text: widget.project.leader.split(": ").last);

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Project'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: projectNameController,
                  onChanged: (value) {
                    widget.project.projectName = value;
                  },
                  decoration: InputDecoration(labelText: 'Project Name'),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Deadline:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
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
                SizedBox(height: 16.0),
                TextField(
                  controller: leaderController,
                  onChanged: (value) {
                    widget.project.leader = 'Leader: $value';
                  },
                  decoration: InputDecoration(labelText: 'Leader'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Save'),
              onPressed: () async {
                // Check if the edited project name is empty or already exists
                if (widget.project.projectName.trim().isEmpty ||
                    widget.project.projectName.trim() == 'Project Name') {
                  _showErrorDialog('Please enter a valid project name.');
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
                  _showErrorDialog(
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
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
