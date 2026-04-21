class MemberEntity {
  const MemberEntity({
    required this.username,
    required this.role,
    required this.expertise,
    required this.activity,
  });

  final String username;
  final String role;
  final List<String> expertise;
  final String activity;
}
