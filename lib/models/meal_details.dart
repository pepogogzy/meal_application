class MealDetail {
  final String id;
  final String name;
  final String category;
  final String area;
  final String instructions;
  final String thumbnail;
  final String? youtubeLink;
  final List<String> ingredients;
  final List<String> measures;

  MealDetail({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.thumbnail,
    this.youtubeLink,
    required this.ingredients,
    required this.measures,
  });

  factory MealDetail.fromJson(Map<String, dynamic> json) {
    List<String> ingredients = [];
    List<String> measures = [];

    // Parse ingredients and measures (strIngredient1-20, strMeasure1-20)
    for (int i = 1; i <= 20; i++) {
      String? ingredient = json['strIngredient$i'];
      String? measure = json['strMeasure$i'];

      if (ingredient != null && ingredient.trim().isNotEmpty) {
        ingredients.add(ingredient.trim());
        measures.add(measure?.trim() ?? '');
      }
    }

    return MealDetail(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      category: json['strCategory'] ?? '',
      area: json['strArea'] ?? '',
      instructions: json['strInstructions'] ?? '',
      thumbnail: json['strMealThumb'] ?? '',
      youtubeLink: json['strYoutube'],
      ingredients: ingredients,
      measures: measures,
    );
  }
}
