import 'package:desert_falcon_rescue/Views/Screens/StartPage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one_context/one_context.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(EasyLocalization(
      child: RescueApp(),
      supportedLocales: [Locale('en'), Locale('ar')],
      path: 'assets/languages'));
}

class RescueApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(1080, 2160),
      builder: () => MaterialApp(
        builder: OneContext().builder,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home: StartPage(),
      ),
    );
  }
}
