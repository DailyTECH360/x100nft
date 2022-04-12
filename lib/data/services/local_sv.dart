import 'package:get_storage/get_storage.dart';

class LocalStore {
  static storeSaveKey({required String key, required String value}) => GetStorage().write(key, value);
  static storeRead({required String key}) => GetStorage().read(key) ?? '';
  static storeRemove({required String key}) => GetStorage().remove(key);

  // Spon: LocalDB:
  static storeSponRefCode({required String refCodeSpon}) => GetStorage().write('spon', refCodeSpon.toLowerCase());
  static uidSponStore({required String uidSpon}) => GetStorage().write('uidSpon', uidSpon);
  static storeSavePhone({required String phone}) => GetStorage().write('phone', phone);
  static storeSaveEmail({required String email}) => GetStorage().write('email', email);
  static storeSavePass({required String pass}) => GetStorage().write('pass', pass);
}
