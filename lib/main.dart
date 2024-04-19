import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:setaplogin/myHomePage.dart';
import 'package:setaplogin/profile.dart';
import 'package:setaplogin/task_page.dart';
import 'firebase_options.dart';
import 'projectFormat.dart';
import 'settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.web,
  );
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginRegisterScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginRegisterScreen extends StatefulWidget {
  const LoginRegisterScreen({Key? key}) : super(key: key);

  @override
  _LoginRegisterScreenState createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  bool _showLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: _showLogin ? LoginScreen() : RegisterScreen(),
        ),
      ),
      floatingActionButton: null,
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 400,
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                Text(
                  'The App',
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                LoginForm(),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account? ',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterScreen()),
                        );
                      },
                      child: Text(
                        'Register Here',
                        style: TextStyle(fontSize: 20, color: Colors.blue),
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
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  Future getProfileInfo(email) async {
    //Gets profile information for the profile page, needs to be initialised on build/before screen move
    FirebaseFirestore db = FirebaseFirestore.instance;
    List<dynamic> profDetails = [];
    var profRef = await db.collection('Profiles').doc(email).get();
    profDetails.add(profRef.get('First Name'));
    profDetails.add(profRef.get('Last Name'));
    profDetails.add(email);
    profDetails.add(profRef.get('Phone Number'));
    profDetails.add(profRef.get('Skills'));
    return profDetails;
  }

  Future getSettingsFromFireBase(email) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    //Map<String, dynamic> settings = {};
    Map<String, dynamic> data = {};
    await db
        .collection('Profiles')
        .doc('$email')
        .collection('User')
        .doc('Settings')
        .snapshots()
        .listen((snapshot) async {
      data = snapshot.data() as Map<String, dynamic>;
      /* settings = {
        'Display Mode': data['Display Mode'],
        'Project Deadline Notifications':
            data['Project Deadline Notifications'],
        'Task Deadline Notifications': data['Task Deadline Notifications'],
        'Ticket Notifications': data['Ticket Notifications']
      }; */
    });
    await Future.delayed(const Duration(milliseconds: 100));
    return Future.value(data);
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    List<dynamic> projectIDs = [];
    List<Project> projects = [];
    List<dynamic> profDetails = [];
    Map<String, dynamic> settings = {};

    return Column(
      children: [
        TextFormField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          controller: passwordController,
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: Icon(Icons.lock),
          ),
          obscureText: true,
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Forgot your password? ',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PasswordResetPage()),
                );
              },
              child: Text(
                'Reset it here',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () async {
              final profileSnapshot = await FirebaseFirestore.instance
                  .collection('Profiles')
                  .doc(emailController.text)
                  .get();
              if (profileSnapshot.exists) {
                if (profileSnapshot.get('Password') ==
                    passwordController.text) {
                  projectIDs = profileSnapshot.get('Project IDs');
                  projects = [];
                  for (int i = 0; i < projectIDs.length; i++) {
                    Project newProject = Project();
                    final projectSnapshot = await FirebaseFirestore.instance
                        .collection('Projects')
                        .doc(projectIDs[i])
                        .get();
                    newProject.projectName = projectSnapshot.get('Title');
                    newProject.deadline = projectSnapshot.get('Deadline');
                    newProject.leader = projectSnapshot.get('Project Leader');
                    projects.add(newProject);
                  }
                  profDetails = await getProfileInfo(emailController.text);
                  settings =
                      await getSettingsFromFireBase(emailController.text);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsPage(
                        title: 'My Projects',
                        email: emailController.text,
                        projectIDs: projectIDs,
                        projects: projects,
                        profDetails: profDetails,
                        settings: settings,
                      ),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Password Incorrect.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Error'),
                      content: Text('Email does not exist.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            child: Text(
              'Login',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController firstNameController = TextEditingController();
    final TextEditingController lastNameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final List<String> placeholder = [];

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'The App',
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: firstNameController,
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: TextFormField(
                        controller: lastNameController,
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        final fullName =
                            '${firstNameController.text} ${lastNameController.text}';

                        final fullNameSnapshot = await FirebaseFirestore
                            .instance
                            .collection('Profiles')
                            .where('Full Name', isEqualTo: fullName)
                            .get();

                        if (fullNameSnapshot.docs.isNotEmpty) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Error'),
                                content:
                                    Text('This name is already registered.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                          return;
                        }

                        final emailSnapshot = await FirebaseFirestore.instance
                            .collection('Profiles')
                            .doc(emailController.text)
                            .get();

                        if (emailSnapshot.exists) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Error'),
                                content: Text('Email is already in use.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                          return;
                        }

                        await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text,
                        );

                        await FirebaseFirestore.instance
                            .collection('Profiles')
                            .doc(emailController.text)
                            .set({
                          'First Name': firstNameController.text,
                          'Last Name': lastNameController.text,
                          'Password': passwordController.text,
                          'Phone Number': '',
                          'Skills': '',
                          'Project IDs': placeholder
                        });
                        await FirebaseFirestore.instance
                            .collection('Profiles')
                            .doc(emailController.text)
                            .collection('User')
                            .doc('Settings')
                            .set({
                          'Display Mode': 'Light Mode',
                          'Project Deadline Notifications': true,
                          'Task Deadline Notifications': true,
                          'Ticket Notifications': true
                        });
                        await FirebaseFirestore.instance
                            .collection('Profiles')
                            .doc(emailController.text)
                            .collection('User')
                            .doc('ProfilePic')
                            .set({"Download URL": null});

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      } catch (e) {
                        print(e.toString());
                      }
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Login Here',
                        style: TextStyle(fontSize: 20, color: Colors.blue),
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
  }
}

class PasswordResetPage extends StatelessWidget {
  const PasswordResetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    String dialogText = '';
    String titleMessage = '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter your email to reset your password',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 400,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // password reset functionality goes here
                final emailSnapshot = await FirebaseFirestore.instance
                    .collection('Profiles')
                    .doc(emailController.text)
                    .get();
                if (emailSnapshot.exists) {
                  dialogText = 'Password reset email sent';
                  titleMessage = 'Success!';
                } else {
                  dialogText = 'Email does not exist';
                  titleMessage = 'Error!';
                }
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(titleMessage),
                      content: Text(dialogText),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
