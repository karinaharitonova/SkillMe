import 'package:flutter/material.dart';
import 'videos_by_category_page.dart';
import 'package:myapp/utils/app_strings.dart';

class CategoryModel {
  final String id;
  final String nameKey; // Ключ для AppStrings
  final IconData icon;

  CategoryModel({
    required this.id,
    required this.nameKey,
    required this.icon,
  });

  // Получаем переведённое название
  String get name => AppStrings.get(nameKey);
}

final categories = [
  CategoryModel(id: 'Музыка', nameKey: 'category_music', icon: Icons.music_note),
  CategoryModel(id: 'Образование', nameKey: 'category_education', icon: Icons.school),
  CategoryModel(id: 'Игры', nameKey: 'category_games', icon: Icons.sports_esports),
  CategoryModel(id: 'Кулинария', nameKey: 'category_cooking', icon: Icons.restaurant),
  CategoryModel(id: 'Дизайн', nameKey: 'category_design', icon: Icons.design_services),
  CategoryModel(id: 'Спорт', nameKey: 'category_sport', icon: Icons.sports),
  CategoryModel(id: 'Наука', nameKey: 'category_science', icon: Icons.science),
  CategoryModel(id: 'Бизнес', nameKey: 'category_business', icon: Icons.business_center),
];

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

              Text(
                AppStrings.get('categories_title').toUpperCase(),
                style: const TextStyle(
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
                            ),
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
                            textAlign: TextAlign.center,
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