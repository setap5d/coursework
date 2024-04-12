import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskCard extends StatelessWidget {
  final String taskName;
  final String deadline;
  final String taskAssignees;
  final String taskDescription;
  final List<String> ticketNames;
  final double width;
  final double height;
  final bool isCardExpanded;
  final Function(BuildContext context, int index) addTicket;
  final int index;

  const TaskCard({
    Key? key,
    required this.taskName,
    required this.deadline,
    required this.taskAssignees,
    required this.taskDescription,
    required this.ticketNames,
    required this.width,
    required this.height,
    required this.isCardExpanded,
    required this.addTicket,
    required this.index,
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
    return Expanded(
      child: Stack(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
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
                            overflow:
                                isCardExpanded ? null : TextOverflow.ellipsis,
                          ),
                          Text(
                            'Task Assignees: $taskAssignees',
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                            overflow:
                                isCardExpanded ? null : TextOverflow.ellipsis,
                          ),
                          Visibility(
                            visible: isCardExpanded,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Task Description: $taskDescription',
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Display ticket names here
                                if (ticketNames.isNotEmpty)
                                  ...ticketNames.map((ticketName) => Text(
                                        'Ticket: $ticketName',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                              ],
                            ),
                          ),
                          if (isCardExpanded) const Spacer(),
                          if (isCardExpanded)
                            ElevatedButton(
                              onPressed: () {
                                addTicket(context, index);
                              },
                              child: const Text('Add Ticket'),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 213, 213, 213),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: SizedBox(
                      width: 200,
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
      ),
    );
  }
}
