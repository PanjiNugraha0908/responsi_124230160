import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/model.dart';
import 'detail_screen.dart';

class MealsPage extends StatelessWidget {
  final String categoryName;

  const MealsPage({super.key, required this.categoryName});

  static const Color primaryOrange = Color(0xFFFF7A00);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$categoryName Meals"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: FutureBuilder<List<Meal>>(
        future: ApiSource.getMealsByCategory(categoryName),
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
          if (!snapshot.hasData) return const Center(child: Text("No Data"));

          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio:
                  0.75, 
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final meal = snapshot.data![index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(idMeal: meal.idMeal),
                    ),
                  );
                },
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(15),
                          ),
                          child: Image.network(
                            meal.strMealThumb,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: Colors.grey[200],
                                child: const Center(
                                  child: Icon(
                                    Icons.fastfood,
                                    size: 40,
                                    color: primaryOrange,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          meal.strMeal,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
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
