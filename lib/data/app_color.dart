import 'package:flutter/material.dart';

const double paddingDefault = 16.0;
const double padding8 = 8.0;
const double padding10 = 10.0;
const int asymp = 0x2248;
const int infin = 0x221E;

const double opacity = 0.1;
const double xOffset = 1.0;
const double yOffset = 7.0;
const double blurRadius = 5.0;
const double spreadRadius = 5.0;

Color get primaryColor => AppColors.primaryColor;
Color get primaryDeep => AppColors.primaryDeep;
Color get secondaryColor => AppColors.secondaryColor;

// MaterialColor kToDark = MaterialColor(0xFF0C5B7D, colorMap);
Map<int, Color> colorMap = {
  100: const Color.fromARGB(255, 178, 227, 242),
  200: const Color.fromARGB(255, 128, 220, 234),
  300: const Color.fromARGB(255, 77, 208, 225),
  400: const Color.fromARGB(255, 38, 182, 218),
  500: const Color.fromARGB(255, 0, 173, 212),
  600: const Color.fromARGB(255, 0, 177, 193),
  800: const Color.fromARGB(255, 0, 126, 143),
  900: const Color.fromARGB(255, 0, 90, 100),
};

Map<int, Color> colorMap2 = {
  50: const Color(0xFFA4A4BF),
  100: const Color(0xFFA4A4BF),
  200: const Color(0xFFA4A4BF),
  300: const Color(0xFF9191B3),
  400: const Color(0xFF7F7FA6),
  500: const Color(0xFF181861),
  600: const Color(0xFF6D6D99),
  700: const Color(0xFF5B5B8D),
  800: const Color(0xFF494980),
  900: const Color(0xFF181861),
};

class AppColors {
  static Color primaryColor = const Color.fromARGB(255, 2, 59, 80);
  static Color primaryDeep = const Color.fromARGB(255, 1, 20, 23);
  static Color primaryLight = const Color.fromARGB(255, 15, 163, 174);
  static Color primarySwatch = Colors.orangeAccent;
  static Color secondaryColor = const Color.fromARGB(255, 11, 31, 41);

  // static MaterialColor kToDark = MaterialColor(0xFF0C5B7D, colorMap);

  static MaterialColor kToDark = MaterialColor(0xFF185161, colorMap2);

  static Color? color2 = Colors.brown[900];
  static Color color3 = const Color.fromRGBO(233, 64, 77, 1);

  static Color white = const Color(0xFFFFFFFF);
  static Color black = const Color(0xFF000000);
  static Color pink = const Color(0xFFe1116c);
  static Color blue = const Color(0xFF005EFF);
  static Color lightBlue = const Color(0xFF5694FF);
  static Color deepBlue = const Color(0xFF180B2D);
  static Color lightPurple = const Color(0xFFA168FC);
  static Color transparentWhite = Colors.white38;
  static Color transparentBlack = const Color(0x7C000000);

  static List pieColors = [
    const Color(0xFF5261FD),
    const Color(0xFF2EC6FF),
    const Color(0xFF7BC952),
    const Color(0xFFFFB74B),
    const Color(0xFFFC5B39),
    const Color(0xFF8B8782),
  ];

  static List<BoxShadow> neumorpShadow = [
    // BoxShadow(color: Colors.white, spreadRadius: -8, offset: Offset(-5, -5), blurRadius: 17),
    // BoxShadow(color: Colors.black.withOpacity(.2), offset: Offset(7, 7), blurRadius: 10, spreadRadius: -3),
    const BoxShadow(color: Color.fromRGBO(0, 0, 0, opacity), offset: Offset(xOffset, yOffset), blurRadius: blurRadius, spreadRadius: spreadRadius)
  ];

  static Shader linearG = const LinearGradient(colors: <Color>[Color(0xFF3C008F), Color(0xFFFF8400)]).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
  static final linearGLevel = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [primaryDeep.withOpacity(0.2), primaryColor]);
  static final linearG0 = LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [primaryDeep, Colors.white.withOpacity(0.5)]);
  static final linearG1 = LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [primaryDeep, primaryColor]);
  static final linearG1r = LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [primaryColor, primaryDeep]);
  static final linearG2 = LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [primarySwatch, primaryColor]);
  static final linearG3 = LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [primarySwatch, primaryLight]);
  static final linearG4 = LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [primarySwatch, primaryLight.withOpacity(0.2)]);
  static final linearG5 = LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [primaryLight.withOpacity(0.2), primarySwatch]);
  static final linearGLight = LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [white, primaryLight]);
  static const linearGSell = LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color(0x4AFFFFFF), Colors.red]);
  static const linearGBuy = LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Colors.green, Color(0x4AFFFFFF)]);

  static const bgCity = DecorationImage(image: AssetImage('assets/bg/back_city.jpg'), fit: BoxFit.cover);
  static const bgCityIntro = DecorationImage(image: AssetImage('assets/bg/back_city_intro.jpg'), fit: BoxFit.cover);
  static const bgBuild = DecorationImage(image: AssetImage('assets/bg/back_build.jpg'), fit: BoxFit.cover);
  static const bgBuild2 = DecorationImage(image: AssetImage('assets/bg/back_build2.jpg'), fit: BoxFit.cover);

  static const bgImage = DecorationImage(image: AssetImage('assets/bg/back0.jpg'), fit: BoxFit.cover);
  static const bgImage0 = DecorationImage(image: AssetImage('assets/bg/back_.jpg'), fit: BoxFit.cover);
  static const bgImage1 = DecorationImage(image: AssetImage('assets/bg/back1.jpg'), fit: BoxFit.cover);
  static const bgImage2 = DecorationImage(image: AssetImage('assets/bg/back2.jpg'), fit: BoxFit.cover);
  static const bgImage2s = DecorationImage(image: AssetImage('assets/bg/bg2.jpg'), fit: BoxFit.cover);
  static const bgImage3 = DecorationImage(image: AssetImage('assets/bg/back3.jpg'), fit: BoxFit.cover);
  static const bgImage4 = DecorationImage(image: AssetImage('assets/bg/back4.jpg'), fit: BoxFit.cover);
  static const bgBlack = DecorationImage(image: AssetImage('assets/bg/bg_black.jpg'), fit: BoxFit.cover);
  static const bgDigitalBank = DecorationImage(image: AssetImage('assets/bg/digital_bank.jpg'), fit: BoxFit.cover);
  static const bgLotus = DecorationImage(image: AssetImage('assets/bg/bg_lotus.jpg'), fit: BoxFit.cover);
  static const bgLotus2 = DecorationImage(image: AssetImage('assets/bg/bg_lotus2.jpeg'), fit: BoxFit.cover);
  static const bgNature = DecorationImage(image: AssetImage('assets/bg/bg_nature.jpeg'), fit: BoxFit.cover);
  static const bgNft1 = DecorationImage(image: AssetImage('assets/bg/1_y21tHlRaXB-dNyFxQLNyHQ.jpeg'), fit: BoxFit.cover);

  static final bgDigitalBank2 = DecorationImage(
    image: const AssetImage('assets/bg/digital_bank.jpg'),
    fit: BoxFit.cover,
    colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
  );

  static final bannerImage = DecorationImage(
    image: const AssetImage('assets/bg/banner.jpg'),
    fit: BoxFit.cover,
    colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
  );
  static final bgImageMap =
      DecorationImage(image: const AssetImage('assets/bg/bg_globalmap.png'), fit: BoxFit.cover, colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop));
  static final bgImageLock1 = DecorationImage(
    image: const AssetImage('assets/bg/cyber-security.jpg'),
    fit: BoxFit.cover,
    colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
  );
  static final bgImageLock2 = DecorationImage(
    image: const AssetImage('assets/bg/Cyber-Lock.jpg'),
    fit: BoxFit.cover,
    colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
  );
  static final bgImageLock3 = DecorationImage(
    image: const AssetImage('assets/bg/cyberSecurity.jpg'),
    fit: BoxFit.cover,
    colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
  );
  static const bgImageLock4 = DecorationImage(
    image: AssetImage('assets/bg/digital-fingerprint.jpg'),
    fit: BoxFit.cover,
  );
  static final bgPN = DecorationImage(
    image: const AssetImage('assets/bg/back_partner.jpg'),
    fit: BoxFit.cover,
    colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.dstATop),
  );
}

class CustomColors {
  static const Color brightBackground = Color(0xff424346);
  static const Color darkBackground = Color(0xff2D2F33);
  static const Color imageCircleBackground = Color(0xff28292D);
  static const Color primary = Color(0xff6AE99F);
  static const Color secondary = Color(0xffDF504A);
  static const Color purple = Color(0xff5F70F9);
  static const Color gray = Color(0xffD3D3D3);
}

Color getColor(Set<MaterialState> states) {
  const Set<MaterialState> interactiveStates = <MaterialState>{
    MaterialState.pressed,
    MaterialState.hovered,
    MaterialState.focused,
  };
  if (states.any(interactiveStates.contains)) {
    return AppColors.primaryLight;
  }
  return AppColors.primarySwatch;
}
