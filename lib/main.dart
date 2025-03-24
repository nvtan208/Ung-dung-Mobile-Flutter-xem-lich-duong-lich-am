import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'calendar_screen.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Cấu hình Firebase cho tất cả các nền tảng
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "",
      authDomain: "lunarcalendarweb.firebaseapp.com",
      projectId: "lunarcalendarweb",
      storageBucket: "lunarcalendarweb.firebasestorage.app",
      messagingSenderId: "745386022738",
      appId: "1:745386022738:web:df4a7acc19e7f35afc4c8b",
      measurementId: "G-F5NJNBLG36",
    ),
  );

  // Loại bỏ ký hiệu # trong URL cho web
  setUrlStrategy(PathUrlStrategy());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.grey[100],
        textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 16)),
      ),
      home: const CalendarScreen(),
    );
  }
}
