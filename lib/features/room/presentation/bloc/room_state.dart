part of 'room_bloc.dart';

sealed class RoomState {}

class RoomInitial extends RoomState {}

class RoomLoading extends RoomState {}

class RoomMyRoomsLoaded extends RoomState {
  final List<RoomEntity> rooms;
  RoomMyRoomsLoaded(this.rooms);
}

class RoomCreated extends RoomState {
  final RoomEntity room;
  RoomCreated(this.room);
}

class RoomPreviewLoaded extends RoomState {
  final Map<String, dynamic> preview;
  RoomPreviewLoaded(this.preview);
}

class RoomJoined extends RoomState {
  final Map<String, dynamic> result;
  RoomJoined(this.result);
}

class RoomLeft extends RoomState {}

class RoomDeleted extends RoomState {}

class RoomUpdated extends RoomState {
  final RoomEntity room;
  RoomUpdated(this.room);
}

class RoomMembersLoaded extends RoomState {
  final List<MemberEntity> members;
  RoomMembersLoaded(this.members);
}

class RoomFailure extends RoomState {
  final String message;
  RoomFailure(this.message);
}
