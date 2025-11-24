import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/categories_screen.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  
  await Hive.initFlutter();

  await Hive.openBox('users'); 

  final prefs = await SharedPreferences.getInstance();
  
  final String? username = prefs.getString('current_user');
  
  runApp(MyApp(isLoggedIn: username != null));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    
    const Color primaryOrange = Color(0xFFFF7A00); 

    return MaterialApp(
      title: 'Meal App', 
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryOrange),
        useMaterial3: true,
        
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1, 
        ),
      ),
      
      home: isLoggedIn ? const CategoriesPage() : const LoginPage(),
    );
  }
}