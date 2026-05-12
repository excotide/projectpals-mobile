import '../repositories/room_repository.dart';

class LeaveRoomUseCase {
  final RoomRepository repository;
  LeaveRoomUseCase(this.repository);

  Future<void> call(String roomCode) => repository.leaveRoom(roomCode);
}
