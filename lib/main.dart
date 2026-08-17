import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vinyl_groove_test4/screen/app/app_screen.dart';
import 'package:vinyl_groove_test4/screen/login_screen.dart';
import 'package:vinyl_groove_test4/utils/info.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: bgColor,
        colorScheme: .dark(
          primary: mainColor,
          secondary: mainColor,
          surface: coverColor,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: bgColor,
          surfaceTintColor: bgColor,
        ),
        textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.white)),
      ),
      home: isLogin ? AppScreen() : LoginScreen(),
    );
  }
}
