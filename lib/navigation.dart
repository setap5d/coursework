// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'projects_page.dart';
import 'profile.dart';
import 'project_format.dart';
import 'settings_page.dart';

/// Contains static variables [lightMode], [darkMode] and [highContrastMode] that define possible [ColorScheme] classes
class AppColorSchemes {
  static final lightMode = ColorScheme.fromSeed(
      seedColor: Colors.blue, brightness: Brightness.light);

  static final darkMode =
      ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark);

// Taken from offical Flutter website
  static final highContrastMode = ColorScheme.fromSeed(
    seedColor: const Color(0xffefb7ff),
    brightness: Brightness.dark,
  ).copyWith(
    primaryContainer: const Color(0xffefb7ff),
    onPrimaryContainer: Colors.black,
    secondaryContainer: const Color(0xff66fff9),
    onSecondaryContainer: Colors.black,
    error: const Color(0xff9b374d),
    onError: Colors.white,
  );
}

/// Creates [_NavigationPageState]
///
/// Has attributes [email], [projectIDs], [projects], [profDetails], [settings], [selectedIndex]
/// Attributes are taken purely to pass them to [_NavigationPageState]
class NavigationPage extends StatefulWidget {
  const NavigationPage(
      {Key? key,
      required this.email,
      required this.projectIDs,
      required this.projects,
      required this.profDetails,
      required this.settings,
      required this.selectedIndex})
      : super(key: key);

  final String email;
  final List<dynamic> projectIDs;
  final List<Project> projects;
  final List<dynamic> profDetails;
  final Map<String, dynamic> settings;
  final int selectedIndex;

  @override
  State<NavigationPage> createState() => _NavigationPageState(
      email: email,
      projectIDs: projectIDs,
      projects: projects,
      settings: settings,
      profDetails: profDetails,
      selectedIndex: selectedIndex);
}

/// Provides navigation between [ProfilePage], [ProjectsPage] and [SettingsPage]
///
/// Builds a [NavigationRail] and [Expanded] widget
/// The [NavigationRail] determines which page is displayed in the [Expanded] widget
/// Defines [activeColorScheme] applying the correct [ColorScheme] from [AppColorSchemes]
/// Has attributes [email], [projectIDs], [projects], [settings], [profDetails], [selectedIndex]
/// Defines methods: [initState], [updateColorScheme], [isExtended], [changePage]
class _NavigationPageState extends State<NavigationPage> {
  late ColorScheme activeColorScheme;

  _NavigationPageState(
      {required this.email,
      required this.projectIDs,
      required this.projects,
      required this.settings,
      required this.profDetails,
      required this.selectedIndex});

  final String email;
  final List<dynamic> projectIDs;
  final List<Project> projects;
  final List<dynamic> profDetails;
  final Map<String, dynamic> settings;
  int selectedIndex;

  @override
  void initState() {
    super.initState();
    updateColorScheme();
  }

  void updateColorScheme() {
    setState(() {
      final displayMode = widget.settings["Display Mode"];
      switch (displayMode) {
        case "Dark Mode":
          activeColorScheme = AppColorSchemes.darkMode;
          break;
        case "Light Mode":
          activeColorScheme = AppColorSchemes.lightMode;
          break;
        case "High Contrast Mode":
          activeColorScheme = AppColorSchemes.highContrastMode;
          break;
        default:
          break;
      }
    });
  }

  bool isExtended() {
    if (MediaQuery.of(context).size.width >= 800) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      ProfilePage(email: email, profDetails: widget.profDetails),
      ProjectsPage(
        title: 'My Projects',
        email: email,
        projectIDs: projectIDs,
        projects: projects,
        settings: settings,
        profDetails: profDetails,
        activeColorScheme: activeColorScheme,
      ),
      SettingsPage(
        email: widget.email,
        settings: widget.settings,
        activeColorScheme: activeColorScheme,
      ),
    ];

    void changePage(index) {
      setState(() {
        if (index == pages.length) {
          Navigator.of(context).pop();
        } else {
          selectedIndex = index;
        }
      });
    }

    return Scaffold(
      body: Theme(
        data: ThemeData.from(colorScheme: activeColorScheme),
        child: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                selectedIndex: selectedIndex,
                onDestinationSelected: (changePage),
                extended: isExtended(),
                groupAlignment: -1.0,
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.account_circle),
                    label: Text('Profile'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.settings),
                    label: Text('Settings'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.logout),
                    label: Text('Logout'),
                  ),
                ],
              ),
            ),
            Expanded(child: pages[selectedIndex]),
          ],
        ),
      ),
    );
  }
}
