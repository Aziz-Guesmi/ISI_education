import 'package:educationadmin/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screen/signin_page.dart';
import 'theme/theme.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging messaging = FirebaseMessaging.instance;

   OneSignal.initialize("1e987a91-1e4a-43f0-8e53-ff9313671f66");
  OneSignal.Notifications.requestPermission(true);
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E_ducation Admin',
      theme: TAppTheme.mobileTheme,
      home: SignInPage(),
    );
  }
}
