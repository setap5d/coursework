import 'package:flutter/material.dart';
import 'package:setup_application/settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 191, 222, 255), brightness: Brightness.light),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int popUpSemaphore = 0;
  int selectedPageIndex = 0;

 void showAccountDetails(BuildContext context) {
    late OverlayEntry overlay;

    if (popUpSemaphore == 1) {
      return;
    }
    popUpSemaphore ++;

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
                Text('Username: Jimothy', 
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).colorScheme.onTertiary,
                  ),
                  ),
                const SizedBox(height: 8),
                Text('Email: jimothy.doe@example.com',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).colorScheme.onTertiary,
                  ),
                  ),
                const SizedBox(height: 16),
                Row(
                  children: 
                  [
                ElevatedButton(
                  onPressed: () {
                    overlay.remove();
                    popUpSemaphore --;
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
                  ),
                  child: Text('Close',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).colorScheme.onTertiaryContainer,
                  ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    overlay.remove();
                    popUpSemaphore --;
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
                  ),
                  child: Text('Logout',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).colorScheme.onTertiaryContainer,
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

  void showNotificationDetails(BuildContext context) {
    late OverlayEntry overlay;

    if (popUpSemaphore == 1) {
      return;
    }
    popUpSemaphore ++;

    final List<String> notifications = [
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

    overlay = OverlayEntry(
      builder: (BuildContext context) => Positioned(
        top: 700, // adjust the top position as needed
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
                Text('Notifications', 
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).colorScheme.onTertiary,
                  ),
                  ),
                const SizedBox(height: 8),
                Text('NOTIFICATIONS_GO_HERE',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).colorScheme.onTertiary,
                  ),
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    child:
                  ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(notifications[index]),
            );
          },
                  ),
                  ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    overlay.remove();
                    popUpSemaphore --;
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
                  ),
                  child: Text('Close',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).colorScheme.onTertiaryContainer,
                  ),
                  ),
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
              leading: FloatingActionButton(onPressed: () {showAccountDetails(context);}, child: const Icon(Icons.account_circle),),
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
              onDestinationSelected: (value) {
                setState(() {
                  selectedPageIndex = value;
                });
                if (value == 1) {
                  showNotificationDetails(context);
                }
                print('selected: $value');
              },
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: _buildPage(selectedPageIndex),
            ),
          ),
        ],
      ),
    );
  }
   Widget _buildPage(int index) {
    // Return the appropriate widget based on the selectedPageIndex
    print("_buildPage triggered");
    switch (index) {
      case 0:
        print("case 0 triggered");
        return ProjectsInterface();
      case 2:
        print("case 2 triggered");
        return SettingsInterface();
      default:
        return Container(); // Default to an empty container or handle the case appropriately
    }
  }
}

class ProjectsInterface extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Row(
        children: [
          Text("PROJECTS_INTERFACE",
          style: Theme.of(context).textTheme.headlineMedium
          )
        ]
      )
    );
  }
}