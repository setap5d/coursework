import 'dart:convert';

import 'package:flutter/material.dart';
import 'projectFormat.dart';
import 'projectTiles.dart';
import 'shared.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'task_page.dart';
import 'settings.dart';

class projectsPage extends StatefulWidget {
  const projectsPage(
      {Key? key,
      required this.title,
      required this.email,
      required this.projectIDs,
      required this.projects,
      required this.settings,
      required this.profDetails,
      required this.activeColorScheme})
      : super(key: key);

  final String title;
  final String email;
  final List<dynamic> projectIDs;
  final List<Project> projects;
  final Map<String, dynamic> settings;
  final List<dynamic> profDetails;
  final ColorScheme activeColorScheme;

  @override
  State<projectsPage> createState() => _projectsPageState(
      title: title, user: email, projectIDs: projectIDs, projects: projects, settings: settings, profDetails: profDetails, activeColorScheme: activeColorScheme);
}


class _projectsPageState extends State<projectsPage> {
  //List<Project> projects = [];

    _projectsPageState({Key? key,
      required this.user,
      required this.projectIDs,
      required this.projects, 
      required this.settings, 
      required this.profDetails,
      required this.title,
      required this.activeColorScheme});

  final String user;
  final List<dynamic> projectIDs;
  final List<Project> projects;
  final Map<String, dynamic> settings;
  final List<dynamic> profDetails;
  final String title;
  final ColorScheme activeColorScheme;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.from(colorScheme: activeColorScheme),
      child: Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            widget.title,
            textAlign: TextAlign.center,
              style: TextStyle(fontSize: 34)
            ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Row(
        children: [
            // Container(
            //   width: MediaQuery.of(context).size.width * 0.05,
            //   color: Theme.of(context).colorScheme.inversePrimary,
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       // Add sidebar thing here
            //     ],
            //   ),
            // ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 2,
                  ),
                    itemCount: widget.projects.length, //item count
                    itemBuilder: (context, index) {
                    var project = widget.projects[index];
                      /* GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 2,
                  children: [
                    ...widget.projects.map((project) { */
                    return GestureDetector(
                      onTap: () async {
                        List<dynamic> taskNames = [];
                        List<dynamic> taskAssignees = [];
                        List<dynamic> taskDescriptions =
                            List.generate(100, (index) => '');
                        List<DateTime?> deadlines =
                            List.generate(100, (index) => null);
                        int _counter = 0;
                        List<bool> isCardExpanded = [];
                        FirebaseFirestore db = FirebaseFirestore.instance;
                        final QuerySnapshot<Map<String, dynamic>> tasksQuery =
                            await db
                                .collection('Projects')
                                .doc(widget.projectIDs[index])
                                .collection('Tasks')
                                .get();
                        tasksQuery.docs.forEach((task) {
                          if (task.id != "Placeholder Doc") {
                            taskNames.add(task.id);
                            taskDescriptions[_counter] =
                                task.get('Task Description');
                            taskAssignees.add(task.get('Task Assignees'));
                            isCardExpanded.add(false);
                            if (task.get('Deadline') == null) {
                              deadlines[_counter] = task.get('Deadline');
                            } else {
                              deadlines[_counter] =
                                  task.get('Deadline').toDate();
                            }
                            _counter++;
                          }
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyProjectPage(
                                    title: project.projectName,
                                    email: widget.email,
                                    taskNames: taskNames,
                                    taskAssignees: taskAssignees,
                                    taskDescriptions: taskDescriptions,
                                    deadlines: deadlines,
                                    counter: _counter,
                                    isCardExpanded: isCardExpanded,
                                    projectID: widget.projectIDs[index],
                                      projects: projects, 
                                      profDetails: profDetails, 
                                      projectIDs: projectIDs, 
                                      settings: settings,
                                      activeColorScheme: activeColorScheme,
                                  )),
                        );
                      },
                      child: ProjectTile(
                        project: project,
                        onDelete: () {
                          setState(() {
                            widget.projects.remove(project);
                          });
                        },
                        projectIDs: widget.projectIDs,
                        projectIndex: index,
                        email: widget.email,
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddProjectDialog,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          child: Icon(Icons.add, color: activeColorScheme.secondary,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  Future<void> _showAddProjectDialog() async {
    DateTime selectedDate = DateTime.now();
    Project newProject = Project();

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Project'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  onChanged: (value) {
                    newProject.projectName = value;
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
                      newProject.deadline =
                          '${pickedDate.day} ${getMonthName(pickedDate.month)} ${pickedDate.year}';
                    }
                  },
                  child: Text(
                    'Select Deadline',
                    // style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  onChanged: (value) {
                    newProject.leader = 'Leader: $value';
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
                  if (await _validateProjectDetails(newProject)) {
                    try {
                      setState(() {
                        widget.projects.add(newProject);
                      });
                      final projID = FirebaseFirestore.instance
                          .collection('Projects')
                          .doc();
                      await projID.set({
                        "Title": newProject.projectName,
                        "Deadline": newProject.deadline,
                        "Project Leader": newProject.leader,
                      });
                      widget.projectIDs.add(projID.id);
                      await FirebaseFirestore.instance
                          .collection('Profiles')
                          .doc(widget.email)
                          .update({"Project IDs": widget.projectIDs});
                      await projID
                          .collection('Tasks')
                          .doc("Placeholder Doc")
                          .set({"Title": "Placeholder"});
                      await projID
                          .collection('Tasks')
                          .doc("Placeholder Doc")
                          .collection('Tickets')
                          .doc('Placeholder Doc')
                          .set({"Title": "Placeholder"});
                      Navigator.of(context).pop();
                    } catch (e) {
                      _showErrorDialog(
                          'Failed to save project data. Please try again later.');
                    }
                  }
                }),
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

  Future<bool> _validateProjectDetails(Project newProject) async {
    // Checks if the project name is empty or just has the default "Project Name"
    if (newProject.projectName.trim().isEmpty ||
        newProject.projectName.trim() == 'Project Name') {
      _showErrorDialog('Please enter a valid project name.');
      return false;
    }

    // Checks if the project leader field is empty or just has the default "Leader: "
    if (newProject.leader.trim().isEmpty ||
        newProject.leader.trim() == 'Leader:') {
      _showErrorDialog('Please enter a valid project leader.');
      return false;
    }

    // Checks if the project name already exists in Firebase
    final docSnapshot = await FirebaseFirestore.instance
        .collection('Projects')
        .where('Title', isEqualTo: newProject.projectName)
        .get();

    if (docSnapshot.docs.isNotEmpty) {
      _showErrorDialog(
          'There is already a project with that name in the database.');
      return false;
    }

    return true;
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
}
