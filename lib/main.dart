import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lifecycle/lifecycle.dart';

import 'data/bindings/binding_ctr.dart';
import 'data/services/services.dart';
import 'data/utils.dart';
import 'intro/app_routes.dart';

// flutter run -d web-server
// flutter build web
// firebase deploy --only hosting
// firebase hosting:channel:deploy pre

// firebase deploy --only functions
// firebase deploy --only firestore:indexes
// firebase deploy --only firestore:rules

Future<void> main() async {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    if (kReleaseMode) exit(1);
  };
  await GetStorage.init();
  checkRefLink();
  getActLink();

  // await FirebaseMessaging.instance.getToken().then((token) => {LocalStore.storeSaveKey(key: 'driverTokenID', value: token!)}); // Save user DB
  // FirebaseMessaging.onBackgroundMessage((message) async {
  //   debugPrint('onBackgroundMessage occured. Message is: ');
  //   debugPrint(message.notification!.title);
  //   return;
  // });
  // await FirebaseFirestore.instance.enablePersistence();
  // // await FirebaseFirestore.instance.clearPersistence();

  // Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
  //   debugPrint('ConnectivityResult: $result');
  // });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorObservers: [defaultLifecycleObserver, FirebaseAnalyticsObserver(analytics: FirebaseAnalytics())],
      title: brandName,
      defaultTransition: Transition.fade,
      debugShowCheckedModeBanner: false,
      initialBinding: BindingCtr(),
      localeResolutionCallback: (_, __) => const Locale('en'),
      locale: const Locale('us'),
      // supportedLocales: AppLocales.supportedLocales,
      // translationsKeys: TData.byText,
      theme: ThemeData(
        scaffoldBackgroundColor: primaryDeep,
        canvasColor: secondaryColor,
        primaryColor: AppColors.primaryColor,
        primaryColorDark: AppColors.primaryDeep,
        // primarySwatch: AppColors.primarySwatch as MaterialColor?,
        primarySwatch: AppColors.kToDark,
        textTheme: GoogleFonts.openSansTextTheme(Theme.of(context).textTheme).apply(bodyColor: AppColors.primaryColor),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      getPages: AppRoutes.routes,
      initialRoute: '/',
    );
  }
}
