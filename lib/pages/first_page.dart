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

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final pages = <Widget>[
      const HomePage(),
      const CategoriesPage(),
      const FavoritePage(),
      user == null ? const DobroPozalovatPage() : const AccountPage(),
    ];

    return Scaffold(
      // Позволяет телу экрана заходить под BottomNavigationBar (убирает видимый "прямоугольник")
      extendBody: true,

      // IndexedStack держит все страницы в дереве и не пересоздаёт их при переключении
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: const Color.fromARGB(255, 148, 137, 137),
        backgroundColor: Colors.black,
        iconSize: 30,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) => setState(() => currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }
}
