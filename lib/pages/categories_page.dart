import 'package:flutter/material.dart';
import 'categories_papka/business_page.dart';
import 'categories_papka/cooking_page.dart';
import 'categories_papka/design_page.dart';
import 'categories_papka/education_page.dart';
import 'categories_papka/games_page.dart';
import 'categories_papka/music_page.dart';
import 'categories_papka/science_page.dart';
import 'categories_papka/sport_page.dart';

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


              const SizedBox(height: 20),

              Expanded(
                child: GridView.count(
                  padding: EdgeInsets.zero,
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  children: const [
                    CategoryItem(icon: Icons.music_note, label: 'Музыка', page: MusicPage()),
                    CategoryItem(icon: Icons.school, label: 'Образование', page: EducationPage()),
                    CategoryItem(icon: Icons.sports_esports, label: 'Игры', page: GamesPage()),
                    CategoryItem(icon: Icons.restaurant, label: 'Кулинария', page: CookingPage()),
                    CategoryItem(icon: Icons.design_services, label: 'Дизайн', page: DesignPage()),
                    CategoryItem(icon: Icons.sports, label: 'Спорт', page: SportPage()),
                    CategoryItem(icon: Icons.science, label: 'Наука', page: SciencePage()),
                    CategoryItem(icon: Icons.business_center, label: 'Бизнес', page: BusinessPage()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget page;

  const CategoryItem({
    required this.icon,
    required this.label,
    required this.page,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => page),
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
            child: Icon(icon, size: 40, color: Colors.black),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
