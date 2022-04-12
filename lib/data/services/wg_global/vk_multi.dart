import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:virtual_keyboard_flutter/virtual_keyboard_flutter.dart';

class VirtualkeyboardPage extends StatefulWidget {
  final Function(String)? getText;
  const VirtualkeyboardPage({Key? key, this.getText}) : super(key: key);

  @override
  _VirtualkeyboardPageState createState() => _VirtualkeyboardPageState();
}

class _VirtualkeyboardPageState extends State<VirtualkeyboardPage> {
  // Holds the text that user typed.
  String text = '';

  // True if shift enabled.
  bool shiftEnabled = false;

  // is true will show the numeric keyboard.
  bool isNumericMode = false;

  late TextEditingController _controllerText;

  @override
  void initState() {
    _controllerText = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Input text'.toUpperCase())),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: _controllerText,
                keyboardType: TextInputType.none, // Disable the default soft keybaord
                showCursor: false,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                decoration: const InputDecoration(
                  labelText: 'Input text',
                  labelStyle: TextStyle(color: Colors.black54),
                  filled: true,
                  fillColor: Colors.black12,
                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1), borderRadius: BorderRadius.all(Radius.circular(6))),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                ),
              ),
            ),
            SwitchListTile(
              title: Text('Keyboard Type: ' + (isNumericMode ? 'Numeric' : 'Alphanumeric')),
              value: isNumericMode,
              onChanged: (val) => setState(() => isNumericMode = val),
            ),
            Expanded(child: Container()),
            Container(
              color: Colors.deepPurple,
              child: VirtualKeyboard(
                height: 300,
                fontSize: 14,
                textColor: Colors.white,
                type: isNumericMode ? VirtualKeyboardType.Numeric : VirtualKeyboardType.Alphanumeric,
                textController: _controllerText,
                alwaysCaps: true,
                onKeyPress: _onKeyPress,
                // builder: _builder,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _builder(BuildContext context, VirtualKeyboardKey key) {
  //   Widget keyWidget;

  //   switch (key.keyType) {
  //     case VirtualKeyboardKeyType.String:
  //       // Draw String key.
  //       keyWidget = _keyboardDefaultKey(key);
  //       break;
  //     case VirtualKeyboardKeyType.Action:
  //       // Draw action key.
  //       keyWidget = _keyboardDefaultActionKey(key);
  //       break;
  //   }

  //   return keyWidget;
  // }

  // Fired when the virtual keyboard key is pressed.
  _onKeyPress(VirtualKeyboardKey key) {
    if (key.keyType == VirtualKeyboardKeyType.String) {
      _controllerText.text += (shiftEnabled ? key.capsText! : key.text!);
    } else if (key.keyType == VirtualKeyboardKeyType.Action) {
      switch (key.action) {
        case VirtualKeyboardKeyAction.Backspace:
          if (_controllerText.text.isEmpty) return;
          _controllerText.text = _controllerText.text.substring(0, _controllerText.text.length - 1);
          break;
        case VirtualKeyboardKeyAction.Return:
          // _controllerText.text = _controllerText.text + '\n';
          widget.getText!(_controllerText.text);
          Get.back();
          break;
        case VirtualKeyboardKeyAction.Space:
          _controllerText.text = _controllerText.text + key.text!;
          break;
        case VirtualKeyboardKeyAction.Shift:
          shiftEnabled = !shiftEnabled;
          break;
        default:
      }
    }
// Update the screen
    setState(() {});
  }
}
