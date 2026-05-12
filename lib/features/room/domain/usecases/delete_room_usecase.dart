import '../repositories/room_repository.dart';

class DeleteRoomUseCase {
  final RoomRepository repository;
  DeleteRoomUseCase(this.repository);

  Future<void> call(String roomCode) => repository.deleteRoom(roomCode);
}
