import 'package:flutter/material.dart';
import 'mainWrapper.dart';
import 'Theme/appColors.dart';
import '../Screens/authScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const InvestMateApp());
}

class InvestMateApp extends StatelessWidget {
  const InvestMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'InvestMate',
      theme: ThemeData(useMaterial3: true, fontFamily: 'Inter'),

      home: const AuthScreen(),
    );
  }
}
