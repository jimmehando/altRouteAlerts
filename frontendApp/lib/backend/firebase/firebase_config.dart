import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyCwkqCOlnrhbwRQZcC7V15s_R3g0phPMVs",
            authDomain: "alert-app-4oeae7.firebaseapp.com",
            projectId: "alert-app-4oeae7",
            storageBucket: "alert-app-4oeae7.appspot.com",
            messagingSenderId: "779924813576",
            appId: "1:779924813576:web:b758bbd2c95339ae3b5ebd"));
  } else {
    await Firebase.initializeApp();
  }
}
