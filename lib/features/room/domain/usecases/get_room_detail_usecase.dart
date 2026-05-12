import '../repositories/room_repository.dart';

class GetRoomDetailUseCase {
  final RoomRepository repository;
  GetRoomDetailUseCase(this.repository);

  Future<Map<String, dynamic>> call(String roomCode) =>
      repository.getRoomDetail(roomCode);
}
