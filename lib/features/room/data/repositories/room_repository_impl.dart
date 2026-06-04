import '../../domain/entities/member_entity.dart';
import '../../domain/entities/role_normalization.dart';
import '../../domain/entities/room_entity.dart';
import '../../domain/repositories/room_repository.dart';
import '../datasources/room_remote_data_source.dart';

class RoomRepositoryImpl implements RoomRepository {
  final RoomRemoteDataSource remoteDataSource;
  RoomRepositoryImpl({required this.remoteDataSource});

  @override
  Future<RoleNormalization> normalizeRole(String role) =>
      remoteDataSource.normalizeRole(role);

  @override
  Future<RoomEntity> createRoom({
    required String projectTheme,
    required List<String> roles,
    required int maxPerGroup,
    required int numberOfGroups,
    List<String>? productivityWindows,
    List<String>? environments,
  }) {
    return remoteDataSource.createRoom(
      projectTheme: projectTheme,
      roles: roles,
      maxPerGroup: maxPerGroup,
      numberOfGroups: numberOfGroups,
      productivityWindows: productivityWindows,
      environments: environments,
    );
  }

  @override
  Future<List<RoomEntity>> getMyRooms() => remoteDataSource.getMyRooms();

  @override
  Future<Map<String, dynamic>> joinRoom({
    required String roomCode,
    String? primaryRole,
    List<String>? backupRoles,
    List<String>? productivityWindows,
    List<String>? environments,
  }) {
    return remoteDataSource.joinRoom(
      roomCode: roomCode,
      primaryRole: primaryRole,
      backupRoles: backupRoles,
      productivityWindows: productivityWindows,
      environments: environments,
    );
  }

  @override
  Future<Map<String, dynamic>> getRoomPreview(String roomCode) =>
      remoteDataSource.getRoomPreview(roomCode);

  @override
  Future<Map<String, dynamic>> getRoomDetail(String roomCode) =>
      remoteDataSource.getRoomDetail(roomCode);

  @override
  Future<RoomEntity> updateRoom(String roomCode, Map<String, dynamic> data) =>
      remoteDataSource.updateRoom(roomCode, data);

  @override
  Future<void> deleteRoom(String roomCode) =>
      remoteDataSource.deleteRoom(roomCode);

  @override
  Future<void> leaveRoom(String roomCode) =>
      remoteDataSource.leaveRoom(roomCode);

  @override
  Future<List<MemberEntity>> getRoomMembers(String roomCode) =>
      remoteDataSource.getRoomMembers(roomCode);

  @override
  Future<Map<String, dynamic>> startMatching(String roomCode) =>
      remoteDataSource.startMatching(roomCode);
}
