import 'package:flutter/material.dart';

class FollowingPage extends StatelessWidget {
  const FollowingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Мои подписки"),
      ),
      body: ListView(
        children: const [
          ListTile(
            leading: CircleAvatar(),
            title: Text("Пользователь 1"),
          ),
          ListTile(
            leading: CircleAvatar(),
            title: Text("Пользователь 2"),
          ),
          ListTile(
            leading: CircleAvatar(),
            title: Text("Пользователь 3"),
          ),
        ],
      ),
    );
  }
}
