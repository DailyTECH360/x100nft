import 'package:flutter/material.dart';

class DropdownPicker extends StatelessWidget {
  const DropdownPicker({Key? key, this.menuOptions, this.selectedOption, this.onChanged}) : super(key: key);

  final List<dynamic>? menuOptions;
  final String? selectedOption;
  final void Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      items: menuOptions!
          .map((data) => DropdownMenuItem<String>(
                child: Row(
                  children: [
                    SizedBox(width: 30, child: Image.asset(data.flag)),
                    const SizedBox(width: 5),
                    Text(data.value),
                  ],
                ),
                value: data.key,
              ))
          .toList(),
      value: selectedOption,
      onChanged: onChanged,
      iconEnabledColor: Colors.blueAccent,
      underline: const SizedBox(),
      dropdownColor: Colors.blueAccent,
      style:const TextStyle(color: Colors.white, fontSize: 13),
    );
  }
}
