import 'package:file_picker/file_picker.dart';
import 'package:firebase/firebase.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart';

import '../../data/services/services.dart';
import '../../data/user_ctr.dart';
import '../../data/utils.dart';

class KycCtrST extends GetxController {
  RxInt step = RxInt(1);

  Rx<String> picFrontIdUrl = Rx<String>('');
  Rx<String> picBehindIdUrl = Rx<String>('');
  Rx<String> picSelfIdUrl = Rx<String>('');

  Future<void> imagePickerUpload(String picName) async {
    Loading.show(text: 'Image upload...', textSub: '$notCloseApp!');
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      String? _mimeType = mime(basename(result.files.single.name));
      debugPrint('result.name: ${result.files.single.name}');
      debugPrint('basename: ${basename(result.files.single.name)}');
      debugPrint("contentType: $_mimeType");
      var _metaData = UploadMetadata(contentType: _mimeType);

      await uploadFile(
        mediaBytes: result.files.single.bytes,
        fileName: picName + '.${basename(result.files.single.name).split(".").last}',
        metadata: _metaData,
        ref: 'kycImages',
      ).whenComplete(() => Loading.hide());
    } else {
      Loading.hide();
    }
    return;
  }

  // Upfile to FB Storage
  Future<void> uploadFile({mediaBytes, String? fileName, UploadMetadata? metadata, String? ref}) async {
    try {
      StorageReference _storageReference = storage().ref(ref).child('${UserCtr.to.userAuth!.uid}_$fileName');
      UploadTaskSnapshot _uploadTaskSnapshot = await _storageReference.put(mediaBytes, metadata).future;
      // debugPrint("ref: ${_uploadTaskSnapshot.jsObject.ref}");
      // debugPrint("state: ${_uploadTaskSnapshot.state}");
      // debugPrint("bytesTransferred: ${_uploadTaskSnapshot.bytesTransferred}");
      // debugPrint("onStateChanged.length ${_uploadTaskSnapshot.task.onStateChanged.length}");
      // Uri _imageUri = await _uploadTaskSnapshot.ref.getDownloadURL();
      // debugPrint('Download URL: $_imageUri');
      if ('${_uploadTaskSnapshot.state}' == 'TaskState.SUCCESS') {
        Future.delayed(const Duration(seconds: 3), () async {
          await downloadPicURL(UserCtr.to.userAuth!.uid, fileName!.split(".").first);
        });
      }
    } catch (e) {
      debugPrint('File Upload Error: $e');
    }
  }

  Future<String> downloadPicURL(String uid, String fileName) async {
    String picPath = 'kycImages/${uid}_${fileName}_700x700.jpeg';
    debugPrint(picPath);
    String downloadURL = await firebase_storage.FirebaseStorage.instance.ref(picPath).getDownloadURL();
    debugPrint(downloadURL);
    if (downloadURL.isNotEmpty && downloadURL != '') {
      if (fileName == 'picFrontIdUrl') {
        picFrontIdUrl.value = downloadURL;
        await updateUserDB(uid: UserCtr.to.userDB!.uid!, data: {'picFrontIdUrl': downloadURL});
      }
      if (fileName == 'picBehindIdUrl') {
        picBehindIdUrl.value = downloadURL;
        await updateUserDB(uid: UserCtr.to.userDB!.uid!, data: {'picBehindIdUrl': downloadURL});
      }
      if (fileName == 'picSelfIdUrl') {
        picSelfIdUrl.value = downloadURL;
        await updateUserDB(uid: UserCtr.to.userDB!.uid!, data: {'picSelfIdUrl': downloadURL});
      }
    } else {
      await updateUserDB(uid: UserCtr.to.userDB!.uid!, data: {'picFrontIdUrl': '', 'picBehindIdUrl': '', 'picSelfIdUrl': ''});
    }
    // Within your widgets:
    // Image.network(downloadURL);
    return downloadURL;
  }

  // Rx<String> dropdownValue = Rx<String>('Vietnam');

  // Rx<List<Countries>> _listCountry = Rx<List<Countries>>([]);
  // List<Countries> get listCountry => _listCountry.value;

  // @override
  // void dispose() {
  //   step.value = 1;
  //   _listCountry.value = <Countries>[];
  //   super.dispose();
  // }

  // Future<void> readJson() async {
  //   final String response = await rootBundle.loadString('countries.json');
  //   _listCountry.value = countriesFromJson(response);
  // }
}
