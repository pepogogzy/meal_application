import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/meal_details.dart';
import '../services/api_service.dart';

class MealDetailScreen extends StatefulWidget {
  final String mealId;

  const MealDetailScreen({
    Key? key,
    required this.mealId,
  }) : super(key: key);

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  MealDetail? _mealDetail;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMealDetail();
  }

  Future<void> _loadMealDetail() async {
    try {
      setState(() => _isLoading = true);
      final detail = await ApiService.fetchMealDetail(widget.mealId);
      setState(() {
        _mealDetail = detail;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Failed to load meal details: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Future<void> _launchYouTube(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _showError('Could not open YouTube link');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF7),
      appBar: AppBar(
        title: Text(_mealDetail?.name ?? 'Recipe Details'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _mealDetail == null
          ? const Center(child: Text('Meal not found'))
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with gradient overlay
            Stack(
              children: [
                Image.network(
                  _mealDetail!.thumbnail,
                  width: double.infinity,
                  height: 280,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 280,
                      color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                      child: Center(
                        child: Icon(
                          Icons.restaurant,
                          size: 80,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    _mealDetail!.name,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Category and Area chips
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).colorScheme.tertiary.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.restaurant_menu,
                              size: 18,
                              color: Colors.brown[800],
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _mealDetail!.category,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.brown[800],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.public,
                              size: 18,
                              color: Colors.brown[800],
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _mealDetail!.area,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.brown[800],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // YouTube Link
                  if (_mealDetail!.youtubeLink != null &&
                      _mealDetail!.youtubeLink!.isNotEmpty)
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 24),
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            _launchYouTube(_mealDetail!.youtubeLink!),
                        icon: const Icon(Icons.play_circle_fill, size: 24),
                        label: const Text(
                          'Watch Video Tutorial',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 4,
                          shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                        ),
                      ),
                    ),

                  // Ingredients Section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.tertiary.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.shopping_basket,
                                color: Theme.of(context).colorScheme.primary,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Ingredients',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        ...List.generate(
                          _mealDetail!.ingredients.length,
                              (index) => Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.tertiary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    '${_mealDetail!.measures[index]} ${_mealDetail!.ingredients[index]}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.brown[800],
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Instructions Section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.menu_book,
                                color: Theme.of(context).colorScheme.primary,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Instructions',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        Text(
                          _mealDetail!.instructions,
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.7,
                            color: Colors.brown[700],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
