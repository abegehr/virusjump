import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';

class Score {
  static Future<String> getUUID() async {
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();

    String uuid;
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        uuid = build.androidId; //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        uuid = data.identifierForVendor; //UUID for iOS
      }
    } on Exception {
      print('Failed to get UUID');
    }

    print("getUUID(): $uuid");
    return uuid;
  }

  static saveScore(int score) async {
    String uuid = await getUUID();
    if (uuid != null)
      return Firestore.instance
          .collection('devices')
          .document(uuid)
          .collection('scores')
          .add({
        'score': score,
        'timestamp': FieldValue.serverTimestamp(),
      }).then((docRef) {
        print("saveScore($score): $docRef");
        return docRef;
      });
  }

  static Future<int> getHighscore() async {
    String uuid = await getUUID();
    if (uuid != null)
      return Firestore.instance
          .collection('devices')
          .document(uuid)
          .collection('scores')
          .orderBy('score', descending: true)
          .limit(1)
          .getDocuments()
          .then((querySnap) => querySnap.documents.length >= 1
              ? querySnap.documents.first
              : null)
          .then((docSnap) => docSnap != null ? docSnap.data['score'] : null)
          .then((score) {
        print("getHighscore(): $score");
        return score;
      });
    return null;
  }
}
