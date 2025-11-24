import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Inisialisasi Hive
  await Hive.initFlutter();
  await Hive.openBox('users'); 

  // 2. Cek Session Login
  final prefs = await SharedPreferences.getInstance();
  final String? username = prefs.getString('current_user');
  
  runApp(MyApp(isLoggedIn: username != null));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nintendo Amiibo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: isLoggedIn ? const LoginPage() : const LoginPage(),
    );
  }
}