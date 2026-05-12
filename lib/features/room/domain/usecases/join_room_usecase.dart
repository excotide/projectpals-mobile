import '../repositories/room_repository.dart';

class JoinRoomUseCase {
  final RoomRepository repository;
  JoinRoomUseCase(this.repository);

  Future<Map<String, dynamic>> call({
    required String roomCode,
    String? primaryRole,
    String? backupRole,
    List<String>? productivityWindows,
  }) {
    return repository.joinRoom(
      roomCode: roomCode,
      primaryRole: primaryRole,
      backupRole: backupRole,
      productivityWindows: productivityWindows,
    );
  }
}
