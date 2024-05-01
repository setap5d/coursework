// ignore_for_file: use_build_context_synchronously, no_logic_in_create_state

import 'package:flutter/material.dart';
import 'project_format.dart';
import 'project_tiles.dart';
import 'shared.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'task_page.dart';

/// Creates [_ProjectsPageState]
///
/// Has attributes [title], [email], [projectIDs], [projects], [settings], [profDetails], [activeColorScheme]
/// Attributes are taken purely to pass them to [_ProjectsPageState]
class ProjectsPage extends StatefulWidget {
  const ProjectsPage(
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
  State<ProjectsPage> createState() => _ProjectsPageState(
      title: title,
      email: email,
      projectIDs: projectIDs,
      projects: projects,
      settings: settings,
      profDetails: profDetails,
      activeColorScheme: activeColorScheme);
}

/// Builds and calls widgets that allow user to view and access projects attached to their account
/// 
/// Widgets display projects in a grid with each project represented by a [ProjectTile]
/// Has attributes [title], [email], [projectIDs], [projects], [settings], [profDetails], [activeColorScheme]
/// Defines methods: [accessProject], [deleteProject], [showAddProjectDialog], [showErrorDialog], [validateProjectDetails]
class _ProjectsPageState extends State<ProjectsPage> {
  _ProjectsPageState(
      {Key? key,
      required this.title,
      required this.email,
      required this.projectIDs,
      required this.projects,
      required this.settings,
      required this.profDetails,
      required this.activeColorScheme});
    
  final String title;
  final String email;
  final List<dynamic> projectIDs;
  final List<Project> projects;
  final Map<String, dynamic> settings;
  final List<dynamic> profDetails;
  final ColorScheme activeColorScheme;

  Future accessProject(index, project) async {
    List<dynamic> taskNames = [];
    List<dynamic> taskAssignees = [];
    List<dynamic> taskDescriptions = List.generate(100, (index) => '');
    List<DateTime?> deadlines = List.generate(100, (index) => null);
    int counter = 0;
    List<bool> isCardExpanded = [];
    FirebaseFirestore db = FirebaseFirestore.instance;
    final QuerySnapshot<Map<String, dynamic>> tasksQuery = await db
        .collection('Projects')
        .doc(widget.projectIDs[index])
        .collection('Tasks')
        .get();
    tasksQuery.docs.forEach((task) {
      if (task.id != "Placeholder Doc") {
        taskNames.add(task.id);
        taskDescriptions[counter] = task.get('Task Description');
        taskAssignees.add(task.get('Task Assignees'));
        isCardExpanded.add(false);
        if (task.get('Deadline') == null) {
          deadlines[counter] = task.get('Deadline');
        } else {
          deadlines[counter] = task.get('Deadline').toDate();
        }
        counter++;
      }
    });
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MyTasksPage(
                title: project.projectName,
                email: widget.email,
                taskNames: taskNames,
                taskAssignees: taskAssignees,
                taskDescriptions: taskDescriptions,
                deadlines: deadlines,
                counter: counter,
                isCardExpanded: isCardExpanded,
                projectID: widget.projectIDs[index],
                projects: projects,
                profDetails: profDetails,
                projectIDs: projectIDs,
                settings: settings,
                activeColorScheme: activeColorScheme,
              )),
    );
  }

  void deleteProject(project) {
    setState(() {
      widget.projects.remove(project);
    });
  }

  Future<void> showAddProjectDialog() async {
    DateTime selectedDate = DateTime.now();
    Project newProject = Project();

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Project'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  onChanged: (value) {
                    newProject.projectName = value;
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
                      newProject.deadline =
                          '${pickedDate.day} ${getMonthName(pickedDate.month)} ${pickedDate.year}';
                    }
                  },
                  child: const Text(
                    'Select Deadline',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  onChanged: (value) {
                    newProject.leader = 'Leader: $value';
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
                  if (await validateProjectDetails(newProject)) {
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
                      showErrorDialog(
                          'Failed to save project data. Please try again later.');
                    }
                  }
                }),
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

  Future<bool> validateProjectDetails(Project newProject) async {
    // Checks if the project name is empty or just has the default "Project Name"
    if (newProject.projectName.trim().isEmpty ||
        newProject.projectName.trim() == 'Project Name') {
      showErrorDialog('Please enter a valid project name.');
      return false;
    }

    // Checks if the project leader field is empty or just has the default "Leader: "
    if (newProject.leader.trim().isEmpty ||
        newProject.leader.trim() == 'Leader:') {
      showErrorDialog('Please enter a valid project leader.');
      return false;
    }

    // Checks if the project name already exists in Firebase
    final docSnapshot = await FirebaseFirestore.instance
        .collection('Projects')
        .where('Title', isEqualTo: newProject.projectName)
        .get();

    if (docSnapshot.docs.isNotEmpty) {
      showErrorDialog(
          'There is already a project with that name in the database.');
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.from(colorScheme: activeColorScheme),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(widget.title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 34)),
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 2,
                    ),
                    itemCount: widget.projects.length,
                    itemBuilder: (context, index) {
                      var project = widget.projects[index];
                      return GestureDetector(
                        onTap: () => accessProject(index, project),
                        child: ProjectTile(
                          project: project,
                          onDelete: () => deleteProject(project),
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
          onPressed: showAddProjectDialog,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          child: Icon(
            Icons.add,
            color: activeColorScheme.secondary,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
