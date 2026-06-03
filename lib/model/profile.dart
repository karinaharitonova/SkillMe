class Profile {
  final String imagePath;
  final String name;
  final String email;
  final String about;
  final bool isDarkMode;
  final String nickname;

  const Profile({
    required this.imagePath,
    required this.name,
    required this.email,
    required this.about,
    required this.isDarkMode,
    required this.nickname,
  });

  Profile copyWith({
    String? imagePath,
    String? name,
    String? email,
    String? about,
    bool? isDarkMode,
    String? nickname,
  }) {
    return Profile(
      imagePath: imagePath ?? this.imagePath,
      name: name ?? this.name,
      email: email ?? this.email,
      about: about ?? this.about,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      nickname: nickname ?? this.nickname,
    );
  }
}
