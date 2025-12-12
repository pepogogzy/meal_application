import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../models/meal_details.dart';
import '../services/api_service.dart';
import '../services/favorites_service.dart';
import '../widgets/meal_card.dart';
import 'meal_details.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<MealDetail> _favoriteMeals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      setState(() => _isLoading = true);
      final favoriteIds = await FavoritesService.getFavorites();

      List<MealDetail> meals = [];
      for (String id in favoriteIds) {
        try {
          final meal = await ApiService.fetchMealDetail(id);
          meals.add(meal);
        } catch (e) {
          print('Error loading meal $id: $e');
        }
      }

      setState(() {
        _favoriteMeals = meals;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Failed to load favorites: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _removeFavorite(String mealId) async {
    await FavoritesService.removeFavorite(mealId);
    _loadFavorites(); // Reload list
    _showError('Removed from favorites');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF7),
      appBar: AppBar(
        title: const Text('My Favorites'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _favoriteMeals.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: 16),
            Text(
              'No favorites yet!',
              style: TextStyle(
                fontSize: 20,
                color: Colors.brown[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start adding your favorite recipes',
              style: TextStyle(
                fontSize: 14,
                color: Colors.brown[400],
              ),
            ),
          ],
        ),
      )
          : GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.85,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _favoriteMeals.length,
        itemBuilder: (context, index) {
          final meal = _favoriteMeals[index];
          return Stack(
            children: [
              MealCard(
                meal: Meal(
                  id: meal.id,
                  name: meal.name,
                  thumbnail: meal.thumbnail,
                ),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MealDetailScreen(
                        mealId: meal.id,
                      ),
                    ),
                  );
                  _loadFavorites(); // Refresh after returning
                },
                showFavoriteButton: false,
              ),
              Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 18,
                  child: IconButton(
                    icon: const Icon(
                      Icons.favorite,
                      color: Color(0xFFFF746C),
                      size: 18,
                    ),
                    padding: EdgeInsets.zero,
                    onPressed: () => _removeFavorite(meal.id),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
