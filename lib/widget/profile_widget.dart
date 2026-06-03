import 'package:flutter/material.dart';
import 'dart:io';

class ProfileWidget extends StatelessWidget {
  final String imagePath;
  final VoidCallback? onClicked;
  final bool editable;

  const ProfileWidget({
    Key? key,
    required this.imagePath,
    this.onClicked,
    this.editable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          _buildImage(),
          if (editable && onClicked != null)
            Positioned(
              bottom: 0,
              right: 4,
              child: _buildEditIcon(onClicked!),
            ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    final bool hasImage = imagePath.isNotEmpty;

    ImageProvider? provider;
    if (imagePath.startsWith("http")) {
      provider = NetworkImage(imagePath);
    } else if (imagePath.isNotEmpty) {
      provider = FileImage(File(imagePath));
    }

    final avatar = ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink(
          width: 128,
          height: 128,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: provider == null ? Colors.grey.shade300 : null,
            image: provider != null ? DecorationImage(image: provider, fit: BoxFit.cover) : null,
          ),
          child: provider == null ? const Icon(Icons.person, size: 60, color: Colors.white) : null,
        ),
      ),
    );

    if (editable && onClicked != null) {
      return GestureDetector(
        onTap: onClicked,
        child: avatar,
      );
    }

    // Иначе просто показываем аватар без возможности открыть галерею
    return avatar;
  }

  Widget _buildEditIcon(VoidCallback onTap) {
    return _buildCircle(
      color: Colors.white,
      padding: 3,
      child: _buildCircle(
        color: const Color(0xFF5D65D6),
        padding: 8,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: const SizedBox(
              width: 20,
              height: 20,
              child: Icon(Icons.edit, color: Colors.white, size: 16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCircle({
    required Color color,
    required double padding,
    required Widget child,
  }) {
    return ClipOval(
      child: Container(
        padding: EdgeInsets.all(padding),
        color: color,
        child: child,
      ),
    );
  }
}
