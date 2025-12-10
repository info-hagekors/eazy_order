class ProfileEntity {
  final String username;
  final String role;

  ProfileEntity({
    this.username = "",
    this.role = ""
  });

  ProfileEntity copyWith({
    String? username,
    String? role
  }) {
    return ProfileEntity(
      username: username ?? this.username,
      role: role ?? this.role,
    );
  }
}
