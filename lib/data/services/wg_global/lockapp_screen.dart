import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';

class LockAppScreen extends StatefulWidget {
  const LockAppScreen({Key? key}) : super(key: key);

  @override
  _LockAppScreenState createState() => _LockAppScreenState();
}

class _LockAppScreenState extends State<LockAppScreen> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              key: const Key('PasswordField'),
              controller: _textEditingController,
            ),
            ElevatedButton(
              key: const Key('UnlockButton'),
              child: const Text('Go'),
              onPressed: () {
                if (_textEditingController.text == '0000') {
                  AppLock.of(context)?.didUnlock('some data');
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
