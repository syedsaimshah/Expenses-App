import 'package:expenses_app/Authentication%20Pages/login_page.dart';
import 'package:expenses_app/expenses.dart';
import 'package:expenses_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(const MyApp()));
}

var myColorScheme =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 59, 96, 179));

var myDarkColorScheme =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 59, 96, 179));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      themeMode: ThemeMode.system,
      theme: ThemeData().copyWith(
          colorScheme: myColorScheme,
          appBarTheme: const AppBarTheme().copyWith(
            backgroundColor: myColorScheme.onPrimaryContainer,
            foregroundColor: myColorScheme.primaryContainer,
          ),
          cardTheme: const CardTheme().copyWith(
              color: myColorScheme.secondaryContainer,
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8)),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  backgroundColor: myColorScheme.primaryContainer)),
          textTheme: ThemeData().textTheme.copyWith(
              titleLarge: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: myColorScheme.onSecondaryContainer,
                  fontSize: 17))),
      //? darkTheme
      darkTheme: ThemeData.dark().copyWith(
          colorScheme: myDarkColorScheme,
          appBarTheme: const AppBarTheme().copyWith(
            backgroundColor: myDarkColorScheme.onPrimaryContainer,
            foregroundColor: myDarkColorScheme.primaryContainer,
          ),
          cardTheme: const CardTheme().copyWith(
              color: myDarkColorScheme.secondaryContainer,
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8)),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  backgroundColor: myDarkColorScheme.primaryContainer)),
          textTheme: ThemeData().textTheme.copyWith(
              titleLarge: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: myDarkColorScheme.onSecondaryContainer,
                  fontSize: 17)),
          bottomSheetTheme: const BottomSheetThemeData()
              .copyWith(backgroundColor: myDarkColorScheme.surface)),
    );
  }
}
