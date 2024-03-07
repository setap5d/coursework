import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:flutter/material.dart';
import 'notifications.dart';
import 'profile.dart';

void main() => runApp(const MyApp());

// void showAccountDetails(BuildContext context) {
//     late OverlayEntry overlay;

//     if (popUpSemaphore == 1) {
//       return;
//     }
//     popUpSemaphore ++;

//     overlay = OverlayEntry(
//       builder: (BuildContext context) => Positioned(
//         top: 0, // adjust the top position as needed
//         left: 80, // adjust the left position as needed
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
//                 Text('Username: Jimothy',
//                 style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.normal,
//                     color: Theme.of(context).colorScheme.onTertiary,
//                   ),
//                   ),
//                 const SizedBox(height: 8),
//                 Text('Email: jimothy.doe@example.com',
//                 style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.normal,
//                     color: Theme.of(context).colorScheme.onTertiary,
//                   ),
//                   ),
//                 const SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: () {
//                     overlay.remove();
//                     popUpSemaphore --;
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
//                   ),
//                   child: Text('Close',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.normal,
//                     color: Theme.of(context).colorScheme.onTertiaryContainer,
//                   ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );

//     Overlay.of(context).insert(overlay);
//   }

//   void showNotificationDetails(BuildContext context) {
//     late OverlayEntry overlay;

//     if (popUpSemaphore == 1) {
//       return;
//     }
//     popUpSemaphore ++;

//     overlay = OverlayEntry(
//       builder: (BuildContext context) => Positioned(
//         top: 0, // adjust the top position as needed
//         left: 80, // adjust the left position as needed
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
//                 Text('Username: Jimothy',
//                 style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.normal,
//                     color: Theme.of(context).colorScheme.onTertiary,
//                   ),
//                   ),
//                 const SizedBox(height: 8),
//                 Text('Email: jimothy.doe@example.com',
//                 style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.normal,
//                     color: Theme.of(context).colorScheme.onTertiary,
//                   ),
//                   ),
//                 const SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: () {
//                     overlay.remove();
//                     popUpSemaphore --;
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
//                   ),
//                   child: Text('Close',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.normal,
//                     color: Theme.of(context).colorScheme.onTertiaryContainer,
//                   ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );

//     Overlay.of(context).insert(overlay);
//   }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Project management app',
      home: Scaffold(
        body: SidebarPage(),
      ),
    );
  }
}

class SidebarPage extends StatefulWidget {
  const SidebarPage({super.key});

  @override
// ignore: library_private_types_in_public_api
  _SidebarPageState createState() => _SidebarPageState();
}

class _SidebarPageState extends State<SidebarPage> {
  late List<CollapsibleItem> _items;
  late String _headline;
  // final AssetImage _avatarImg = const AssetImage('asset/gfg.png');

  @override
  void initState() {
    super.initState();
    _items = _generateItems;
    _headline = _items.firstWhere((item) => item.isSelected).text;
  }

  List<CollapsibleItem> get _generateItems {
    return [
      CollapsibleItem(
        text: 'Account',
        icon: Icons.account_circle,
        onPressed: () => setState(() => showAccountDetails(context)),
      ),
      CollapsibleItem(
        text: 'Home',
        icon: Icons.home,
        onPressed: () => setState(() => _headline = 'Home'),
        isSelected: true,
      ),
      CollapsibleItem(
        text: 'Notifications',
        icon: Icons.notifications,
        onPressed: () => setState(() => showNotificationDetails(context)),
      ),
      CollapsibleItem(
        text: 'Setting',
        icon: Icons.settings,
        onPressed: () => setState(() => _headline = 'Settings'),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: CollapsibleSidebar(
        isCollapsed: MediaQuery.of(context).size.width <= 800,
        items: _items,
        // avatarImg: _avatarImg,
        // title: 'Name',
        showTitle: false,
        showToggleButton: false,
        onTitleTap: () {
          MediaQuery.of(context).size.width <= 800;
        },
        body: _body(size, context),
        selectedIconBox: Colors.transparent,
        unselectedTextColor: Colors.white,
        unselectedIconColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 44, 129, 47),
        selectedTextColor: const Color.fromARGB(255, 65, 68, 255),
        textStyle: const TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
        titleStyle: const TextStyle(
            fontSize: 20,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold),
        toggleTitleStyle:
            const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        sidebarBoxShadow: const [
          BoxShadow(
            color: Color.fromARGB(255, 63, 181, 171),
            blurRadius: 20,
            spreadRadius: 0.01,
            offset: Offset(3, 3),
          ),
          BoxShadow(
            color: Color.fromARGB(255, 77, 240, 83),
            blurRadius: 50,
            spreadRadius: 0.01,
            offset: Offset(3, 3),
          ),
        ],
      ),
    );
  }

  Widget _body(Size size, BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: const Color.fromARGB(255, 255, 255, 255),
      child: Center(
        child: Text(
          _headline,
          style: Theme.of(context).textTheme.displayMedium,
          overflow: TextOverflow.visible,
          softWrap: false,
        ),
      ),
    );
  }
}
