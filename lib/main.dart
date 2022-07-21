import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hjemladapp/home/homepage.dart';
import 'package:hjemladapp/onboarding/onboarding.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'authentication/userIdentification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // delete cached user data on first run (in case of uninstall)
  /*if (Platform.isIOS){
    bool firstRun = await IsFirstRun.isFirstRun();
    print(firstRun);
    if (firstRun == true) {
      FlutterSecureStorage storage = FlutterSecureStorage();
      await storage.deleteAll();
      await IsFirstRun.reset();
    }
  }*/
  // notifications permission
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    Widget checkHome(){
      return user == null? const OnboardingScreen() : const MyHomePage();
    }

    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('da')
      ],
      title: 'Hjemlad',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const UserIdentificationPage(),
      //home: checkHome(),
    );
  }
}
