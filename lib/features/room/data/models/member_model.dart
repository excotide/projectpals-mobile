import '../../domain/entities/member_entity.dart';

class MemberModel extends MemberEntity {
  const MemberModel({
    required super.id,
    required super.roomId,
    required super.userId,
    super.primaryRole,
    super.backupRole,
    required super.productivityWindows,
    super.joinedAt,
    super.createdAt,
    super.updatedAt,
    super.user,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    MemberUserEntity? user;
    if (json['user'] is Map) {
      final u = json['user'] as Map<String, dynamic>;
      user = MemberUserEntity(
        id: _asInt(u['id']),
        name: (u['name'] as String?) ?? '',
        username: (u['username'] as String?) ?? '',
        email: (u['email'] as String?) ?? '',
      );
    }

    return MemberModel(
      id: _asInt(json['id']),
      roomId: _asInt(json['room_id']),
      userId: _asInt(json['user_id']),
      primaryRole: json['primary_role'] as String?,
      backupRole: json['backup_role'] as String?,
      productivityWindows: json['productivity_windows'] is List
          ? List<String>.from(json['productivity_windows'] as List)
          : <String>[],
      joinedAt: json['joined_at'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      user: user,
    );
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
