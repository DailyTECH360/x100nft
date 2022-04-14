import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/services/wg_global/bottom_bar/page/home_page.dart';
import '../data/services/wg_global/device_info.dart';
import '../data/services/wg_global/on_off_page.dart';
import '../data/services/wg_global/share.dart';
import '../data/services/wg_global/video/video_info.dart';
import '../data/services/wg_global/vk.dart';
import '../data/services/wg_global/vk_multi.dart';
import 'befor/intro_page.dart';
import 'befor/profile.dart';
import 'befor/qua.dart';
import 'befor/sp.dart';
import 'intro.dart';
import 'join/join.dart';
import 'join/joinselly.dart';
// import 'sv_end.dart';

class AppRoutes {
  AppRoutes._(); // this is to prevent anyone from instantiating this object
  static final routes = [
    // GetPage(
    //     name: '/',
    //     page: () {
    //       final dateSvEnd = DateTime.parse('2021-12-30');
    //       if (dateSvEnd.millisecondsSinceEpoch < DateTime.now().millisecondsSinceEpoch) {
    //         return const SvEndPage();
    //       } else {
    //         return const Intro();
    //       }
    //     }),
    GetPage(name: '/', page: () => const Intro()),
    // GetPage(name: '/', page: () => const SplashScreen()),
    // GetPage(name: '/', page: () => const LangdingPage()),
    GetPage(name: '/b', page: () => Title(color: Colors.black, title: 'Bottom bar', child: const BottomBarPage())),
    GetPage(name: '/p', page: () => Title(color: Colors.black, title: 'Profile', child: const Profile())),
    GetPage(name: '/i', page: () => Title(color: Colors.black, title: 'Intro', child: const IntroPage())),
    GetPage(name: '/j', page: () => Title(color: Colors.black, title: 'Join', child: JoinPage())),
    GetPage(name: '/join', page: () => Title(color: Colors.black, title: 'Join', child: JoinSellPage())),
    GetPage(name: '/video', page: () => Title(color: Colors.black, title: 'Video', child: const VideoInfo())),
    GetPage(name: '/qua', page: () => const QuaTang()),
    GetPage(name: '/sp', page: () => const SanPham()),
    GetPage(name: '/vk', page: () => const VkPage()),
    GetPage(name: '/vkm', page: () => const VirtualkeyboardPage()),
    GetPage(name: '/di', page: () => const DeviceInfoPage()),
    GetPage(name: '/on', page: () => const OnOfflinePage()),
    GetPage(name: '/share', page: () => Title(color: Colors.red, title: 'Share', child: const SharePage())),
    // GetPage(name: '/on', page: () => const OnOfflinePage()),
  ];
}
