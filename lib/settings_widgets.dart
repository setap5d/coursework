import 'package:flutter/material.dart';

class SwitchSetting extends StatefulWidget {
  final String settingName;
  final String settingDescription;
  bool settingsValue;
  final ValueChanged<bool>? onChanged;

  SwitchSetting(
      {super.key,
      required this.settingName,
      this.settingDescription = "",
      required this.settingsValue,
      this.onChanged});
  @override
  _SwitchSettingState createState() => _SwitchSettingState();
}

class _SwitchSettingState extends State<SwitchSetting> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.settingName,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),
            Text(widget.settingDescription,
                style: const TextStyle(fontSize: 18)),
          ],
        ),
        Expanded(child: Container()),
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Switch(
            // This bool value toggles the switch.
            value: widget.settingsValue,
            activeColor: Colors.green,
            onChanged: (bool value) {
              // This is called when the user toggles the switch.
              setState(() {
                widget.settingsValue = value;
                widget.onChanged!(value);
              });
            },
          ),
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

// enum SettingOptions { lafayette, jefferson }

// List<String> optionsList = ["Option 1", "Option 2", "Option 3"];

class RadioSetting extends StatefulWidget {
  final String settingName;
  final List<String> optionsList;
  final Function(String) onChanged;

  const RadioSetting(
      {super.key,
      required this.settingName,
      required this.optionsList,
      required this.onChanged});

  @override
  State<RadioSetting> createState() => _RadioSettingState(
      settingName, optionsList); //FLUTTER DOESN'T LIKE THIS LINE
}

class _RadioSettingState extends State<RadioSetting> {
  final String settingName;
  final List<String> optionsList;
  String selectedOption = "";

  _RadioSettingState(this.settingName, this.optionsList);
  @override
  void initState() {
    super.initState();
    selectedOption = optionsList[0];
  }

  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.settingName,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        Column(
          children: optionsList.map((option) {
            return ListTile(
              title: Text(option, style: const TextStyle(fontSize: 18)),
              leading: Radio<String>(
                value: option,
                groupValue: selectedOption,
                onChanged: (value) {
                  setState(() {
                    selectedOption = value as String;
                    widget.onChanged(selectedOption);
                  });
                },
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
