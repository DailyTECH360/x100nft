import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../data/models/up_model.dart';
import '../../data/services/services.dart';
import '../../data/utils.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // debugPrint('refGet: ${LocalStore.storeRead(key: 'ref')}');
    return Container(
      decoration: const BoxDecoration(image: AppColors.bgLotus),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          // appBar: AppBar(title: const Text("Quà 1")),
          body: Center(
              child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                Wg.logoBoxCircle(pic: 'assets/brand/192.png', maxH: 120, padding: 10, color: Colors.black54, func: () => Get.toNamed('/join')),
                const SizedBox(height: 16),
                FutureBuilder<DocumentSnapshot<Map<String, dynamic>?>?>(
                  future: getAnyDB(coll: 'usersP', docId: LocalStore.storeRead(key: 'ref') != '' ? LocalStore.storeRead(key: 'ref') : 'uuRPOwBk'),
                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>?>?> snapshot) {
                    // debugPrint('2');
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // debugPrint('3');
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      if (snapshot.error != null) {
                        // debugPrint('4');
                        return Center(
                          child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.orangeAccent)),
                        );
                      } else {
                        // debugPrint(ok);
                        UserPModel uData = UserPModel.fromDocumentSnapshot(doc: snapshot.data!.data()!);
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(uData.name!, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
                            const RefWg(),
                            Visibility(
                              visible: uData.info! != '',
                              child: Text(uData.info!, textAlign: TextAlign.center, style: GoogleFonts.getFont('Delius', color: CustomColors.gray)),
                            ),
                            AnimatedTextKit(
                              repeatForever: true,
                              pause: const Duration(seconds: 2),
                              animatedTexts: [
                                TyperAnimatedText(uData.bio!, textAlign: TextAlign.center, textStyle: GoogleFonts.getFont('Delius', color: CustomColors.gray)),
                              ],
                            ),
                            const Divider(height: 32, color: Colors.white12, thickness: 1),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text('Phone', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w100)),
                                    SizedBox(height: 14),
                                    Text('Email', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w100)),
                                    SizedBox(height: 14),
                                    Text('Facebook', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w100)),
                                    SizedBox(height: 14),
                                    Text('Telegram', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w100)),
                                    SizedBox(height: 14),
                                    Text('Zalo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w100)),
                                  ],
                                ),
                                const SizedBox(width: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(color: Colors.black12, shape: BoxShape.circle, border: Border.all(width: 1, color: Colors.white54)),
                                        child: const Icon(Icons.phone_outlined, size: 18, color: Colors.white)),
                                    Container(height: 5, width: 5, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white)),
                                    // const SizedBox(height: 3),
                                    Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(color: Colors.black12, shape: BoxShape.circle, border: Border.all(width: 1, color: Colors.white54)),
                                        child: const Icon(Icons.mail_outline, size: 18, color: Colors.white)),
                                    Container(height: 5, width: 5, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white)),
                                    // const SizedBox(height: 3),
                                    Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(color: Colors.black12, shape: BoxShape.circle, border: Border.all(width: 1, color: Colors.white54)),
                                        child: const Icon(Icons.public_outlined, size: 18, color: Colors.white)),
                                    Container(height: 5, width: 5, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white)),
                                    // const SizedBox(height: 3),
                                    Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(color: Colors.black12, shape: BoxShape.circle, border: Border.all(width: 1, color: Colors.white54)),
                                        child: const Icon(Icons.public_outlined, size: 18, color: Colors.white)),
                                    Container(height: 5, width: 5, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white)),
                                    // const SizedBox(height: 3),
                                    Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(color: Colors.black12, shape: BoxShape.circle, border: Border.all(width: 1, color: Colors.white54)),
                                        child: const Icon(Icons.public_outlined, size: 18, color: Colors.white)),
                                  ],
                                ),
                                const SizedBox(width: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () => launchUrl(context, url: 'tel: ${uData.phone!}'),
                                      child: Text(stringDot(text: uData.phone!, before: 3, after: 4),
                                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic)),
                                    ),
                                    const SizedBox(height: 14),
                                    InkWell(
                                      onTap: () => launchUrl(context, url: 'mailto: ${uData.email!}?subject=Hi! ${uData.name!}&body=Dear! Bạn tôi...'),
                                      child: Text(stringDot(text: uData.email!, before: 2, after: 10),
                                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic)),
                                    ),
                                    const SizedBox(height: 14),
                                    InkWell(
                                        onTap: () => linkOpen(context, url: uData.fb!),
                                        child: Text(stringDot(text: uData.fb!, before: 10, after: 10),
                                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic))),
                                    const SizedBox(height: 14),
                                    InkWell(
                                        onTap: () => linkOpen(context, url: uData.tele!),
                                        child: Text(stringDot(text: uData.tele!, before: 10, after: 10),
                                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic))),
                                    const SizedBox(height: 14),
                                    InkWell(
                                        onTap: () => linkOpen(context, url: uData.zalo!),
                                        child: Text(stringDot(text: uData.zalo!, before: 10, after: 10),
                                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic))),
                                  ],
                                )
                              ],
                            ),
                            const Divider(height: 32, color: Colors.white12, thickness: 1),
                            IconButton(icon: const Icon(Icons.favorite, color: Colors.redAccent), onPressed: () => Get.toNamed('/join')),
                            const SizedBox(height: 8),
                            QrImage(data: uData.phone!, version: QrVersions.auto, size: 210, backgroundColor: Colors.white54),
                          ],
                        );
                      }
                    }
                  },
                ),
                const SizedBox(height: 64),
              ],
            ),
          ))),
    );
  }
}
