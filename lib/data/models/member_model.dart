import '../../domain/entities/member_entity.dart';

class MemberModel extends MemberEntity {
  const MemberModel({
    required super.username,
    required super.role,
    required super.expertise,
    required super.activity,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      username: json['username']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      expertise: List<String>.from(json['expertise'] ?? const []),
      activity: json['activity']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'role': role,
      'expertise': expertise,
      'activity': activity,
    };
  }
}
