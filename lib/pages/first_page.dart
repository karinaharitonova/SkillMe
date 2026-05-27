import 'package:flutter/material.dart';
import 'home_page.dart';
import 'categories_page.dart';
import 'favorite_page.dart';
import 'account_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dobro_pozalovat_page.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  int currentIndex = 0;

  final List<IconData> _icons = [
    Icons.home,
    Icons.grid_view,
    Icons.favorite,
    Icons.person,
  ];

  // Фиксированные размеры навигации
  static const double _navHeight = 80.0;
  static const double _iconSize = 28.0;
  static const double _topSelectedOffset = 8.0;
  static const double _topUnselectedOffset = 12.0;
  static const double _indicatorWidth = 28.0;
  static const double _bottomSpacing = 6.0;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final pages = [
      const HomePage(),
      const CategoriesPage(),
      const FavoritePage(),
      const AccountPage(),
    ];

    if (currentIndex == 3 && user == null) {
      return const DobroPozalovatPage();
    }

    // Жёстко заданные цвета: белый фон под кнопками и синий для выбранной иконки
    const Color navBackground = Colors.white;
    const Color selectedColor = Color(0xFF5D65D6);
    final Color unselectedColor = Colors.grey.shade500;

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),

      // Простой bottomNavigationBar с белым фоном
      bottomNavigationBar: SizedBox(
        height: _navHeight,
        child: BottomAppBar(
          color: navBackground, // белый прямоугольник под кнопками
          elevation: 8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(_icons.length, (index) {
              final isSelected = index == currentIndex;
              final color = isSelected ? const Color(0xFF5D65D6) : unselectedColor;
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(() => currentIndex = index),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOut,
                        margin: EdgeInsets.only(top: isSelected ? _topSelectedOffset : _topUnselectedOffset),
                        child: Icon(
                          _icons[index],
                          size: _iconSize,
                          color: color, // иконки: синие для выбранной, серые для остальных
                        ),
                      ),
                      const SizedBox(height: 6),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: isSelected ? _indicatorWidth : 0,
                        height: 3,
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF5D65D6) : Colors.transparent, // синий индикатор
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: _bottomSpacing),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
