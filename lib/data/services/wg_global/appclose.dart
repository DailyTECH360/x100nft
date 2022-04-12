// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/material.dart';

void func() {
  html.window.onBeforeUnload.listen((event) async {
    // do something
    debugPrint('onBeforeUnload---> $event');
  });
  html.window.onUnload.listen((event) async {
    // do something
    debugPrint('onUnload---> $event');
  });
}
