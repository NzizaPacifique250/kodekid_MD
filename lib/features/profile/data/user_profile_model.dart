class UserProfile {
  final String name;
  final String email;
  final String? avatarUrl;

  const UserProfile({
    required this.name,
    required this.email,
    this.avatarUrl,
  });

  UserProfile copyWith({
    String? name,
    String? email,
    String? avatarUrl,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}