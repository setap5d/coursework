import 'package:flutter/material.dart';


class NotificationsDetailsTool extends StatefulWidget {
  @override
  _NotificationsDetailsToolState createState() =>
      _NotificationsDetailsToolState();
}

class _NotificationsDetailsToolState extends State<NotificationsDetailsTool> {
  OverlayEntry? _overlayEntry;

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance?.addPostFrameCallback((_) {
  //     _showOverlay();
  //   });
  // }

  // @override
  // void dispose() {
  //   _removeOverlay();
  //   super.dispose();
  // }

  // void _showOverlay() {
  //   final List<String> notifications = [
  //     'Notification 1',
  //     'Notification 2',
  //     'Notification 3',
  //     'Notification 4',
  //     'Notification 5',
  //     'Notification 6',
  //     'Notification 7',
  //     'Notification 8',
  //     'Notification 9',
  //     'Notification 10',
  //   ];
  //   _overlayEntry = OverlayEntry(
  //     builder: (BuildContext context) => Positioned(
  //       top: 150, // adjust the top position as needed
  //       left: MediaQuery.of(context).size.width*0.4, // adjust the left position as needed
  //       child: Material(
  //         color: Colors.transparent,
  //         child: Container(
  //           padding: const EdgeInsets.all(16),
  //           decoration: BoxDecoration(
  //             color: Theme.of(context).colorScheme.tertiary,
  //             borderRadius: BorderRadius.circular(16),
  //           ),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Text(
  //                 'User Details',
  //                 style: TextStyle(
  //                   fontSize: 20,
  //                   fontWeight: FontWeight.bold,
  //                   color: Theme.of(context).colorScheme.onTertiary,
  //                 ),
  //               ),
  //               const SizedBox(height: 16),
  //               Text(
  //                 'Notifications',
  //                 style: TextStyle(
  //                   fontSize: 20,
  //                   fontWeight: FontWeight.normal,
  //                   color: Theme.of(context).colorScheme.onTertiary,
  //                 ),
  //               ),
  //               const SizedBox(height: 8),
  //               Text(
  //                 'NOTIFICATIONS_GO_HERE',
  //                 style: TextStyle(
  //                   fontSize: 20,
  //                   fontWeight: FontWeight.normal,
  //                   color: Theme.of(context).colorScheme.onTertiary,
  //                 ),
  //               ),
  //               Container(
  //                 height: 100,
  //                 width: 100,
  //                 child: ListView.builder(
  //                   itemCount: notifications.length,
  //                   itemBuilder: (BuildContext context, int index) {
  //                     return ListTile(
  //                       title: Text(notifications[index]),
  //                     );
  //                   },
  //                 ),
  //               ),
  //               const SizedBox(height: 16),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );

  //   Overlay.of(context)?.insert(_overlayEntry!);
  // }

  // void _removeOverlay() {
  //   _overlayEntry?.remove();
  //   _overlayEntry = null;
  // }

  @override
  Widget build(BuildContext context) {
    List<String> notifications = [
      'Notification 1',
      'Notification 2',
      'Notification 3',
      'Notification 4',
      'Notification 5',
      'Notification 6',
      'Notification 7',
      'Notification 8',
      'Notification 9',
      'Notification 10',
    ];

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0, // adjust the top position as needed
            left: MediaQuery.of(context).size.width*0.005, // adjust the left position as needed
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'User Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onTertiary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).colorScheme.onTertiary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 100,
                      width: 200, // Adjust the width as needed
                      child: ListView.builder(
                        itemCount: notifications.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(notifications[index]),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 

// void showNotificationDetails(BuildContext context) {
//   late OverlayEntry overlay;

//   final List<String> notifications = [
//     'Notification 1',
//     'Notification 2',
//     'Notification 3',
//     'Notification 4',
//     'Notification 5',
//     'Notification 6',
//     'Notification 7',
//     'Notification 8',
//     'Notification 9',
//     'Notification 10',
//   ];

//   overlay = OverlayEntry(
//     builder: (BuildContext context) => Positioned(
//       top: 700, // adjust the top position as needed
//       left: 80, // adjust the left position as needed
//       child: Material(
//         color: Colors.transparent,
//         child: Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Theme.of(context).colorScheme.tertiary,
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 'User Details',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Theme.of(context).colorScheme.onTertiary,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 'Notifications',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.normal,
//                   color: Theme.of(context).colorScheme.onTertiary,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 'NOTIFICATIONS_GO_HERE',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.normal,
//                   color: Theme.of(context).colorScheme.onTertiary,
//                 ),
//               ),
//               Container(
//                 height: 100,
//                 width: 100,
//                 child: ListView.builder(
//                   itemCount: notifications.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     return ListTile(
//                       title: Text(notifications[index]),
//                     );
//                   },
//                 ),
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () {
//                   overlay.remove();
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor:
//                       Theme.of(context).colorScheme.tertiaryContainer,
//                 ),
//                 child: Text(
//                   'Close',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.normal,
//                     color: Theme.of(context).colorScheme.onTertiaryContainer,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     ),
//   );

//   Overlay.of(context).insert(overlay);
// }
