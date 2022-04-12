import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/utils.dart';

class SanPham extends StatelessWidget {
  const SanPham({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primaryDeep,
        // appBar: AppBar(title: const Text("Quà 1")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/brand/192.png', height: 120),
              const SizedBox(height: 8),
              const Text("Trang SP", style: TextStyle(color: Colors.white)),
              const Text("Sẳn Phẩm", style: TextStyle(color: Colors.white)),
              const Divider(height: 32, color: Colors.white12, thickness: 1),
              const RefWg(),
              IconButton(icon: const Icon(Icons.login, color: Colors.white), onPressed: () => Get.toNamed('/join')),
            ],
          ),
        ));
  }
}
