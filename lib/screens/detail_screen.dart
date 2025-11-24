import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';
import '../models/model.dart';

class DetailPage extends StatelessWidget {
  final String idMeal;
  const DetailPage({super.key, required this.idMeal});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Meal Detail")),
      body: FutureBuilder<MealDetail>(
        future: ApiSource.getMealDetail(idMeal),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) return const Text("Error Loading Data");

          final meal = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(meal.strMealThumb, width: double.infinity, fit: BoxFit.cover),
                ),
                const SizedBox(height: 10),
                Text(meal.strMeal, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Text("Category: ${meal.strCategory} | Area: ${meal.strArea}", style: TextStyle(color: Colors.grey[600])),
                const Divider(),
                const Text("Ingredients", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ...meal.ingredients.map((e) => Text("- $e")),
                const Divider(),
                const Text("Instructions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(meal.strInstructions, textAlign: TextAlign.justify),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _launchUrl(meal.strYoutube),
                    icon: const Icon(Icons.play_circle_fill),
                    label: const Text("Watch Tutorial"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}