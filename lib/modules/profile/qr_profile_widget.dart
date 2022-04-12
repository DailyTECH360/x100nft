import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/utils.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../data/user_ctr.dart';

class QrProfile extends StatelessWidget {
  const QrProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      color: Colors.black12,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GetX<UserCtr>(
          builder: (_) {
            if (_.userDB != null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  QrImage(data: _.userDB!.refCode!.toLowerCase(), version: QrVersions.auto, size: 210, backgroundColor: Colors.white54),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Wg.textDot(
                          before: 3,
                          after: 5,
                          text: _.userDB!.refCode!.toLowerCase(),
                          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 5),
                      InkWell(
                        child: const Icon(Icons.copy, color: Colors.white, size: 16),
                        onTap: () {
                          if (copyToClipboardHack(_.userDB!.refCode!.toLowerCase())) {
                            Get.snackbar('Copy RefCode: ', _.userDB!.refCode!.toLowerCase(), snackPosition: SnackPosition.TOP, backgroundColor: Colors.white);
                          }
                        },
                      )
                    ],
                  ),
                  refLinkWg(reLink: UserCtr.to.reLink),
                ],
              );
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
