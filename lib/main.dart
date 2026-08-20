import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vinyl_groove_test6/controller/favorite_controller.dart';
import 'package:vinyl_groove_test6/screen/login_screen.dart';
import 'package:vinyl_groove_test6/uitls/info.dart';

Future<void> main() async {
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
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: bgColor,
        appBarTheme: AppBarTheme(
          surfaceTintColor: bgColor,
          backgroundColor: bgColor,
        ),
        colorScheme: .dark(
          primary: mainColor,
          secondary: mainColor,

        ),
        textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.white)),
      ),
      home: LoginScreen(),
    );
  }
}
