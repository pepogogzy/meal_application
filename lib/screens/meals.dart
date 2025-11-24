import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/api_service.dart';
import '../widgets/meal_card.dart';
import 'meal_details.dart';

class MealsScreen extends StatefulWidget {
  final String categoryName;

  const MealsScreen({
    Key? key,
    required this.categoryName,
  }) : super(key: key);

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  List<Meal> _meals = [];
  List<Meal> _filteredMeals = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadMeals();
  }

  Future<void> _loadMeals() async {
    try {
      setState(() => _isLoading = true);
      final meals = await ApiService.fetchMealsByCategory(widget.categoryName);
      setState(() {
        _meals = meals;
        _filteredMeals = meals;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Failed to load meals: $e');
    }
  }

  Future<void> _searchMeals(String query) async {
    setState(() {
      _searchQuery = query;
    });

    if (query.isEmpty) {
      setState(() {
        _filteredMeals = _meals;
      });
      return;
    }

    try {
      final searchResults = await ApiService.searchMeals(query);

      // Filter to only show meals from current category
      final filteredResults = searchResults
          .where((meal) => _meals.any((m) => m.id == meal.id))
          .toList();

      setState(() {
        _filteredMeals = filteredResults;
      });
    } catch (e) {
      _showError('Search failed: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search meals...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: _searchMeals,
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredMeals.isEmpty
                ? const Center(child: Text('No meals found'))
                : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _filteredMeals.length,
              itemBuilder: (context, index) {
                final meal = _filteredMeals[index];
                return MealCard(
                  meal: meal,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MealDetailScreen(
                          mealId: meal.id,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
