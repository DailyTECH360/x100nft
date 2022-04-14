import 'package:flutter/material.dart';

import '../data/app_color.dart';
// import 'package:get/get.dart';

class SvEndPage extends StatelessWidget {
  const SvEndPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDeep,
      // appBar: AppBar(title: Text('MyPage')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                Image.asset('assets/sv_lock.png', height: 180),
                const SizedBox(height: 16),
                const Text('Server Expiration\nPlease contact support', style: TextStyle(color: Colors.orangeAccent), textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
