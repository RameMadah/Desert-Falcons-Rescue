import 'package:desert_falcon_rescue/Managers/UserDefaultManager.dart';
import 'package:desert_falcon_rescue/Managers/UserSessionManager.dart';
import 'package:desert_falcon_rescue/Models/AppUser.dart';
import 'package:desert_falcon_rescue/Views/Screens/RescuerDashboard.dart';
import 'package:desert_falcon_rescue/Views/Screens/StartPage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one_context/one_context.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  runApp(EasyLocalization(
      child: RescueApp(),
      supportedLocales: [Locale('en'), Locale('ar')],
      path: 'assets/languages'));
}

class RescueApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget home = StartPage();
    return FutureBuilder(
      future: UserDefaultManager().getUser(),
      builder: (BuildContext context, AsyncSnapshot<AppUser?> user) {
        if (user.data != null) {
          home = RescuerDashboard(null);
          UserSessionManager().user = user.data;
        }
        return ScreenUtilInit(
          designSize: Size(1080, 2160),
          builder: () => MaterialApp(
              builder: OneContext().builder,
              debugShowCheckedModeBanner: false,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              home: home),
        );
      },
    );
  }
}
