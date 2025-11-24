import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../models/model.dart';
import 'meals_screen.dart';
import 'login_screen.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});
  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  static const Color primaryOrange = Color(0xFFFF7A00);

  // Fungsi Logout
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); 
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meal Categories"),
        centerTitle: true,
        backgroundColor: Colors.white, 
        foregroundColor: Colors.black,
        elevation: 1, 
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(
              Icons.logout,
              color: primaryOrange,
            ), 
          ),
        ],
      ),
      body: FutureBuilder<List<Category>>(
        future: ApiSource.getCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: primaryOrange),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No Data"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final category = snapshot.data![index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 3, // Subtle shadow
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MealsPage(categoryName: category.strCategory),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            category.strCategoryThumb,
                            height: 120,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                height: 120,
                                color: Colors.grey[200],
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: primaryOrange,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          category.strCategory,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          category.strCategoryDescription,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
