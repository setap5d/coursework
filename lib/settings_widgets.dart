import 'package:flutter/material.dart';

class SwitchSetting extends StatefulWidget {
  final String settingName;
  final String settingDescription;

  const SwitchSetting({super.key, required this.settingName, this.settingDescription = ""});
  @override
  _SwitchSettingState createState() => _SwitchSettingState();
}

class _SwitchSettingState extends State<SwitchSetting> {
  bool switchActive = true;
  @override
  Widget build(BuildContext context) {
    return Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(16.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                      Text(widget.settingName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),),
                      Text(widget.settingDescription, style: const TextStyle(fontSize: 18)),
                      ],
                      ),
          ),
          Expanded(child: Container()),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Switch(
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
  final List<String> optionsList;

  const RadioSetting({super.key, required this.optionsList});

  @override
  State<RadioSetting> createState() => _RadioSettingState(optionsList);       //FLUTTER DOESN'T LIKE THIS LINE
}

class _RadioSettingState extends State<RadioSetting> {
  // SettingOptions? _character = SettingOptions.lafayette;
  final List<String> optionsList;
  String selectedOption = "";

  _RadioSettingState(this.optionsList);
  // final List<String> optionsList = widget.optionsList;

  @override
  void initState() {
    super.initState();
    selectedOption = optionsList[0];
  }

  Widget build(BuildContext context) {
    return Column(
      children: optionsList.map((option) {
        return ListTile(
          title: Text(option),
          leading: Radio<String>(
            value: option,
            groupValue: selectedOption,
            onChanged: (value) {
              setState(() {
                selectedOption = value!;
              });
            },
          ),
        );
      }).toList(),
      // children: <Widget>[
      //   ListTile(
      //     title: const Text('Lafayette'),
      //     leading: Radio<SettingOptions>(
      //       value: SettingOptions.lafayette,
      //       groupValue: _character,
      //       onChanged: (SettingOptions? value) {
      //         setState(() {
      //           _character = value;
      //         });
      //       },
      //     ),
      //   ),
      //   ListTile(
      //     title: const Text('Thomas Jefferson'),
      //     leading: Radio<SettingOptions>(
      //       value: SettingOptions.jefferson,
      //       groupValue: _character,
      //       onChanged: (SettingOptions? value) {
      //         setState(() {
      //           _character = value;
      //         });
      //       },
      //     ),
      //   ),
      // ],
      );
  }
}