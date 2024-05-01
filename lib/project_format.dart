/// Initialises Project Details Variables
class Project {
  String projectName = 'Project Name';
  String deadline = 'Deadline for Project';
  String leader = 'Leader: ';
  bool archived;
  bool isExpanded;

  Project({this.archived = false, this.isExpanded = false});
}
