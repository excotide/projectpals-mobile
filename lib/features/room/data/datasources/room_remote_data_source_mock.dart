import '../../domain/entities/role_normalization.dart';
import '../models/member_model.dart';
import '../models/room_model.dart';
import 'room_remote_data_source.dart';

/// ─────────────────────────────────────────────────────────────
/// MOCK — hanya untuk development tanpa backend.
/// Kalau backend sudah siap, kembalikan di main.dart ke:
///   remoteDataSource: RoomRemoteDataSourceImpl(dio: dio)
/// ─────────────────────────────────────────────────────────────
class RoomRemoteDataSourceMock implements RoomRemoteDataSource {
  static final _dummyRooms = [
    RoomModel(
      id: 1,
      createdBy: 1,
      roomCode: 'ROOM01',
      projectTheme: 'Mobile App Development',
      roles: ['Frontend', 'Backend', 'UI/UX'],
      productivityWindows: ['Morning'],
      environments: ['Remote'],
      maxPerGroup: 4,
      numberOfGroups: 3,
      status: 'active',
    ),
    RoomModel(
      id: 2,
      createdBy: 1,
      roomCode: 'ROOM02',
      projectTheme: 'Web Platform',
      roles: ['Frontend', 'Backend'],
      productivityWindows: ['Afternoon'],
      environments: ['Hybrid'],
      maxPerGroup: 2,
      numberOfGroups: 5,
      status: 'active',
    ),
  ];

  @override
  Future<RoleNormalization> normalizeRole(String role) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final cleaned = role.trim().replaceAll(RegExp(r'\s+'), ' ');
    final normalized = cleaned
        .split(' ')
        .map((w) => w.isEmpty
            ? w
            : '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}')
        .join(' ');
    return RoleNormalization(
      original: role,
      normalized: normalized,
      changed: normalized != role.trim(),
    );
  }

  @override
  Future<RoomModel> createRoom({
    required String projectTheme,
    required List<String> roles,
    required int maxPerGroup,
    required int numberOfGroups,
    List<String>? productivityWindows,
    List<String>? environments,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return RoomModel(
      id: 99,
      createdBy: 1,
      roomCode: 'MOCK99',
      projectTheme: projectTheme,
      roles: roles,
      productivityWindows: productivityWindows ?? [],
      environments: environments ?? [],
      maxPerGroup: maxPerGroup,
      numberOfGroups: numberOfGroups,
      status: 'active',
    );
  }

  @override
  Future<List<RoomModel>> getMyRooms() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _dummyRooms;
  }

  @override
  Future<Map<String, dynamic>> joinRoom({
    required String roomCode,
    String? primaryRole,
    List<String>? backupRoles,
    List<String>? productivityWindows,
    List<String>? environments,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return {'message': 'Joined successfully', 'room_code': roomCode};
  }

  @override
  Future<Map<String, dynamic>> getRoomPreview(String roomCode) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      'room_code': roomCode,
      'project_theme': 'Mock Project',
      'roles': ['Frontend', 'Backend'],
      'max_per_group': 4,
      'number_of_groups': 3,
    };
  }

  @override
  Future<Map<String, dynamic>> getRoomDetail(String roomCode) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      'room_code': roomCode,
      'project_theme': 'Mock Project',
      'status': 'active',
    };
  }

  @override
  Future<RoomModel> updateRoom(
      String roomCode, Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return RoomModel(
      id: 1,
      createdBy: 1,
      roomCode: roomCode,
      projectTheme: data['project_theme'] ?? 'Updated Project',
      roles: (data['roles'] as List<dynamic>?)?.cast<String>() ?? [],
      productivityWindows:
          (data['productivity_windows'] as List<dynamic>?)?.cast<String>() ?? [],
      environments:
          (data['environments'] as List<dynamic>?)?.cast<String>() ?? [],
      maxPerGroup: data['max_per_group'] ?? 4,
      numberOfGroups: data['number_of_groups'] ?? 3,
      status: 'active',
    );
  }

  @override
  Future<void> deleteRoom(String roomCode) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> leaveRoom(String roomCode) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<List<MemberModel>> getRoomMembers(String roomCode) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      MemberModel(
        id: 1,
        roomId: 1,
        userId: 1,
        primaryRole: 'Frontend',
        backupRole: 'UI/UX',
        productivityWindows: ['Morning'],
      ),
      MemberModel(
        id: 2,
        roomId: 1,
        userId: 2,
        primaryRole: 'Backend',
        backupRole: 'Frontend',
        productivityWindows: ['Afternoon'],
      ),
    ];
  }
}