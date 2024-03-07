import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'notifications.dart';
import 'profile.dart';

class DrawerItem {
  final String title;
  final IconData icon;

  const DrawerItem({
    required this.title,
    required this.icon,
  });
}



class DeploymentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Deployment'),
          centerTitle: true,
          backgroundColor: Colors.teal,
        ),
        body: NavigationDrawerWidget(),
      );
}

final itemsFirst = [
  DrawerItem(title: 'Home', icon: Icons.home),
  DrawerItem(title: 'Notifications', icon: Icons.notifications),
  DrawerItem(title: 'Setting', icon: Icons.settings),
];

// final itemsSecond = [
//   DrawerItem(title: 'Deployment', icon: Icons.cloud_upload),
//   DrawerItem(title: 'Resources', icon: Icons.extension),
// ];

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

// class NavigationDrawerWidget extends StatelessWidget {
//   final padding = EdgeInsets.symmetric(horizontal: 20);

//   @override
//   Widget build(BuildContext context) {
//     final safeArea =
//         EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top);

//     final provider = Provider.of<NavigationProvider>(context);
//     final isCollapsed = provider.isCollapsed;

//     return Container(
//       width: isCollapsed ? MediaQuery.of(context).size.width * 0.2 : null,
//       child: Drawer(
//         child: Container(
//           color: Color(0xFF1a2f45),
//           child: Column(
//             children: [
//               Container(
//                 padding: EdgeInsets.symmetric(vertical: 24).add(safeArea),
//                 width: double.infinity,
//                 color: Colors.white12,
//                 child: buildHeader(isCollapsed),
//               ),
//               const SizedBox(height: 24),
//               buildList(items: itemsFirst, isCollapsed: isCollapsed),
//               const SizedBox(height: 24),
//               Divider(color: Colors.white70),
//               const SizedBox(height: 24),
//               buildList(
//                 indexOffset: itemsFirst.length,
//                 items: itemsSecond,
//                 isCollapsed: isCollapsed,
//               ),
//               Spacer(),
//               buildCollapseIcon(context, isCollapsed),
//               const SizedBox(height: 12),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildList({
//     required bool isCollapsed,
//     required List<DrawerItem> items,
//     int indexOffset = 0,
//   }) =>
//       ListView.separated(
//         padding: isCollapsed ? EdgeInsets.zero : padding,
//         shrinkWrap: true,
//         primary: false,
//         itemCount: items.length,
//         separatorBuilder: (context, index) => SizedBox(height: 16),
//         itemBuilder: (context, index) {
//           final item = items[index];

//           return buildMenuItem(
//             isCollapsed: isCollapsed,
//             text: item.title,
//             icon: item.icon,
//             onClicked: () => selectItem(context, indexOffset + index),
//           );
//         },
//       );

//   void selectItem(BuildContext context, int index) {
//     final navigateTo = (page) => Navigator.of(context).push(MaterialPageRoute(
//           builder: (context) => page,
//         ));

//     Navigator.of(context).pop();

//     switch (index) {
//       case 0:
//         navigateTo(DeploymentPage());
//         break;
//       case 1:
//         navigateTo(DeploymentPage());
//         break;
//       case 2:
//         navigateTo(DeploymentPage());
//         break;
//       case 3:
//         navigateTo(DeploymentPage());
//         break;
//       case 4:
//         navigateTo(DeploymentPage());
//         break;
//       case 5:
//         navigateTo(DeploymentPage());
//         break;
//     }
//   }

//   Widget buildMenuItem({
//     required bool isCollapsed,
//     required String text,
//     required IconData icon,
//     VoidCallback? onClicked,
//   }) {
//     final color = Colors.white;
//     final leading = Icon(icon, color: color);

//     return Material(
//       color: Colors.transparent,
//       child: isCollapsed
//           ? ListTile(
//               title: leading,
//               onTap: onClicked,
//             )
//           : ListTile(
//               leading: leading,
//               title: Text(text, style: TextStyle(color: color, fontSize: 16)),
//               onTap: onClicked,
//             ),
//     );
//   }

//   Widget buildCollapseIcon(BuildContext context, bool isCollapsed) {
//     final double size = 52;
//     final icon = isCollapsed ? Icons.arrow_forward_ios : Icons.arrow_back_ios;
//     final alignment = isCollapsed ? Alignment.center : Alignment.centerRight;
//     final margin = isCollapsed ? null : EdgeInsets.only(right: 16);
//     final width = isCollapsed ? double.infinity : size;

//     return Container(
//       alignment: alignment,
//       margin: margin,
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           child: Container(
//             width: width,
//             height: size,
//             child: Icon(icon, color: Colors.white),
//           ),
//           onTap: () {
//             final provider =
//                 Provider.of<NavigationProvider>(context, listen: false);

//             provider.toggleIsCollapsed();
//           },
//         ),
//       ),
//     );
//   }

//   Widget buildHeader(bool isCollapsed) => isCollapsed
//       ? FlutterLogo(size: 48)
//       : Row(
//           children: [
//             const SizedBox(width: 24),
//             FlutterLogo(size: 48),
//             const SizedBox(width: 16),
//             Text(
//               'Flutter',
//               style: TextStyle(fontSize: 32, color: Colors.white),
//             ),
//           ],
//         );
// }

class NavigationProvider extends ChangeNotifier {
  bool _isCollapsed = false;

  bool get isCollapsed => _isCollapsed;

  void toggleIsCollapsed() {
    _isCollapsed = !isCollapsed;

    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  static final String title = 'Navigation Drawer';

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => NavigationProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: title,
          theme: ThemeData(primarySwatch: Colors.deepOrange),
          home: MainPage(),
        ),
      );
}

class NavigationDrawerWidget extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);

  NavigationDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final safeArea =
        EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top);

    bool isCollapsed = true;

    double checkScreenWidth() {
      if (MediaQuery.of(context).size.width >= 800) {
        isCollapsed = false;
        return MediaQuery.of(context).size.width * 0.4;
      } else {
        return MediaQuery.of(context).size.width * 0.2;
      }
    }
    
    double checkScreenHeight() {
      if (MediaQuery.of(context).size.height <= 400) {
        isCollapsed = false;
        return MediaQuery.of(context).size.width * 0;
      } else {
        return MediaQuery.of(context).size.width;
      }
    }

    return Container(
      height: checkScreenHeight(),
      width: checkScreenWidth(),
      child: Drawer(
        child: Container(
          color: Color(0xFF1a2f45),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 24).add(safeArea),
                width: double.infinity,
                color: Colors.white12,
                child: buildHeader(isCollapsed),
              ),
              const SizedBox(height: 24),
              buildList(items: itemsFirst, isCollapsed: isCollapsed),
              const SizedBox(height: 24),
              Divider(color: Colors.white70),
              const SizedBox(height: 24),
              // buildList(
              //   indexOffset: itemsFirst.length,
              //   items: itemsSecond,
              //   isCollapsed: isCollapsed,
              // ),
              Spacer(),
              // buildCollapseIcon(context, isCollapsed),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildList({
    required bool isCollapsed,
    required List<DrawerItem> items,
    int indexOffset = 0,
  }) =>
      ListView.separated(
        padding: isCollapsed ? EdgeInsets.zero : padding,
        shrinkWrap: true,
        primary: false,
        itemCount: items.length,
        separatorBuilder: (context, index) => SizedBox(height: 16),
        itemBuilder: (context, index) {
          final item = items[index];

          return buildMenuItem(
            isCollapsed: isCollapsed,
            text: item.title,
            icon: item.icon,
            onClicked: () => selectItem(context, indexOffset + index),
          );
        },
      );

  void selectItem(BuildContext context, int index) {
    final navigateTo = (page) => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => page,
        ));

    Navigator.of(context).pop();

    switch (index) {
      case 0:
        navigateTo(AccountDetailsTool());
        break;
      case 1:
        navigateTo(NotificationsDetailsTool());
        break;
      case 2:
        navigateTo(NotificationsDetailsTool());
        break;
      case 3:
        navigateTo(DeploymentPage());
        break;
      case 4:
        navigateTo(DeploymentPage());
        break;
      case 5:
        navigateTo(DeploymentPage());
        break;
    }
  }

  Widget buildMenuItem({
    required bool isCollapsed,
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white;
    final leading = Icon(icon, color: color);

    return Material(
      color: Colors.transparent,
      child: isCollapsed
          ? ListTile(
              title: leading,
              onTap: onClicked,
            )
          : ListTile(
              leading: leading,
              title: Text(text, style: TextStyle(color: color, fontSize: 16)),
              onTap: onClicked,
            ),
    );
  }

  // Widget buildCollapseIcon(BuildContext context, bool isCollapsed) {
  //   final double size = 52;
  //   final icon = isCollapsed ? Icons.arrow_forward_ios : Icons.arrow_back_ios;
  //   final alignment = isCollapsed ? Alignment.center : Alignment.centerRight;
  //   final margin = isCollapsed ? null : EdgeInsets.only(right: 16);
  //   final width = isCollapsed ? double.infinity : size;

  //   return Container(
  //     alignment: alignment,
  //     margin: margin,
  //     child: Material(
  //       color: Colors.transparent,
  //       child: InkWell(
  //         child: Container(
  //           width: width,
  //           height: size,
  //           child: Icon(icon, color: Colors.white),
  //         ),
  //         onTap: () {
  //           final provider =
  //               Provider.of<NavigationProvider>(context, listen: false);

  //           provider.toggleIsCollapsed();
  //         },
  //       ),
  //     ),
  //   );
  // }

  Widget buildHeader(bool isCollapsed) => isCollapsed
      ? CircleAvatar()
      : Row(
          children: [
            const SizedBox(width: 24),
            CircleAvatar(),
            const SizedBox(width: 16),
            Text(
              'Profile',
            )
          ],
        );
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: NavigationDrawerWidget(),
        // appBar: AppBar(
        //   backgroundColor: Colors.red,
        //   title: Text('what'),
        //   centerTitle: true,
        // ),
      );
}
