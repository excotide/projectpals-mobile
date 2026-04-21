class RoomLocalDataSource {
  List<Map<String, dynamic>> getJoinedRoomsJson() {
    return [
      {
        'id': '1',
        'name': 'CLOUDFRIEND',
        'role': 'BACK-END',
        'members': 5,
        'status': 'IN PROGRESS',
        'milestone': 'Due in 9 days',
        'milestoneUrgent': false,
        'completion': 0.45,
        'deadline': 'Nov 10, 2026',
      },
      {
        'id': '2',
        'name': 'DRINKEDIN',
        'role': 'FRONT-END',
        'members': 3,
        'status': 'IN PROGRESS',
        'milestone': 'Due in 3 days',
        'milestoneUrgent': true,
        'completion': 0.64,
        'deadline': 'Oct 24, 2026',
      },
      {
        'id': '3',
        'name': 'Neural Core',
        'role': 'UI DESIGNER',
        'members': 4,
        'status': 'COMPLETED',
        'milestone': 'Project Finished',
        'milestoneUrgent': false,
        'completion': 1.0,
        'deadline': 'Sep 1, 2026',
      },
    ];
  }

  List<String> getValidRoomCodes() {
    return const ['555678', 'ABC123', 'XYZ999'];
  }
}
