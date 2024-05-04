// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'settings_widgets.dart';

/// Creates [_SettingsPageState]
///
/// Has attributes [email], [settings], [activeColorScheme]
class SettingsPage extends StatefulWidget {
  const SettingsPage(
      {required this.email,
      required this.settings,
      required this.activeColorScheme,
      super.key});

  final String email;
  final Map<String, dynamic> settings;
  final ColorScheme activeColorScheme;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

/// Creates widgets and Calls [RadioSetting] from settings_widgets.dart to allow user to edit visual settings of app
///
/// Defines methods: [saveSettingsToFireBase], [checkDisplayMode], [confirmationDialog]
class _SettingsPageState extends State<SettingsPage> {
  Future<void> saveSettingsToFireBase(email, settings) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference profileRef = db
        .collection('Profiles')
        .doc('$email')
        .collection('User')
        .doc('Settings');
    await profileRef.set(settings);
  }

  void checkDisplayMode(email, settings) {
    final displayMode = widget.settings["Display Mode"];
    switch (displayMode) {
      case "Dark Mode":
        saveSettingsToFireBase(email, settings);
        confirmationDialog("Changes Saved", "Please restart application to apply changes");
        break;
      case "Light Mode":
        saveSettingsToFireBase(email, settings);
        confirmationDialog("Changes Saved", "Please restart application to apply changes");
        break;
      case "High Contrast Mode":
        saveSettingsToFireBase(email, settings);
        confirmationDialog("Changes Saved", "Please restart application to apply changes");
        break;
      default:
        confirmationDialog("Error", "Invalid display mode");
    }
  }

  void confirmationDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.from(colorScheme: widget.activeColorScheme),
      child: Container(
        color: widget.activeColorScheme.background,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                  child: Container(
                color: widget.activeColorScheme.background,
                child: Column(children: <Widget>[
                  Row(children: <Widget>[
                    Expanded(
                        child: Container(
                      color: widget.activeColorScheme.inversePrimary,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("Settings",
                            style: TextStyle(
                                fontSize: 36,
                                color: widget.activeColorScheme.onBackground,
                                backgroundColor:
                                    widget.activeColorScheme.inversePrimary)),
                      ),
                    ))
                  ]),
                  Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Display",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 26,
                                  color: widget.activeColorScheme.onBackground),
                            ),
                            RadioSetting(
                                settingName: "Display Mode",
                                optionsList: const [
                                  "Light Mode",
                                  "Dark Mode",
                                  "High Contrast Mode",
                                ],
                                defaultOption: widget.settings['Display Mode'],
                                onChanged: (selectedOption) {
                                  setState(() {
                                    widget.settings['Display Mode'] =
                                        selectedOption;
                                  });
                                },
                                colorScheme: widget.activeColorScheme),
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
                checkDisplayMode(widget.email, widget.settings);
              },
              child: Text(
                'Save Changes',
                style: TextStyle(color: widget.activeColorScheme.onBackground),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
