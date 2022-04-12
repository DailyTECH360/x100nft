import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../utils.dart';

class SharePage extends StatelessWidget {
  const SharePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Share page')),
      body: Center(
        child: ElevatedButton(
            child: const Text('Share'),
            onPressed: () {
              Share.share('Share: Our website $webLink');
            }),
      ),
    );
  }
}
