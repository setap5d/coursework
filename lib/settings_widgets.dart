// ignore_for_file: no_logic_in_create_state, library_private_types_in_public_api

import 'package:flutter/material.dart';

/// Creates [_RadioSettingState]
/// 
/// Has attributes [settingName], [optionsList], [defaultOption], [onChanged], [colorScheme]
class RadioSetting extends StatefulWidget {
  final String settingName;
  final List<String> optionsList;
  final String defaultOption;
  final Function(String) onChanged;
  final ColorScheme colorScheme;

  const RadioSetting(
      {super.key,
      required this.settingName,
      required this.optionsList,
      required this.defaultOption,
      required this.onChanged,
      required this.colorScheme});

  @override
  State<RadioSetting> createState() => _RadioSettingState();
}

/// Builds widget designed to allow users to switch between mutually exclusive options
/// 
/// Widget is built using attributes for the sake of wdiegt reuse in future
class _RadioSettingState extends State<RadioSetting> {
  String selectedOption = "";

  _RadioSettingState();
  @override
  void initState() {
    super.initState();
    if (widget.defaultOption == "Light Mode") {
      selectedOption = widget.optionsList[0];
    } else if (widget.defaultOption == "Dark Mode") {
      selectedOption = widget.optionsList[1];
    } else if (widget.defaultOption == "High Contrast Mode") {
      selectedOption = widget.optionsList[2];
    } else if (widget.defaultOption == "Colour Blind Mode") {
      selectedOption = widget.optionsList[3];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.from(colorScheme: widget.colorScheme),
      child: Container(
        color: widget.colorScheme.background,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.settingName,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),
            Column(
              children: widget.optionsList.map((option) {
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
        ),
      ),
    );
  }
}
