import 'package:flutter/material.dart';


// class AccountDetailsTool extends StatefulWidget {
//   @override
//   _AccountDetailsToolState createState() => _AccountDetailsToolState();
// }

// class _AccountDetailsToolState extends State<AccountDetailsTool> {
//   OverlayEntry? _overlayEntry;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance?.addPostFrameCallback((_) {
//       _showOverlay();
//     });
//   }

//   @override
//   void dispose() {
//     _removeOverlay();
//     super.dispose();
//   }

//   void _showOverlay() {
//     _overlayEntry = OverlayEntry(
//       builder: (BuildContext context) => Positioned(
//         top: 0, // adjust the top position as needed
//         left: MediaQuery.of(context).size.width*0.4, // adjust the left position as needed
//         child: Material(
//           color: Colors.transparent,
//           child: Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Theme.of(context).colorScheme.tertiary,
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   'User Details',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Theme.of(context).colorScheme.onTertiary,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   'Username: Jimothy',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.normal,
//                     color: Theme.of(context).colorScheme.onTertiary,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Email: jimothy.doe@example.com',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.normal,
//                     color: Theme.of(context).colorScheme.onTertiary,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 // ElevatedButton(
//                 //   onPressed: () {
//                 //     overlay.remove();
//                 //   },
//                 //   style: ElevatedButton.styleFrom(
//                 //     backgroundColor:
//                 //         Theme.of(context).colorScheme.tertiaryContainer,
//                 //   ),
//                 //   child: Text(
//                 //     'Close',
//                 //     style: TextStyle(
//                 //       fontSize: 20,
//                 //       fontWeight: FontWeight.normal,
//                 //       color: Theme.of(context).colorScheme.onTertiaryContainer,
//                 //     ),
//                 //   ),
//                 // ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );

//     Overlay.of(context)?.insert(_overlayEntry!);
//   }

//   void _removeOverlay() {
//     _overlayEntry?.remove();
//     _overlayEntry = null;
//   }

//   @override
//   Widget build(BuildContext context) => Scaffold(
//         body: NavigationDrawerWidget(),
//   );
// }


// void showAccountDetails(BuildContext context) {
//   late OverlayEntry overlay;

//   overlay = OverlayEntry(
//     builder: (BuildContext context) => Positioned(
//       top: 0, // adjust the top position as needed
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
//                 'Username: Jimothy',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.normal,
//                   color: Theme.of(context).colorScheme.onTertiary,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 'Email: jimothy.doe@example.com',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.normal,
//                   color: Theme.of(context).colorScheme.onTertiary,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               // ElevatedButton(
//               //   onPressed: () {
//               //     overlay.remove();
//               //   },
//               //   style: ElevatedButton.styleFrom(
//               //     backgroundColor:
//               //         Theme.of(context).colorScheme.tertiaryContainer,
//               //   ),
//               //   child: Text(
//               //     'Close',
//               //     style: TextStyle(
//               //       fontSize: 20,
//               //       fontWeight: FontWeight.normal,
//               //       color: Theme.of(context).colorScheme.onTertiaryContainer,
//               //     ),
//               //   ),
//               // ),
//             ],
//           ),
//         ),
//       ),
//     ),
//   );
//   Overlay.of(context).insert(overlay);
// }
