import 'package:flutter/material.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({
    required this.projectName,
    required this.deadline,
    required this.projectLeader,
    required this.width, // Add width parameter
    required this.height,
    super.key,
  });

  final String projectName;
  final String deadline;
  final String projectLeader;
  final double width; // Declare width parameter
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      // borderRadius: BorderRadius.circular(30),
      child: Container(
        width: width, // Use the width parameter here
        height: height,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Colors.black,
          ),
          // borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          children: [
            Row(children: [
              Expanded(
                child: Text(projectName, textAlign: TextAlign.center),
              )
            ]),
            Row(children: [
              Expanded(
                child: Text(deadline, textAlign: TextAlign.center),
              )
            ]),
            Row(children: [
              Expanded(
                child: Text(projectLeader, textAlign: TextAlign.center),
              )
            ]),
          ],
        ),
      ),
    );
  }
}


