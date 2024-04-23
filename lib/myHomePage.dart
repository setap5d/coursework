import 'dart:convert';

import 'package:flutter/material.dart';
import 'projectFormat.dart';
import 'projectTiles.dart';
import 'shared.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'task_page.dart';

class projectsPage extends StatefulWidget {
  const projectsPage(
      {Key? key,
      required this.title,
      required this.email,
      required this.projectIDs,
      required this.projects})
      : super(key: key);

  final String title;
  final String email;
  final List<dynamic> projectIDs;
  final List<Project> projects;

  @override
  State<projectsPage> createState() => _projectsPageState();
}

class _projectsPageState extends State<projectsPage> {
  //List<Project> projects = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            widget.title,
            textAlign: TextAlign.center,
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.05,
            color: Theme.of(context).colorScheme.inversePrimary,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Add sidebar thing here
              ],
            ),
          ),
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
                  itemBuilder: (conext, index) {
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
                  }), //.toList()
              //],
              //),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddProjectDialog,
        backgroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
                    style: TextStyle(color: Theme.of(context).primaryColor),
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
                setState(() {
                  widget.projects.add(newProject);
                });
                final projID =
                    FirebaseFirestore.instance.collection('Projects').doc();
                projID.set({
                  "Title": newProject.projectName,
                  "Deadline": newProject.deadline,
                  "Project Leader": newProject.leader
                });
                widget.projectIDs.add(projID.id);
                await FirebaseFirestore.instance
                    .collection('Profiles')
                    .doc(widget.email)
                    .update({"Project IDs": widget.projectIDs});
                projID
                    .collection('Tasks')
                    .doc("Placeholder Doc")
                    .set({"Title": "Placeholder"});
                projID
                    .collection('Tasks')
                    .doc("Placeholder Doc")
                    .collection('Tickets')
                    .doc('Placeholder Doc')
                    .set({"Title": "Placeholder"});
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
