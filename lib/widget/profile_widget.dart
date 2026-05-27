import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  final String imagePath;
  final VoidCallback onClicked;

  const ProfileWidget({
    Key? key,
    required this.imagePath,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Можно заменить на Theme.of(context).colorScheme.primary и т.д.
    const Color gradStart = Color(0xFFCBDDFD);
    const Color gradEnd = Color(0xFF5D65D6);

    return Center(
      child: Stack(
        children: [
          buildImage(),
          Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon(gradStart, gradEnd),
          ),
        ],
      ),
    );
  }

  Widget buildImage() {
    final hasImage = imagePath.isNotEmpty;
    final imageProvider = hasImage ? NetworkImage(imagePath) : null;

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink(
          width: 128,
          height: 128,
          decoration: BoxDecoration(
            color: hasImage ? Colors.transparent : const Color(0xFFEDE7F6),
            shape: BoxShape.circle,
            image: hasImage
                ? DecorationImage(image: imageProvider as ImageProvider, fit: BoxFit.cover)
                : null,
          ),
          child: InkWell(
            onTap: onClicked,
            customBorder: const CircleBorder(),
            child: hasImage
                ? null
                : const Center(
                    child: Icon(Icons.person, size: 56, color: Colors.black54),
                  ),
          ),
        ),
      ),
    );
  }

  Widget buildEditIcon(Color gradStart, Color gradEnd) => buildCircle(
        color: Colors.white,
        all: 3,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            // УБРАЛИ const перед LinearGradient, чтобы можно было использовать переменные
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [gradStart, gradEnd],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onClicked,
              customBorder: const CircleBorder(),
              child: const SizedBox(
                width: 20,
                height: 20,
                child: Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
