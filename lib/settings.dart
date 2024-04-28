import 'package:flutter/material.dart';
import 'package:setaplogin/main.dart';
import 'settings_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'myHomePage.dart';
import 'profile.dart';
import 'notifications.dart';
import 'projectTiles.dart';
import 'projectFormat.dart';

class AppColorSchemes {
  static final lightMode = ColorScheme.fromSeed(seedColor: Colors.blue,
  brightness: Brightness.light
  );

  static final darkMode = ColorScheme.fromSeed(seedColor: Colors.blue, 
  brightness: Brightness.dark
  );

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

class SettingsPage extends StatefulWidget {
  const SettingsPage(
      {Key? key,
      required this.title,
      required this.email,
      required this.projectIDs,
      required this.projects,
      required this.profDetails,
      required this.settings,
      required this.selectedIndex})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final String email;
  final List<dynamic> projectIDs;
  final List<Project> projects;
  final List<dynamic> profDetails;
  final Map<String, dynamic> settings;
  final int selectedIndex;

  @override
  State<SettingsPage> createState() => _SettingsPageState(
      title: title,
      user: email,
      projectIDs: projectIDs,
      projects: projects,
      settings: settings,
      profDetails: profDetails,
      selectedIndex: selectedIndex);
}

class _SettingsPageState extends State<SettingsPage> {
  late ColorScheme activeColorScheme;

  @override
  void initState() {
    super.initState();
    updateColorScheme();
  }

  void updateColorScheme() {
    setState(() {
      // Check the settings and set the active color scheme accordingly
      final displayMode = widget.settings["Display Mode"];
      switch (displayMode) {
      case "Dark Mode":
        activeColorScheme = AppColorSchemes.darkMode;
        break;
      case "Light Mode":
        activeColorScheme = AppColorSchemes.lightMode;
        break;
      case "High Contrast Mode":
        activeColorScheme = AppColorSchemes.highContrastMode; // Pass your seed color here
        break;
      default:
        // Handle default case, if any
        break;
    }
    });
  }

  _SettingsPageState(
      {Key? key,
      required this.title,
      required this.user,
      required this.projectIDs,
      required this.projects,
      required this.settings,
      required this.profDetails,
      required this.selectedIndex});

  final String title;
  final String user;
  final List<dynamic> projectIDs;
  final List<Project> projects;
  final List<dynamic> profDetails;
  final Map<String, dynamic> settings;
  int selectedIndex;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      ProfilePage(
          user: user, profDetails: widget.profDetails), //Passes the user email
      projectsPage(
        title: 'My Projects',
        email: user,
        projectIDs: projectIDs,
        projects: projects,
        settings: settings,
        profDetails: profDetails,
        activeColorScheme: activeColorScheme,

      ),
      // NotificationsDetailsTool(),
      SettingsInterface(email: widget.email, settings: widget.settings, activeColorScheme: activeColorScheme,),
      SettingsInterface(email: widget.email, settings: widget.settings, activeColorScheme: activeColorScheme,),
    ];

    bool isExtended() {
      if (MediaQuery.of(context).size.width >= 800) {
        return true;
      } else {
        return false;
      }
    }

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Theme(
        data: ThemeData.from(colorScheme: activeColorScheme),
        child: Row(
        children: [
          SafeArea(
            child: NavigationRail(
                selectedIndex: selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  if (index == _screens.length - 1) {
                    Navigator.of(context).pop();
                  } else {
                      selectedIndex = index;
                  }
                });
              },
                // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              extended: isExtended(),
              groupAlignment: -1.0,
              // leading: FloatingActionButton(
              //   onPressed: () {
              //     ProfilePage();
              //   setState(() {
                //     selectedIndex = 2;
              //   });

              //   },
              //   child: const Icon(Icons.account_circle),
              // ),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.account_circle),
                  label: Text('Profile'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                  // NavigationRailDestination(
                  //   icon: Icon(Icons.notifications),
                  //   label: Text('Notifications'),
                  // ),
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
            Expanded(child: _screens[selectedIndex]),
        ],
      ),
      ),
    );
  }
}

class SettingsInterface extends StatefulWidget {
  const SettingsInterface(
      {required this.email, required this.settings, required this.activeColorScheme, super.key});

  final String email;
  final Map<String, dynamic> settings;
  final ColorScheme activeColorScheme;

  @override
  State<SettingsInterface> createState() => _SettingsInterfaceState(email: email, settings: settings, activeColorScheme: activeColorScheme);
}

class _SettingsInterfaceState extends State<SettingsInterface> {
  // late ColorScheme activeColorScheme;

  @override
      _SettingsInterfaceState({Key? key,
      required this.email,
      required this.settings, 
      required this.activeColorScheme});
        final String email;
  final Map<String, dynamic> settings;
  final ColorScheme activeColorScheme;

  Future<void> saveSettingsToFireBase(email, settings) async {
    // FIREBASE NOTE FIREBASE NOTE FIREBASE NOTE FIREBASE NOTE FIREBASE NOTE FIREBASE NOTE FIREBASE NOTE FIREBASE NOTE FIREBASE NOTE FIREBASE NOTE FIREBASE NOTE FIREBASE NOTE

    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference profileRef = db
        .collection('Profiles')
        .doc('$email')
        .collection('User')
        .doc('Settings');
    await profileRef.set(settings);
  }

  @override
  Widget build(BuildContext context) {
    print(widget.settings);
    return Theme(
      data: ThemeData.from(colorScheme: activeColorScheme),
        child: Container(
          color: activeColorScheme.background,
          child: Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
                    child: Container(
                      color: activeColorScheme.background,
              child: Column(children: <Widget>[
                        Row(children: <Widget>[
                          Expanded(
                            child: Container(
                              color: activeColorScheme.inversePrimary,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
              "Settings",
                                                  style: TextStyle(fontSize: 36,
                                                  color: activeColorScheme.onBackground,
                                                  backgroundColor: activeColorScheme.inversePrimary)
                                          ),
            ),
                            ) )
                       ]),

            Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                               Text(
                        "Display",
                        style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 26, color: activeColorScheme.onBackground),
                      ),
                      RadioSetting(
                        settingName: "Display Mode",
                        optionsList: const [
                          "Light Mode",
                          "Dark Mode",
                                  "High Contrast Mode", //Color blind removed
                        ],
                        defaultOption: widget.settings['Display Mode'],
                        onChanged: (selectedOption) {
                          setState(() {
                            widget.settings['Display Mode'] = selectedOption;
                          });
                          print(selectedOption);
                        },
                                colorScheme: activeColorScheme
                              ),
                            ]))
                                    ]),
                    )),
        ),
        ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
            Theme.of(context).colorScheme.inversePrimary,
          )),
          onPressed: () {
            saveSettingsToFireBase(
                widget.email, widget.settings); //email is incorrect
                  showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Changed Saved'),
                  content: const Text('Please restart application to apply changes'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Close'),
                    ),
                  ],
                );
              },
            );
                      
                },
                child: Text('Save Changes',
                style: TextStyle(color: activeColorScheme.onBackground),),
              ),
      ],
          ),
        ),
    );
  }
}
