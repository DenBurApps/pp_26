// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA1pxZ0gDzGgEdBRdcCWHcju_aCb4poWdA',
    appId: '1:90186424026:android:27021dac8212be03694fe3',
    messagingSenderId: '90186424026',
    projectId: 'appcredarspp27',
    storageBucket: 'appcredarspp27.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAQ3NF9KnOQrowQLWXPoKkHW_Ofp1YKHDE',
    appId: '1:90186424026:ios:caed20d9b8bfcb0f694fe3',
    messagingSenderId: '90186424026',
    projectId: 'appcredarspp27',
    storageBucket: 'appcredarspp27.appspot.com',
    iosBundleId: 'com.example.pp26',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAQ3NF9KnOQrowQLWXPoKkHW_Ofp1YKHDE',
    appId: '1:90186424026:ios:535b93b67e9102c8694fe3',
    messagingSenderId: '90186424026',
    projectId: 'appcredarspp27',
    storageBucket: 'appcredarspp27.appspot.com',
    iosBundleId: 'com.example.pp26.RunnerTests',
  );
}