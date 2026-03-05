import 'package:flutter/material.dart';
import 'package:myapp/pages/account_page.dart';
import 'package:myapp/pages/favorite_page.dart';
import 'package:myapp/pages/login_page.dart';
import 'package:myapp/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final apiKey = dotenv.env['API_KEY'];



class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}
class _FirstPageState extends State<FirstPage> {
 int _selectedIndex = 0;


final List _pages = [HomePage(),FavoritePage(),AccountPage()];
  @override
  Widget build(BuildContext context) {
    // различный фон в зависимости от выбранной вкладки
    Color background;
    switch (_selectedIndex) {
      case 0:
        background = const Color(0xFFF5F5F7);
        break;
      case 1:
        background = Colors.green.shade50;
        break;
      case 2:
        background = Colors.purple.shade50;
        break;

      default:
        background = Colors.white;
    }

    return Scaffold(
      backgroundColor: background,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        iconSize: 32.0,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF4A90E2),
        unselectedItemColor: const Color(0xFFBDBDBD),
        onTap:(index)
        {
          final user = FirebaseAuth.instance.currentUser;
          if (index == 2)
            {
              if (user ==null)
              {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            } else
          {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccountPage()),
              );
          }
            }
          else
          {
            setState(() {
              _selectedIndex = index;
            });
          }
          },
        items: const [BottomNavigationBarItem(icon: Icon(Icons.home),label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.favorite),label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person),label: ''),],
      ),
    );
  }
}