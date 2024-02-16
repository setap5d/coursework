import 'package:flutter/material.dart';

Widget buildProject({
  // Creates the icon and text combos for the map
  required VoidCallback onPressed,
  required String projectTitle,
  required DateTime deadline,
  required String leaderName,
  required Color primaryColor,
  required BuildContext context,
}) {
  return Stack(
    children: [
      Positioned(
        top: 20,
        right: 50,
        child: ElevatedButton(
          onPressed: () {
            // Open specific project page
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            backgroundColor: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5.0),
                    Text(
                      projectTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Helvetica',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      'Deadline: ${deadline.toString()}',
                      style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'Helvetica',
                          color: Colors.redAccent),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      leaderName,
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'Helvetica',
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5.0),
                Container(
                  alignment: Alignment.centerRight,
                  child: PopupMenuButton<String>(
                    onSelected: (value) {
                      // Handle menu item selection
                      print("Selected: $value");
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem<String>(
                        value: 'Option 1',
                        child: Text('Option 1'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Option 2',
                        child: Text('Option 2'),
                      ),
                      // Add more PopupMenuItems as needed
                    ],
                    child: const Icon(Icons.more_vert),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
