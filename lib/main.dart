import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vinyl_groove/controller/favorite_controller.dart';
import 'package:vinyl_groove/screen/app_screen.dart';
import 'package:vinyl_groove/screen/login_screen.dart';
import 'package:vinyl_groove/utils/info.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await FavoriteController.instance.load();
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
        textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.white)),
      ),
      home: isLogin ? AppScreen() : LoginScreen(),
    );
  }
}
