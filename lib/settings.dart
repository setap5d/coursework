import 'package:flutter/material.dart';
import 'settings_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'myHomePage.dart';
import 'profile.dart';
import 'notifications.dart';
import 'projectTiles.dart';
import 'projectFormat.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage(
      {Key? key,
      required this.title,
      required this.email,
      required this.projectIDs,
      required this.projects})
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

  @override
  State<SettingsPage> createState() => _SettingsPageState(
      title: title, user: email, projectIDs: projectIDs, projects: projects);
}

class _SettingsPageState extends State<SettingsPage> {
  _SettingsPageState(
      {Key? key,
      required this.title,
      required this.user,
      required this.projectIDs,
      required this.projects});

  final String title;
  final String user;
  final List<dynamic> projectIDs;
  final List<Project> projects;

  int popUpSemaphore = 0;
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      ProfilePage(user: user), //Passes the user email
      projectsPage(
        title: 'My Projects',
        email: user,
        projectIDs: projectIDs,
        projects: projects,
      ),
      NotificationsDetailsTool(),
      SettingsInterface(email: widget.email),
      SettingsInterface(email: widget.email),
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
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  if (index == _screens.length - 1) {
                    Navigator.of(context).pop();
                  } else {
                    _selectedIndex = index;
                  }
                });
              },
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              extended: isExtended(),
              groupAlignment: -1.0,
              // leading: FloatingActionButton(
              //   onPressed: () {
              //     ProfilePage();
              //   setState(() {
              //     _selectedIndex = 2;
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
                NavigationRailDestination(
                  icon: Icon(Icons.notifications),
                  label: Text('Notifications'),
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
          Expanded(child: _screens[_selectedIndex]),
        ],
      ),
    );
  }
}

class SettingsInterface extends StatefulWidget {
  const SettingsInterface({required this.email, super.key});

  final String email;

  @override
  State<SettingsInterface> createState() => _SettingsInterfaceState();
}

class _SettingsInterfaceState extends State<SettingsInterface> {
  // FIREBASE NOTE FIREBASE NOTE FIREBASE NOTE FIREBASE NOTE FIREBASE NOTE FIREBASE NOTE FIREBASE NOTE FIREBASE NOTE FIREBASE NOTE FIREBASE NOTE FIREBASE NOTE FIREBASE NOTE

  // Settings map should be initalised from database NOT hardwired initialistion, Widgets are currently configured to work with Map datatype and therefore
  // will require reworking if datatype must change for firebase integration
  // The saveSettingsToFireBase() will be called when the 'Save Changes' elevated button is pressed. The function must be confiured to communicate with Firebase

  Map<String, dynamic> settings = {
    'Display Mode': 'Light Mode',
    'Project Deadline Notifications': true,
    'Task Deadline Notifications': true,
    'Ticket Notifications': true
  };

  //Function for getting settings from database, needs to be initialised on build/before screen move
  Future<void> getSettingsFromFireBase(email) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db
        .collection('Profiles')
        .doc('$email')
        .collection('User')
        .doc('Settings')
        .snapshots()
        .listen((snapshot) async {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      settings = {
        'Display Mode': data['Display Mode'],
        'Project Deadline Notifications':
            data['Project Deadline Notifications'],
        'Task Deadline Notifications': data['Task Deadline Notifications'],
        'Ticket Notifications': data['Ticket Notifications']
      };
    });
    print(settings);
  }

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
    print(settings);
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
              child: Column(children: <Widget>[
            const Text(
              "Settings",
              style: TextStyle(fontSize: 36),
            ),
            Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        "Display",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 26),
                      ),
                      RadioSetting(
                        settingName: "Display Mode",
                        optionsList: const [
                          "Light Mode",
                          "Dark Mode",
                          "High Contrast Mode",
                          "Colour Blind Mode"
                        ],
                        onChanged: (selectedOption) {
                          setState(() {
                            settings['Display Mode'] = selectedOption;
                          });
                          print(selectedOption);
                        },
                      ),
                      const SettingDivider(),
                      const Text(
                        "Notifications",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 26),
                      ),
                      SwitchSetting(
                          settingName: "Project Deadline Notifications",
                          settingDescription:
                              "Enables notifcations for approaching project deadlines",
                          settingsValue:
                              settings['Project Deadline Notifications'],
                          onChanged: (value) {
                            setState(() {
                              settings['Project Deadline Notifications'] =
                                  value;
                            });
                          }),
                      const SettingDivider(),
                      SwitchSetting(
                          settingName: "Task Deadline Notifications",
                          settingDescription:
                              "Enables notifcations for approaching task deadlines",
                          settingsValue:
                              settings['Task Deadline Notifications'],
                          onChanged: (value) {
                            setState(() {
                              settings['Task Deadline Notifications'] = value;
                            });
                          }),
                      const SettingDivider(),
                      SwitchSetting(
                          settingName: "Ticket Notifications",
                          settingDescription:
                              "Enables notifcations for changes to tickets",
                          settingsValue: settings['Ticket Notifications'],
                          onChanged: (value) {
                            setState(() {
                              settings['Ticket Notifications'] = value;
                            });
                          }),
                    ]))
          ])),
        ),
        ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
            Theme.of(context).colorScheme.inversePrimary,
          )),
          onPressed: () {
            saveSettingsToFireBase(widget.email, settings); //email is incorrect
          },
          child: const Text('Save Changes'),
        ),
      ],
    );
  }
}
