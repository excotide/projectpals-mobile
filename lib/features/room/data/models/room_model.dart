import '../../domain/entities/room_entity.dart';

class RoomModel extends RoomEntity {
  const RoomModel({
    required super.id,
    required super.createdBy,
    required super.projectTheme,
    required super.roomCode,
    required super.roles,
    required super.productivityWindows,
    required super.environments,
    required super.maxPerGroup,
    required super.numberOfGroups,
    required super.status,
    super.createdAt,
    super.updatedAt,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: _asInt(json['id']),
      createdBy: _asInt(json['created_by']),
      projectTheme: (json['project_theme'] as String?) ?? '',
      roomCode: (json['room_code'] as String?) ?? '',
      roles: json['roles'] is List
          ? List<String>.from(json['roles'] as List)
          : <String>[],
      productivityWindows: json['productivity_windows'] is List
          ? List<String>.from(json['productivity_windows'] as List)
          : <String>[],
      environments: json['environments'] is List
          ? List<String>.from(json['environments'] as List)
          : <String>[],
      maxPerGroup: _asInt(json['max_per_group']),
      numberOfGroups: _asInt(json['number_of_groups']),
      status: (json['status'] as String?) ?? 'open',
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
