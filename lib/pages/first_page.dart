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

  static const double _navHeight = 70.0;
  static const double _iconSize = 30.0;
  static const double _topSelectedOffset = 6.0;
  static const double _topUnselectedOffset = 10.0;
  static const double _indicatorWidth = 32.0;
  static const double _indicatorHeight = 3.5;
  static const double _bottomSpacing = 4.0;

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

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color navBackground = isDark
        ? const Color(0xFF1A1A1A)
        : Colors.white;

    final Color selectedColor = isDark
        ? const Color(0xFFCBDDFD)
        : const Color.fromARGB(255, 53, 63, 205);

    final Color unselectedColor = isDark
        ? Colors.white70
        : Colors.grey;

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        height: _navHeight,
        decoration: BoxDecoration(
          color: navBackground,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(_icons.length, (index) {
            final isSelected = index == currentIndex;
            final color = isSelected ? selectedColor : unselectedColor;

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => setState(() => currentIndex = index),
              child: SizedBox(
                width: 80, 
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOut,
                      margin: EdgeInsets.only(
                        top: isSelected ? _topSelectedOffset : _topUnselectedOffset,
                      ),
                      child: Icon(
                        _icons[index],
                        size: _iconSize,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 6),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: isSelected ? _indicatorWidth : 0,
                      height: _indicatorHeight,
                      decoration: BoxDecoration(
                        color: isSelected ? selectedColor : Colors.transparent,
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
    );
  }
}