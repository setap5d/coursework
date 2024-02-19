import 'package:flutter/material.dart';

class ProjectCard extends StatelessWidget {
  final String taskName;
  final String deadline;
  final String taskAssignees;
  final double width;
  final double height;

  const ProjectCard({
    Key? key,
    required this.taskName,
    required this.deadline,
    required this.taskAssignees,
    required this.width,
    required this.height,
  }) : super(key: key);

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'Edit':
        // Handle edit action
        break;
      case 'Delete':
        // Handle delete action
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: const Color.fromARGB(255, 170, 170, 170),
                width: 0.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Task Name: $taskName',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        'Task Assignees: $taskAssignees',
                        style: const TextStyle(
                          fontSize: 15, 
                        )
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.0), // Right top corner
                      bottomRight: Radius.circular(10.0), // Right bottom corner
                    ),
                    color: Color.fromARGB(255, 213, 213, 213),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Deadline',
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.bold,
                          fontSize: 15, 
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        deadline,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ],
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
            onSelected: _handleMenuSelection,
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'Edit',
                child: Text('Edit'),
              ),
              const PopupMenuItem<String>(
                value: 'Delete',
                child: Text('Delete'),
              ),
            ],
            icon: const Icon(Icons.more_vert),
          ),
        ),
      ],
    );
  }
}


