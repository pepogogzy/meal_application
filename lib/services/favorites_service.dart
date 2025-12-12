import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String _favoritesKey = 'favorite_meals';

  // Get all favorite meal IDs
  static Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey) ?? [];
  }

  // Add meal to favorites
  static Future<void> addFavorite(String mealId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoritesKey) ?? [];
    if (!favorites.contains(mealId)) {
      favorites.add(mealId);
      await prefs.setStringList(_favoritesKey, favorites);
    }
  }

  // Remove meal from favorites
  static Future<void> removeFavorite(String mealId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoritesKey) ?? [];
    favorites.remove(mealId);
    await prefs.setStringList(_favoritesKey, favorites);
  }

  // Check if meal is favorite
  static Future<bool> isFavorite(String mealId) async {
    final favorites = await getFavorites();
    return favorites.contains(mealId);
  }

  // Toggle favorite status
  static Future<bool> toggleFavorite(String mealId) async {
    final isFav = await isFavorite(mealId);
    if (isFav) {
      await removeFavorite(mealId);
      return false;
    } else {
      await addFavorite(mealId);
      return true;
    }
  }
}
