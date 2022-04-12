import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/models.dart';
import '../utils.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Timestamp now = Timestamp.now();
int nowMilis = Timestamp.now().millisecondsSinceEpoch;

Future<void> deleteAny({required String coll, required String docId}) async {
  return await _firestore.collection(coll).doc(docId).delete();
}

// CREATE USER DATA:
Future<bool> createNewUserDB({required String uid, required data}) async {
  try {
    await _firestore.collection('users').doc(uid).set(data);
    return true;
  } catch (e) {
    debugPrint('$e');
    return false;
  }
}

// UPDATE USER DATA:
Future<bool> updateUserDB({required String uid, required data}) async {
  try {
    _firestore.collection('users').doc(uid).set(data, SetOptions(merge: true));
    return true;
  } catch (e) {
    debugPrint('$e');
    return false;
  }
}

// UPDATE USER LOGIN TIME:
Future<bool> updateLoginTimeIp({required String uid}) async {
  try {
    String myIp = await getMyIp();
    _firestore.collection('users').doc(uid).set({
      'timeLogin': now,
      'ipLogin': myIp,
    }, SetOptions(merge: true)).whenComplete(() => debugPrint('Uid:...${uid.substring(uid.length - 5)} LoginTime: ${Timestamp.now().toDate()}'));
    return true;
  } catch (e) {
    debugPrint('$e');
    return false;
  }
}

Future<bool> updateAnyField({required String coll, required String docId, required data}) async {
  try {
    _firestore.collection(coll).doc(docId).set(data, SetOptions(merge: true));
    return true;
  } catch (e) {
    debugPrint('$e');
    return false;
  }
}

Future<String> addDocToCollDynamic({required String coll, required data}) async => _firestore.collection(coll).add(data).then((value) => value.id);

Future<bool> addDocToSubCollAnyField({required String coll, String? field, required String collSub, required data}) async {
  try {
    _firestore.collection(coll).doc(field).collection(collSub).add(data);
    return true;
  } catch (e) {
    debugPrint('$e');
    return false;
  }
}

Future<void> initPack() async {
  await _firestore.collection('packages').add({
    'number': 0,
    'minInvest': 500,
    'cycleDay': 90,
    'rateD': 0.5,
    'run': true,
    'textNoRun': '',
    'timeRun': now,
  });
}

// GET USER DATA:
Future<UserModel?> getUserDB({required String uid}) async {
  try {
    debugPrint('GetDB uid: ${stringDot(text: uid)}');
    return await _firestore.collection('users').doc(uid).get().then((value) {
      if (value.exists) {
        return UserModel.fromDocumentSnapshot(documentSnapshot: value);
      } else {
        return null;
      }
    });
  } catch (e) {
    debugPrint('Error: $e');
    return null;
    // rethrow;
  }
}

// GET USER STREAM:
Stream<UserModel>? getUserStream({required String uid}) {
  try {
    debugPrint('Stream uid: ${stringDot(text: uid)}');
    return _firestore.collection('users').doc(uid).snapshots().map((DocumentSnapshot<Map<String, dynamic>> snap) => UserModel.fromDocumentSnapshot(documentSnapshot: snap));
  } catch (e) {
    debugPrint('Error: $e');
    return null;
    // rethrow;
  }
}

// GET STREAM SETTING:
Stream<SetModel>? setStream() {
  try {
    return _firestore.collection('settings').doc('set').snapshots().map((DocumentSnapshot<Map<String, dynamic>> snap) {
      return SetModel.fromDocumentSnapshot(documentSnapshot: snap);
    });
  } catch (e) {
    debugPrint('Error: $e');
    return null;
    // rethrow;
  }
}

Future<DocumentSnapshot<Map<String, dynamic>>> getAnyDB({required String coll, required String docId}) async {
  return await _firestore.collection(coll).doc(docId).get();
}

Future<QuerySnapshot<Map<String, dynamic>>> getAnyCollList({required String coll, required String by}) async {
  return _firestore.collection(coll).orderBy(by).get();
}

// FIND USER:
Future<UserModel?> findFirstUser({required String by}) async {
  UserModel? userResult;
  String byOk = splitRefUrl(textInput: by);
  String refCodeLow = by.trim().toLowerCase();
  if (by != '') {
    Loading.show(text: 'User find...', textSub: '$notCloseApp!');
    await _firestore
        .collection('users')
        .where(
            byOk.isEmail
                ? 'email'
                : byOk.isPhoneNumber
                    ? 'phone'
                    : 'refCode',
            isEqualTo: refCodeLow)
        .get()
        .then((documentSnapshot) {
      if (documentSnapshot.docs.isNotEmpty) {
        userResult = UserModel.fromDocumentSnapshot(documentSnapshot: documentSnapshot.docs.first);
      } else {
        userResult = null;
      }
    });
    Loading.hide();
    return userResult;
  } else {
    userResult = null;
  }
  return userResult;
}

Future<List<UserModel>> findUserAnyFieldToList({required String whereField, required String whereValue}) async {
  return await _firestore.collection('users').where(whereField, isEqualTo: whereValue).orderBy('timeCreated', descending: true).get().then((value) {
    List<UserModel> retVal = [];
    if (value.docs.isNotEmpty) {
      for (var element in value.docs) {
        retVal.add(UserModel.fromDocumentSnapshot(documentSnapshot: element));
      }
    }
    return retVal;
  });
}

Stream<List<UserModel>> findUserAnyFieldToListStream({required String whereField, required String whereValue}) {
  return _firestore
      .collection('users')
      .where(whereField, isEqualTo: whereValue)
      .orderBy('timeCreated', descending: true)
      .snapshots()
      .map((QuerySnapshot<Map<String, dynamic>> query) {
    List<UserModel> retVal = [];
    for (var element in query.docs) {
      retVal.add(UserModel.fromDocumentSnapshot(documentSnapshot: element));
    }
    return retVal;
  });
}

Future<KeyModel?> findFirstKey({required String address}) async {
  KeyModel? userResult;
  if (address.length > 10) {
    Loading.show(text: 'Address find...', textSub: '$notCloseApp!');
    var userList = await _firestore.collection('keys').where('address', isEqualTo: address).get().then((value) {
      List<KeyModel> retVal = [];
      for (var element in value.docs) {
        retVal.add(KeyModel.fromDocumentSnapshot(documentSnapshot: element));
      }
      return retVal;
    });
    Loading.hide();
    if (userList.isNotEmpty) {
      userResult = userList.first;
    } else {
      userResult = null;
    }
  } else {
    userResult = null;
  }
  return userResult;
}

Future<KeyModel?> getKeyData({required String addr}) async {
  try {
    return await _firestore.collection('keys').doc(addr).get().then((value) => KeyModel.fromDocumentSnapshot(documentSnapshot: value));
  } catch (e) {
    debugPrint('Error: $e');
    return null;
    // rethrow;

  }
}

Future<List<KeyModel>> scanAddressKeyChange() async {
  List<KeyModel> retVal = [];
  Loading.show(title: 'Keys change', textSub: 'Run...');
  await _firestore.collection('keys').get().then((value) async {
    for (var element in value.docs) {
      await updateAnyField(coll: 'keys', docId: element.data()['address'], data: element.data());
      if (element.id.length < 30) {
        deleteAny(coll: 'keys', docId: element.id);
      }
      retVal.add(KeyModel.fromDocumentSnapshot(documentSnapshot: element));
    }
  });
  Loading.hide();
  return retVal;
}

// Scan & add 2 sideL, sideR
Future<void> scanPaNewSide() async {
  await _firestore.collection('users').where('uidParent', isNotEqualTo: '').get().then((snap) async {
    if (snap.docs.isNotEmpty) {
      for (var uPa in snap.docs) {
        // UserModel paData = UserModel.fromDocumentSnapshot(documentSnapshot: uPa);
        await _firestore.collection('users').where('uidParent', isEqualTo: uPa.id).get().then((docSnap) async {
          if (docSnap.docs.isNotEmpty) {
            // Delete FieldValue;
            await _firestore
                .collection('users')
                .doc(uPa.id)
                .update({
                  'tree2': FieldValue.delete(),
                  'tree2Count': FieldValue.delete(),
                  // 'childPa': FieldValue.delete(),
                  // 'childPaList': FieldValue.delete(),
                  // 'paCheck': FieldValue.delete(),
                })
                .then((value) => debugPrint('${uPa.id}\'s Property Deleted'))
                .catchError((error) => debugPrint('Field to delete user\'s property: $error'));

            // for (var u in docSnap.docs) {
            //   UserModel uData = UserModel.fromDocumentSnapshot(documentSnapshot: u);
            //   await updateUserDB(
            //       uid: uPa.id,
            //       data: uData.isLeft!
            //           ? ((paData.sideL != '' && paData.sideL != uData.uid) ? {'side': 1} : {'sideL': uData.uid})
            //           : ((paData.sideR != '' && paData.sideR != uData.uid) ? {'side': 1} : {'sideR': uData.uid}));
            //   // await _firestore.collection('users').doc(uPa.id).update({
            //   //   'childPaList': FieldValue.arrayUnion(['${uData.uid}_${uData.isLeft! ? 'L' : 'R'}'])
            //   // });
            // }
          }
        });
      }
    }
  });
}

// ADD HISTORY
//---------------------------------
Future<void> addTransactions({
  required double amount,
  double? fee,
  double? rate,
  String? status,
  String? symbol,
  String? wallet,
  String? note,
  required String type, // Transfer, Withdraw, Invest, Stake, Buy, Sell, Convert, Swap / Reseive, Commission, Bonus, Profit
  required UserModel mainUserDB,
  String? uOtherUid,
  String? uOtherName,
}) {
  return _firestore.collection('t').add({
    'amount': amount,
    'fee': fee ?? 0,
    'rate': rate ?? 0,
    'status': status ?? 'done',
    'type': type,
    'note': note ?? '',
    'symbol': symbol ?? symbolAll,
    'wallet': wallet ?? 'wUsd',
    'uUid': mainUserDB.uid,
    'uName': mainUserDB.name,
    'uOtherUid': uOtherUid ?? '',
    'uOtherName': uOtherName ?? '',
    'timeMilis': Timestamp.now().millisecondsSinceEpoch,
    't': (mainUserDB.role == 'dev' || mainUserDB.role == 'T') ? true : false,
  });
}

//GHI VAO GIAO DICH COMMISSION:
Future<void> addHisCommissions({required double amount, required UserModel uData, String? type, required String symbol}) async {
  await _firestore.collection('commissions').add({
    'amount': amount,
    'fromVolume': 0,
    'fromUid': 'Me',
    'fromPhone': 'Me',
    'uid': uData.uid,
    'type': type,
    'gen': 0,
    'timeCreated': now,
    'wallet': getWalletStringSymbol(symbol),
    't': (uData.role == 'dev' || uData.role == 'T') ? true : false,
  });
}

Future<void> addHisGetPay({required double amount, required UserModel getUserDB, required bool payChoose}) {
  return _firestore.collection('getPays').add({
    'amount': amount,
    'uid': getUserDB.uid,
    'phone': getUserDB.phone,
    'email': getUserDB.email,
    'name': getUserDB.name,
    'otherUid': 'LEVEL9',
    'otherName': 'LEVEL9',
    'type': 'Get PAY',
    'wallet': 'wUsd',
    'debit': payChoose,
    'timeCreated': Timestamp.now(),
    't': (getUserDB.role == 'dev' || getUserDB.role == 'T') ? true : false,
  });
}

//---------------------------------
Future<double> saveAnyField({required String coll, required String doc, required String field, required double amount}) async {
  await _firestore.collection(coll).doc(doc).set({
    field: FieldValue.increment(amount),
  }, SetOptions(merge: true)).catchError((error) => {debugPrint('Failed to update - $field : $error')});
  return amount;
}

Future<bool> addAnyFieldValue({required String coll, required String doc, required String field, required dynamic e}) async {
  await _firestore.collection(coll).doc(doc).set({
    field: FieldValue.arrayUnion([e])
  }, SetOptions(merge: true)).catchError((error) => {debugPrint('Failed to array add - $field : $error')});
  return true;
}

Future<bool> reAnyFieldValue({required String coll, required String doc, required String field, required dynamic e}) async {
  await _firestore.collection(coll).doc(doc).set({
    field: FieldValue.arrayRemove([e])
  }, SetOptions(merge: true)).catchError((error) => {debugPrint('Failed to array add - $field : $error')});
  return true;
}
