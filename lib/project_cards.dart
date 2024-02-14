import 'package:flutter/material.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({
    required this.projectName,
    required this.deadline,
    required this.projectLeader,
    super.key,
  });

  final String projectName;
  final String deadline;
  final String projectLeader;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Colors.black,
          ),
          borderRadius: BorderRadius.circular(30),
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
