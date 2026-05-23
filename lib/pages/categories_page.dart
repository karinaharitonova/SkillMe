import 'package:flutter/material.dart';
import 'videos_by_category_page.dart';

// ─────────────────────────────────────────────
// МОДЕЛЬ КАТЕГОРИИ
// ─────────────────────────────────────────────
class CategoryModel {
  final String id;
  final String name;
  final IconData icon;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
  });
}

// ─────────────────────────────────────────────
// СПИСОК КАТЕГОРИЙ
// ─────────────────────────────────────────────
final categories = [
  CategoryModel(id: 'music', name: 'Музыка', icon: Icons.music_note),
  CategoryModel(id: 'education', name: 'Образование', icon: Icons.school),
  CategoryModel(id: 'games', name: 'Игры', icon: Icons.sports_esports),
  CategoryModel(id: 'cooking', name: 'Кулинария', icon: Icons.restaurant),
  CategoryModel(id: 'design', name: 'Дизайн', icon: Icons.design_services),
  CategoryModel(id: 'sport', name: 'Спорт', icon: Icons.sports),
  CategoryModel(id: 'science', name: 'Наука', icon: Icons.science),
  CategoryModel(id: 'business', name: 'Бизнес', icon: Icons.business_center),
];

// ─────────────────────────────────────────────
// СТРАНИЦА КАТЕГОРИЙ
// ─────────────────────────────────────────────
class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              const Text(
                'КАТЕГОРИИ',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: categories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                  ),
                  itemBuilder: (context, index) {
                    final category = categories[index];

                    return InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => VideosByCategoryPage(
  categoryId: category.id,
  categoryTitle: category.name,
)
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            decoration: const BoxDecoration(
                              color: Color(0xFFEDE7F6),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(category.icon, size: 40, color: Colors.black),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            category.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
