// ignore_for_file: use_build_context_synchronously, await_only_futures, library_private_types_in_public_api, empty_catches

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'project_format.dart';
import 'navigation.dart';

/// Initialises GUI using [WidgetsFlutterBinding] and database
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.web,
  );
  runApp(const MainApp());
}

/// Returns [MaterialApp] and calls [LoginRegisterScreen] to build first set of widgets
class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginRegisterScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// Creates [_LoginRegisterScreenState]
class LoginRegisterScreen extends StatefulWidget {
  const LoginRegisterScreen({Key? key}) : super(key: key);

  @override
  _LoginRegisterScreenState createState() => _LoginRegisterScreenState();
}

/// Determines whether [LoginScreen] or [RegisterScreen] is displayed using [showLogin]
class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  final bool showLogin = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: showLogin ? const LoginScreen() : const RegisterScreen(),
        ),
      ),
      floatingActionButton: null,
    );
  }
}

/// Builds widgets to help format the GUI
///
/// Calls [LoginForm] to build widgets that allow for user input
/// Defines method: [switchToRegister]
class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void switchToRegister() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RegisterScreen()),
      );
    }

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
                const SizedBox(height: 50),
                const Text(
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
                const LoginForm(),
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
                      // Allows user to call [switchToRegister]
                      onTap: (switchToRegister),
                      child: const Text(
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

/// Builds widgets to allow the user to log in
///
/// Builds part of the login screen that allows user to enter an email and password and attempt to log in
/// Defines methods: [getProfileInfo], [getSettingsFromFireBase], [switchToPasswordReset], [checkLoginDetails]
class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  // Gets profile information for the profile page, needs to be initialised on build/before screen move
  Future getProfileInfo(email) async {
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

  // Gets settings information for app colorScheme
  Future getSettingsFromFireBase(email) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    Map<String, dynamic> data = {};
    await db
        .collection('Profiles')
        .doc('$email')
        .collection('User')
        .doc('Settings')
        .snapshots()
        .listen((snapshot) async {
      data = snapshot.data() as Map<String, dynamic>;
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

    // Switches to PasswordResetPage
    void switchToPasswordReset() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PasswordResetPage()),
      );
    }

    // Compares user input email and password with actual values in database switching to [NavigationPage] if values match
    void checkLoginDetails() async {
      final profileSnapshot = await FirebaseFirestore.instance
          .collection('Profiles')
          .doc(emailController.text)
          .get();
      if (profileSnapshot.exists) {
        if (profileSnapshot.get('Password') == passwordController.text) {
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
          settings = await getSettingsFromFireBase(emailController.text);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NavigationPage(
                email: emailController.text,
                projectIDs: projectIDs,
                projects: projects,
                profDetails: profDetails,
                settings: settings,
                selectedIndex: 1,
              ),
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Error'),
                content: const Text('Password Incorrect.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
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
              title: const Text('Error'),
              content: const Text('Email does not exist.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }

    return Column(
      children: [
        //Allows email input
        TextFormField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        //Allows password input
        TextFormField(
          controller: passwordController,
          decoration: const InputDecoration(
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
              onTap: (switchToPasswordReset),
              child: const Text(
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
            onPressed: (checkLoginDetails),
            child: const Text(
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

/// Builds widgets that allow user to create new account
///
/// Builds the register screen allowing users to enter First name, Last name,
///  email, password and password (confirmation)
/// defines methods: [registerNewAccount], [switchToLoginScreen]
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController firstNameController = TextEditingController();
    final TextEditingController lastNameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final List<String> placeholder = [];

    void registerNewAccount() async {
      try {
        final fullName =
            '${firstNameController.text} ${lastNameController.text}';

        final fullNameSnapshot = await FirebaseFirestore.instance
            .collection('Profiles')
            .where('Full Name', isEqualTo: fullName)
            .get();

        if (fullNameSnapshot.docs.isNotEmpty) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Error'),
                content: const Text('This name is already registered.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
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
                title: const Text('Error'),
                content: const Text('Email is already in use.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
          return;
        }

        await FirebaseAuth.instance.createUserWithEmailAndPassword(
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
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } catch (e) {}
    }

    void switchToLoginScreen() {
      Navigator.pop(context);
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
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
                      // Allows first name input
                      child: TextFormField(
                        controller: firstNameController,
                        decoration: const InputDecoration(
                          labelText: 'First Name',
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      // Allows last name input
                      child: TextFormField(
                        controller: lastNameController,
                        decoration: const InputDecoration(
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
                // Allows email input
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                // Allows password input
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                const SizedBox(
                  height: 15,
                ),
                // Allows password (confirmation) input
                TextFormField(
                  decoration: const InputDecoration(
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
                    onPressed: (registerNewAccount),
                    child: const Text(
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
                      onTap: (switchToLoginScreen),
                      child: const Text(
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

/// Build widgets that allow user to reset password
/// 
/// Builds the password reset page to allow the user to enter email
/// Defines methods [resetPassword]
class PasswordResetPage extends StatelessWidget {
  const PasswordResetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    String dialogText = '';
    String titleMessage = '';

    void resetPassword() async {
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
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Enter your email to reset your password',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 400,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: (resetPassword),
              child: const Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
