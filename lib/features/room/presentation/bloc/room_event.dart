part of 'room_bloc.dart';

sealed class RoomEvent {}

class RoomMyRoomsLoadRequested extends RoomEvent {}

class RoomCreateRequested extends RoomEvent {
  final String projectTheme;
  final List<String> roles;
  final int maxPerGroup;
  final int numberOfGroups;
  final List<String>? productivityWindows;
  final List<String>? environments;

  RoomCreateRequested({
    required this.projectTheme,
    required this.roles,
    required this.maxPerGroup,
    required this.numberOfGroups,
    this.productivityWindows,
    this.environments,
  });
}

class RoomPreviewRequested extends RoomEvent {
  final String roomCode;
  RoomPreviewRequested(this.roomCode);
}

class RoomJoinRequested extends RoomEvent {
  final String roomCode;
  final String? primaryRole;
  final String? backupRole;
  final List<String>? productivityWindows;

  RoomJoinRequested({
    required this.roomCode,
    this.primaryRole,
    this.backupRole,
    this.productivityWindows,
  });
}

class RoomLeaveRequested extends RoomEvent {
  final String roomCode;
  RoomLeaveRequested(this.roomCode);
}

class RoomDeleteRequested extends RoomEvent {
  final String roomCode;
  RoomDeleteRequested(this.roomCode);
}

class RoomUpdateRequested extends RoomEvent {
  final String roomCode;
  final Map<String, dynamic> data;
  RoomUpdateRequested({required this.roomCode, required this.data});
}

class RoomMembersLoadRequested extends RoomEvent {
  final String roomCode;
  RoomMembersLoadRequested(this.roomCode);
}
