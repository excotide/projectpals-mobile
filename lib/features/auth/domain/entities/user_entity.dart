class UserEntity {
  final int id;
  final String name;
  final String username;
  final String email;
  final String? createdAt;
  final String? updatedAt;

  const UserEntity({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.createdAt,
    this.updatedAt,
  });
}
