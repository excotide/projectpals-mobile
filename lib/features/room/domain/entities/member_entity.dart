class MemberUserEntity {
  final int id;
  final String name;
  final String username;
  final String email;

  const MemberUserEntity({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
  });
}

class MemberEntity {
  final int id;
  final int roomId;
  final int userId;
  final String? primaryRole;
  final String? backupRole;
  final List<String> productivityWindows;
  final String? joinedAt;
  final String? createdAt;
  final String? updatedAt;
  final MemberUserEntity? user;

  const MemberEntity({
    required this.id,
    required this.roomId,
    required this.userId,
    this.primaryRole,
    this.backupRole,
    required this.productivityWindows,
    this.joinedAt,
    this.createdAt,
    this.updatedAt,
    this.user,
  });
}
