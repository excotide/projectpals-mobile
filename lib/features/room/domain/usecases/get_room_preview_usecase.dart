import '../repositories/room_repository.dart';

class GetRoomPreviewUseCase {
  final RoomRepository repository;
  GetRoomPreviewUseCase(this.repository);

  Future<Map<String, dynamic>> call(String roomCode) =>
      repository.getRoomPreview(roomCode);
}
