import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/user_ctr.dart';
import '../../data/utils.dart';

class SupportPage extends GetView<UserCtr> {
  const SupportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDeep,
      appBar: AppBar(title: Text('$brandName Support')),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Icon(Icons.support_agent, size: 100, color: Colors.white24),
                Text('Information support channels of \n$brandName', style: TextStyle(color: AppColors.primarySwatch), textAlign: TextAlign.center),
                const Divider(color: Colors.white30, height: 20, thickness: 1),
                Wg.linkCon(
                  title: webLink,
                  subtitle: 'Official website',
                  pic: 'assets/brand/192.png',
                  link: webLink,
                ),
                // const SizedBox(height: 8),
                // Wg.linkCon(
                //   title: '$symbolToken on $scanName',
                //   subtitle: 'Smartcontract on blockchain',
                //   pic: scanLogo,
                //   link: scTokenLink,
                // ),
                const SizedBox(height: 8),
                Wg.linkCon(
                  title: '$symbolToken Email support',
                  subtitle: emailSupport,
                  pic: 'assets/kyc/email.png',
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: const CopyRightVersion(),
    );
  }
}
