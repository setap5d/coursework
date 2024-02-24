import 'package:flutter/material.dart';
import 'package:setup_application/settings_widgets.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int popUpSemaphore = 0;

  void showAccountDetails(BuildContext context) {
    late OverlayEntry overlay;

    if (popUpSemaphore == 1) {
      return;
    }
    popUpSemaphore++;

    overlay = OverlayEntry(
      builder: (BuildContext context) => Positioned(
        top: 0, // adjust the top position as needed
        left: 80, // adjust the left position as needed
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
                  'Username: Jimothy',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).colorScheme.onTertiary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Email: jimothy.doe@example.com',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).colorScheme.onTertiary,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        overlay.remove();
                        popUpSemaphore--;
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.tertiaryContainer,
                      ),
                      child: Text(
                        'Close',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color:
                              Theme.of(context).colorScheme.onTertiaryContainer,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        overlay.remove();
                        popUpSemaphore--;
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.tertiaryContainer,
                      ),
                      child: Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color:
                              Theme.of(context).colorScheme.onTertiaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlay);
  }

  @override
  Widget build(BuildContext context) {
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
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              extended: false,
              groupAlignment: 1.0,
              leading: FloatingActionButton(
                onPressed: () {
                  showAccountDetails(context);
                },
                child: const Icon(Icons.account_circle),
              ),
              destinations: const [
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
              ],
              selectedIndex: 0,
              onDestinationSelected: (value) {},
            ),
          ),
          Column(
            children: [
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: const SettingsInterface(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SettingsInterface extends StatefulWidget {
  const SettingsInterface({super.key});

  @override
  State<SettingsInterface> createState() => _SettingsInterfaceState();
}

class _SettingsInterfaceState extends State<SettingsInterface> {
  // Settings map should be initalised from database NOT hardwired initialistion
  // On changed value for SwitchSetting should change the value stored in database NOT locally. (Confirm changed button should also be implemented.)
  Map<String, dynamic> settings = {
    'Dark Mode': false,
    'Setting 2': false,
    'Setting 3': false
  };

  @override
  Widget build(BuildContext context) {
    print(settings);
    return Column(children: <Widget>[
      Text(
        "Settings",
        style: TextStyle(fontSize: 36),
      ),
      Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Display",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 26),
                ),
                SwitchSetting(
                    settingName: "Dark Mode",
                    settingDescription:
                        "This is the first setting description in the app",
                    settingsValue: settings['Dark Mode'],
                    onChanged: (value) {
                      setState(() {
                        settings['Dark Mode'] = value;
                      });
                    }),
                SettingDivider(),
                Text(
                  "Notifications",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 26),
                ),
                SwitchSetting(
                    settingName: "Setting 2",
                    settingDescription:
                        "This is the second setting description in the app",
                    settingsValue: settings['Setting 2'],
                    onChanged: (value) {
                      setState(() {
                        settings['Setting 2'] = value;
                      });
                    }),
                SettingDivider(),
                RadioSetting(
                  optionsList: ["Option 1", "Option 2", "Option 3"],
                )
              ]))
    ]);
  }
}
