class RoomEntity {
  const RoomEntity({
    required this.id,
    required this.name,
    required this.role,
    required this.members,
    required this.status,
    required this.milestone,
    required this.milestoneUrgent,
    required this.completion,
    required this.deadline,
  });

  final String id;
  final String name;
  final String role;
  final int members;
  final String status;
  final String milestone;
  final bool milestoneUrgent;
  final double completion;
  final String deadline;
}
