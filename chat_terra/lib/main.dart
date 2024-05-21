import 'package:flutter/material.dart';
import 'package:chat_terra/views/chatpage.dart';
import 'package:chat_terra/views/loginpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions
        .currentPlatform, //mira en quina plataforma s'està inicialitzant
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Terra',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 73, 189, 83)),
        useMaterial3: true,
      ),
      home: LoginScreen(),
    );
  }
}
