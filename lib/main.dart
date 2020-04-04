import 'dart:async';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:monsterjump/utils/admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/flame.dart';
import 'package:flame/util.dart';
import 'package:monsterjump/game.dart';

void main() {
  //Crashlytics.instance.enableInDevMode = true;

  // on uncaught flutter error
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  // run in zone for stacktrace
  runZoned<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Admob setup
    Admob.init();
    Admob.loadBannerAd();

    // preload images
    Flame.images.loadAll(<String>[
      'bg/background.png',
      'monster/monster.png',
      'platform/platform.png'
    ]);

    // Flame settings
    Util flameUtil = Util();
    flameUtil.fullScreen();
    flameUtil.setOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    // run app
    runApp(GameContainer());
  }, onError: Crashlytics.instance.recordError);
}

class GameContainer extends StatelessWidget {
  final CoronaJump game = CoronaJump();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 420),
        child: game.widget,
      ),
    );
  }
}
