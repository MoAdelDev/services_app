import 'package:entertainment_services/firebase_options.dart';
import 'package:entertainment_services/home/home_screen.dart';
import 'package:entertainment_services/login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirebaseAuth.instance.currentUser?.uid != null
          ? const HomeScreen()
          : const LoginScreen(),
      locale: const Locale('ar', 'EG'),
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        centerTitle: true,
      )),
    );
  }
}
