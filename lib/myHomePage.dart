import 'package:flutter/material.dart';
import 'projectFormat.dart';
import 'projectTiles.dart';
import 'shared.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Project> projects = [];

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
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 2,
                children: [
                  ...projects.map((project) {
                    return ProjectTile(
                      project: project,
                      onDelete: () {
                        setState(() {
                          projects.remove(project);
                        });
                      },
                    );
                  }).toList(),
                ],
              ),
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
              onPressed: () {
                setState(() {
                  projects.add(newProject);
                });
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
