import 'package:flutter/material.dart';
import '../../utils.dart';

class LDropDown extends StatefulWidget {
  const LDropDown({Key? key}) : super(key: key);

  @override
  _LDropDownState createState() => _LDropDownState();
}

class _LDropDownState extends State<LDropDown> {
  List<String> dropdownItems = <String>['1', "Red", "Yellow", "Blue", "Pink", "Orange"];
  String? dropdownValue = "Green";
  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButton<String>(
        value: dropdownValue,
        elevation: 8,
        iconSize: 36,
        icon: Icon(Icons.arrow_drop_down, color: AppColors.primaryLight),
        style: TextStyle(color: AppColors.primarySwatch),
        dropdownColor: AppColors.primaryDeep,
        underline: const SizedBox(),
        onChanged: (String? newValue) {
          setState(() {
            dropdownValue = newValue;
          });
        },
        items: dropdownItems.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
