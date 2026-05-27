class Profile {
  final String imagePath;
  final String name;
  final String about;
  final bool isDarkMode;

  const Profile({
    required this.imagePath,
    required this.name,
    required this.about,
    required this.isDarkMode,
  });

  Profile copyWith({
    String? imagePath,
    String? name,
    String? about,
    bool? isDarkMode,
  }) {
    return Profile(
      imagePath: imagePath ?? this.imagePath,
      name: name ?? this.name,
      about: about ?? this.about,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
}
