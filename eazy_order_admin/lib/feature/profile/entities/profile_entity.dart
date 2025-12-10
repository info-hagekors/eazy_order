class ProductEntity {
  final String username;
  final String role;

  ProductEntity({this.username = "", this.role = ""});

  ProductEntity copyWith({String? username, String? role}) {
    return ProductEntity(
      username: username ?? this.username,
      role: role ?? this.role,
    );
  }
}
