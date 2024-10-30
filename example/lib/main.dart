import 'package:example/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart'
    as libphonenumber;

Future<void> main({String? env}) async {
  WidgetsFlutterBinding.ensureInitialized();

  await libphonenumber.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        primaryColor: const Color(0xFFFF5B36),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(backgroundColor: Colors.black),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.black,
          selectionColor: Colors.black.withOpacity(0.4),
          selectionHandleColor: Colors.black,
        ),
      ),
      home: const LoginPage(),
    );
  }
}
