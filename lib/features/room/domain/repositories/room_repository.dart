import '../entities/member_entity.dart';
import '../entities/room_entity.dart';

abstract class RoomRepository {
  Future<RoomEntity> createRoom({
    required String projectTheme,
    required List<String> roles,
    required int maxPerGroup,
    required int numberOfGroups,
    List<String>? productivityWindows,
    List<String>? environments,
  });

  Future<List<RoomEntity>> getMyRooms();

  Future<Map<String, dynamic>> joinRoom({
    required String roomCode,
    String? primaryRole,
    String? backupRole,
    List<String>? productivityWindows,
  });

  Future<Map<String, dynamic>> getRoomPreview(String roomCode);

  Future<Map<String, dynamic>> getRoomDetail(String roomCode);

  Future<RoomEntity> updateRoom(String roomCode, Map<String, dynamic> data);

  Future<void> deleteRoom(String roomCode);

  Future<void> leaveRoom(String roomCode);

  Future<List<MemberEntity>> getRoomMembers(String roomCode);
}
