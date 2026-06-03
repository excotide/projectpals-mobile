import '../repositories/room_repository.dart';

class JoinRoomUseCase {
  final RoomRepository repository;
  JoinRoomUseCase(this.repository);

  Future<Map<String, dynamic>> call({
    required String roomCode,
    String? primaryRole,
    List<String>? backupRoles,
    List<String>? productivityWindows,
    List<String>? environments,
  }) {
    return repository.joinRoom(
      roomCode: roomCode,
      primaryRole: primaryRole,
      backupRoles: backupRoles,
      productivityWindows: productivityWindows,
      environments: environments,
    );
  }
}
