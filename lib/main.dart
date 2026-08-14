import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vinyl_groove2/screen/login_screen.dart';
import 'package:vinyl_groove2/urils/info.dart';

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
        appBarTheme: AppBarTheme(
          backgroundColor: bgColor,
          surfaceTintColor: bgColor,
        ),
        colorScheme: .dark(
          primary: mainColor,
          secondary: mainColor,
          onError: Colors.red,
        ),
        textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.white)),
      ),
      home: LoginScreen(),
    );
  }
}
