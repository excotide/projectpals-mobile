import '../entities/room_entity.dart';
import '../repositories/room_repository.dart';

class UpdateRoomUseCase {
  final RoomRepository repository;
  UpdateRoomUseCase(this.repository);

  Future<RoomEntity> call(String roomCode, Map<String, dynamic> data) =>
      repository.updateRoom(roomCode, data);
}
