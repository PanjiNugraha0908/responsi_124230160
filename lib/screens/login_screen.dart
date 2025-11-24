import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart'; 
import 'categories_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Box _userBox = Hive.box('users'); 

  static const Color primaryOrange = Color(0xFFFF7A00);

  Future<void> _login() async {
    final String username = _usernameController.text.trim();
    final String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showSnackbar("Username dan Password harus diisi.", Colors.red);
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    if (_userBox.containsKey(username)) {
      final storedPassword = _userBox.get(username);
      if (storedPassword == password) {

        await prefs.setString('current_user', username); 
        await prefs.setBool('isLogin', true);
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const CategoriesPage()),
          );
        }
      } else {
        _showSnackbar("Password salah.", Colors.red);
      }
    } else {
      _userBox.put(username, password); 
      await prefs.setString('current_user', username); 
      await prefs.setBool('isLogin', true);
      if (mounted) {
        _showSnackbar("Registrasi berhasil! Anda telah login.", primaryOrange);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CategoriesPage()),
        );
      }
    }
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "🍽️ Food Explorer",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: primaryOrange,
                ),
              ),
              const SizedBox(height: 50),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: "Username",
                  hintText: "Masukkan username Anda",
                  prefixIcon: const Icon(Icons.person, color: primaryOrange),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  hintText: "Masukkan password",
                  prefixIcon: const Icon(Icons.lock, color: primaryOrange),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(height: 30),
              // Tombol Login
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    "LOGIN / REGISTER",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Jika username belum terdaftar, akan didaftarkan otomatis.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
