class RoomEntity {
  final int id;
  final int createdBy;
  final String projectTheme;
  final String roomCode;
  final List<String> roles;
  final List<String> productivityWindows;
  final List<String> environments;
  final int maxPerGroup;
  final int numberOfGroups;
  final String status;
  final String? createdAt;
  final String? updatedAt;

  const RoomEntity({
    required this.id,
    required this.createdBy,
    required this.projectTheme,
    required this.roomCode,
    required this.roles,
    required this.productivityWindows,
    required this.environments,
    required this.maxPerGroup,
    required this.numberOfGroups,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });
}
