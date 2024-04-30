import 'package:flutter/material.dart';

class DropDownField extends StatelessWidget {
  final void Function(String?)? onSelected;
  final String dropdownValue;
  final List<String> dropdownList;

  const DropDownField({
    super.key,
    required this.onSelected,
    required this.dropdownValue,
    required this.dropdownList,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.keyboard_arrow_down),
      underline: Container(),
      onChanged: onSelected,
      items: dropdownList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
