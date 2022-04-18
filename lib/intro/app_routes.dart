import 'package:get/get.dart';

import 'intro.dart';
import 'sv_end.dart';
// import 'sv_end.dart';

class AppRoutes {
  AppRoutes._(); // this is to prevent anyone from instantiating this object
  static final routes = [
    GetPage(
        name: '/',
        page: () {
          final dateSvEnd = DateTime.parse('2022-07-15');
          if (dateSvEnd.millisecondsSinceEpoch < DateTime.now().millisecondsSinceEpoch) {
            return const SvEndPage();
          } else {
            return const Intro();
          }
        }),
    // GetPage(name: '/', page: () => const Intro()),
  ];
}
