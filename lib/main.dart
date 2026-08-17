import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vinyl_groove_test3/controller/favorite_comtroller.dart';
import 'package:vinyl_groove_test3/screen/login_screen.dart';
import 'package:vinyl_groove_test3/utils/info.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await FavoriteController.favoriteController.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: bgColor,
        colorScheme: .dark(
          primary: mainColor,
          secondary: mainColor,
          surface: coverColor,
          onError: Colors.red,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: bgColor,
          surfaceTintColor: bgColor,
        ),
        textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.white)),
      ),
      home: const LoginScreen(),
    );
  }
}
