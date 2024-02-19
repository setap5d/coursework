import 'package:flutter/material.dart';

class ProjectCard extends StatelessWidget {
  final String projectName;
  final String deadline;
  final String projectLeader;
  final double width;
  final double height;

  const ProjectCard({
    Key? key,
    required this.projectName,
    required this.deadline,
    required this.projectLeader,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  'Task Name: $projectName',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Task Assignees: $projectLeader',
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
              color:  Color.fromARGB(255, 213, 213, 213),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Deadline',
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  deadline,
                  style: const TextStyle(
                    color: Colors.white,
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
