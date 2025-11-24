import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/model.dart';


class ApiSource {
  static const String _baseUrl = "https://www.themealdb.com/api/json/v1/1";

  static Future<List<Category>> getCategories() async {
    final response = await http.get(Uri.parse('$_baseUrl/categories.php'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> list = data['categories'];
      return list.map((e) => Category.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  static Future<List<Meal>> getMealsByCategory(String category) async {
    final response = await http.get(Uri.parse('$_baseUrl/filter.php?c=$category'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> list = data['meals'];
      return list.map((e) => Meal.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load meals');
    }
  }

  static Future<MealDetail> getMealDetail(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/lookup.php?i=$id'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return MealDetail.fromJson(data['meals'][0]);
    } else {
      throw Exception('Failed to load meal detail');
    }
  }
}