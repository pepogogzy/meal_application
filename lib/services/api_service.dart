import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/meal.dart';
import '../models/meal_details.dart';

class ApiService {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1/';

  // Fetch all categories
  static Future<List<Category>> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse('${baseUrl}categories.php'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List categories = data['categories'] ?? [];
        return categories.map((json) => Category.fromJson(json)).toList();
      }
      throw Exception('Failed to load categories');
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  // Fetch meals by category
  static Future<List<Meal>> fetchMealsByCategory(String category) async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}filter.php?c=$category'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List meals = data['meals'] ?? [];
        return meals.map((json) => Meal.fromJson(json)).toList();
      }
      throw Exception('Failed to load meals');
    } catch (e) {
      throw Exception('Error fetching meals: $e');
    }
  }

  // Fetch meal detail by id
  static Future<MealDetail> fetchMealDetail(String id) async {
    try {
      final response = await http.get(Uri.parse('${baseUrl}lookup.php?i=$id'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final meals = data['meals'];
        if (meals != null && meals.isNotEmpty) {
          return MealDetail.fromJson(meals[0]);
        }
        throw Exception('Meal not found');
      }
      throw Exception('Failed to load meal detail');
    } catch (e) {
      throw Exception('Error fetching meal detail: $e');
    }
  }

  // Search meals by name
  static Future<List<Meal>> searchMeals(String query) async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}search.php?s=$query'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List? meals = data['meals'];
        if (meals == null) return [];
        return meals.map((json) => Meal.fromJson(json)).toList();
      }
      throw Exception('Failed to search meals');
    } catch (e) {
      throw Exception('Error searching meals: $e');
    }
  }

  // Get random meal
  static Future<MealDetail> fetchRandomMeal() async {
    try {
      final response = await http.get(Uri.parse('${baseUrl}random.php'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final meals = data['meals'];
        if (meals != null && meals.isNotEmpty) {
          return MealDetail.fromJson(meals[0]);
        }
        throw Exception('Random meal not found');
      }
      throw Exception('Failed to load random meal');
    } catch (e) {
      throw Exception('Error fetching random meal: $e');
    }
  }
}
