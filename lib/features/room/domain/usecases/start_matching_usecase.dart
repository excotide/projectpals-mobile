import '../repositories/room_repository.dart';

class StartMatchingUseCase {
  final RoomRepository repository;
  StartMatchingUseCase(this.repository);

  Future<Map<String, dynamic>> call(String roomCode) =>
      repository.startMatching(roomCode);
}
