import 'package:flutter/material.dart';
import 'package:vk/vk.dart';

class VkPage extends StatefulWidget {
  const VkPage({Key? key}) : super(key: key);

  @override
  _VkPageState createState() => _VkPageState();
}

class _VkPageState extends State<VkPage> {
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
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                  decoration: const InputDecoration(
                    labelText: 'Input text',
                    labelStyle: TextStyle(color: Colors.black54),
                    filled: true,
                    fillColor: Colors.black12,
                    border: OutlineInputBorder(),
                  ),
                )),
            SwitchListTile(
              title: Text('Keyboard Type = ' + (isNumericMode ? 'VirtualKeyboardType.Numeric' : 'VirtualKeyboardType.Alphanumeric')),
              value: isNumericMode,
              onChanged: (val) => setState(() => isNumericMode = val),
            ),
            Expanded(child: Container()),
            Container(
              color: Colors.grey.shade900,
              child: VirtualKeyboard(
                height: 400,
                type: isNumericMode ? VirtualKeyboardType.Numeric : VirtualKeyboardType.Alphanumeric,
                textController: _controllerText,
                alwaysCaps: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
