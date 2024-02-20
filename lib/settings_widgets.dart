import 'package:flutter/material.dart';

class SwitchSetting extends StatefulWidget {
  final String settingName;

  const SwitchSetting({super.key, required this.settingName});
  @override
  _SwitchSettingState createState() => _SwitchSettingState();
}

class _SwitchSettingState extends State<SwitchSetting> {
  bool switchActive = true;
  @override
  Widget build(BuildContext context) {
    return Row(
        children: <Widget>[
          Text(widget.settingName),
          Switch(
            // This bool value toggles the switch.
            value: switchActive,
            activeColor: Colors.green,
            onChanged: (bool value) {
              // This is called when the user toggles the switch.
              setState(() {
                switchActive = value;
              });
            },
          ),
        ],
      );
  }
}

class SettingDivider extends StatelessWidget {
  const SettingDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
        height: 20,
        thickness: 5,
        indent: 20,
        endIndent: 20,
        color: Theme.of(context).colorScheme.onBackground,
      );
  }
}