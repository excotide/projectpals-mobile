import '../../domain/entities/room_entity.dart';

class RoomModel extends RoomEntity {
  const RoomModel({
    required super.id,
    required super.name,
    required super.role,
    required super.members,
    required super.status,
    required super.milestone,
    required super.milestoneUrgent,
    required super.completion,
    required super.deadline,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      members: (json['members'] as num?)?.toInt() ?? 0,
      status: json['status']?.toString() ?? '',
      milestone: json['milestone']?.toString() ?? '',
      milestoneUrgent: json['milestoneUrgent'] as bool? ?? false,
      completion: (json['completion'] as num?)?.toDouble() ?? 0,
      deadline: json['deadline']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'members': members,
      'status': status,
      'milestone': milestone,
      'milestoneUrgent': milestoneUrgent,
      'completion': completion,
      'deadline': deadline,
    };
  }
}
