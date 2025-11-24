import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';
import '../models/model.dart';

class DetailPage extends StatelessWidget {
  final String idMeal;
  const DetailPage({super.key, required this.idMeal});

  static const Color primaryOrange = Color(0xFFFF7A00);

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw FlutterError('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meal Detail"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: FutureBuilder<MealDetail>(
        future: ApiSource.getMealDetail(idMeal),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: primaryOrange),
            );
          }
          if (snapshot.hasError)
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          if (!snapshot.hasData)
            return const Center(child: Text("Error Loading Data"));

          final meal = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    meal.strMealThumb,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 200,
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(
                            Icons.fastfood,
                            size: 50,
                            color: primaryOrange,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  meal.strMeal,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.category, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 5),
                    Text(
                      "Category: ${meal.strCategory}",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 15),
                    Icon(Icons.place, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 5),
                    Text(
                      "Area: ${meal.strArea}",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                const Divider(height: 30, thickness: 1),

                const Text(
                  "Ingredients",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryOrange,
                  ),
                ),
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: meal.ingredients
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.only(bottom: 2.0),
                          child: Text(
                            "- $e",
                            style: TextStyle(color: Colors.grey[800]),
                          ),
                        ),
                      )
                      .toList(),
                ),

                const Divider(height: 30, thickness: 1),

                const Text(
                  "Instructions",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryOrange,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Text(
                    meal.strInstructions,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.grey[800],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                if (meal.strYoutube.isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _launchUrl(meal.strYoutube),
                      icon: const Icon(Icons.play_circle_fill),
                      label: const Text("Watch Tutorial"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryOrange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
