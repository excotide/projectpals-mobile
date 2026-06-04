import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/role_normalization.dart';
import '../models/member_model.dart';
import '../models/room_model.dart';

abstract class RoomRemoteDataSource {
  /// Preview normalisasi nama role (read-only) via `/api/normalize-role`.
  Future<RoleNormalization> normalizeRole(String role);

  Future<RoomModel> createRoom({
    required String projectTheme,
    required List<String> roles,
    required int maxPerGroup,
    required int numberOfGroups,
    List<String>? productivityWindows,
    List<String>? environments,
  });

  Future<List<RoomModel>> getMyRooms();

  Future<Map<String, dynamic>> joinRoom({
    required String roomCode,
    String? primaryRole,
    List<String>? backupRoles,
    List<String>? productivityWindows,
    List<String>? environments,
  });

  Future<Map<String, dynamic>> getRoomPreview(String roomCode);

  Future<Map<String, dynamic>> getRoomDetail(String roomCode);

  Future<RoomModel> updateRoom(String roomCode, Map<String, dynamic> data);

  Future<void> deleteRoom(String roomCode);

  Future<void> leaveRoom(String roomCode);

  Future<List<MemberModel>> getRoomMembers(String roomCode);

  /// Jalankan smart matching (owner) → `POST /api/rooms/{code}/match`.
  /// Mengembalikan map `data` berisi `teams`, `unassigned`, `meta`.
  Future<Map<String, dynamic>> startMatching(String roomCode);
}

class RoomRemoteDataSourceImpl implements RoomRemoteDataSource {
  final Dio dio;
  RoomRemoteDataSourceImpl({required this.dio});

  @override
  Future<RoleNormalization> normalizeRole(String role) async {
    try {
      final response = await dio.post(
        ApiConstants.normalizeRole,
        data: {'role': role},
      );
      final data = response.data['data'] as Map<String, dynamic>;
      return RoleNormalization(
        original: (data['original'] as String?) ?? role,
        normalized: (data['normalized'] as String?) ?? role,
        changed: (data['changed'] as bool?) ?? false,
      );
    } on DioException catch (e) {
      final data = e.response?.data;
      final msg = data is Map
          ? (data['message'] as String?) ?? 'Failed to normalize role'
          : 'Connection failed. Check your network.';
      throw ServerException(message: msg, statusCode: e.response?.statusCode);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
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
    try {
      final body = <String, dynamic>{
        'project_theme': projectTheme,
        'roles': roles,
        'max_per_group': maxPerGroup,
        'number_of_groups': numberOfGroups,
      };
      if (productivityWindows != null) {
        body['productivity_windows'] = productivityWindows;
      }
      if (environments != null) body['environments'] = environments;

      final response = await dio.post(ApiConstants.rooms, data: body);
      return RoomModel.fromJson(
          response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      final data = e.response?.data;
      final msg = data is Map ? (data['message'] as String?) ?? 'Failed to create room'
          : 'Connection failed. Check your network.';
      throw ServerException(message: msg, statusCode: e.response?.statusCode);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<RoomModel>> getMyRooms() async {
    try {
      final response = await dio.get(ApiConstants.myRooms);
      final data = response.data['data'];
      if (data is! List) return <RoomModel>[];
      return data
          .map((e) => RoomModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      final data = e.response?.data;
      final msg = data is Map ? (data['message'] as String?) ?? 'Failed to get rooms'
          : 'Connection failed. Check your network.';
      throw ServerException(message: msg, statusCode: e.response?.statusCode);
    } catch (e) {
      throw ServerException(message: 'Failed to parse rooms: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> joinRoom({
    required String roomCode,
    String? primaryRole,
    List<String>? backupRoles,
    List<String>? productivityWindows,
    List<String>? environments,
  }) async {
    try {
      final body = <String, dynamic>{'room_code': roomCode};
      if (primaryRole != null) body['primary_role'] = primaryRole;
      if (backupRoles != null && backupRoles.isNotEmpty) {
        // Kirim array (`backup_roles`) sekaligus single legacy (`backup_role`).
        body['backup_roles'] = backupRoles;
        body['backup_role'] = backupRoles.first;
      }
      if (productivityWindows != null) {
        body['productivity_windows'] = productivityWindows;
      }
      if (environments != null) body['environments'] = environments;
      final response = await dio.post(ApiConstants.joinRoom, data: body);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? 'Failed to join room';
      throw ServerException(message: msg, statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<Map<String, dynamic>> getRoomPreview(String roomCode) async {
    try {
      final response = await dio.get(ApiConstants.joinPreview(roomCode));
      return response.data['data'] as Map<String, dynamic>;
    } on DioException catch (e) {
      final msg =
          e.response?.data?['message'] ?? 'Failed to get room preview';
      throw ServerException(message: msg, statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<Map<String, dynamic>> getRoomDetail(String roomCode) async {
    try {
      final response = await dio.get(ApiConstants.roomDetail(roomCode));
      return response.data['data'] as Map<String, dynamic>;
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? 'Room not found';
      throw ServerException(message: msg, statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<RoomModel> updateRoom(
      String roomCode, Map<String, dynamic> data) async {
    try {
      final response =
          await dio.patch(ApiConstants.updateRoom(roomCode), data: data);
      return RoomModel.fromJson(
          response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? 'Failed to update room';
      throw ServerException(message: msg, statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<void> deleteRoom(String roomCode) async {
    try {
      await dio.delete(ApiConstants.deleteRoom(roomCode));
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? 'Failed to delete room';
      throw ServerException(message: msg, statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<void> leaveRoom(String roomCode) async {
    try {
      await dio.post(ApiConstants.leaveRoom(roomCode));
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? 'Failed to leave room';
      throw ServerException(message: msg, statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<List<MemberModel>> getRoomMembers(String roomCode) async {
    try {
      final response = await dio.get(ApiConstants.roomMembers(roomCode));
      final members =
          (response.data['data']['members'] as List? ?? []);
      return members
          .map((e) => MemberModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? 'Failed to get members';
      throw ServerException(message: msg, statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<Map<String, dynamic>> startMatching(String roomCode) async {
    try {
      final response = await dio.post(ApiConstants.matchRoom(roomCode));
      return (response.data['data'] as Map<String, dynamic>?) ?? {};
    } on DioException catch (e) {
      final data = e.response?.data;
      final msg = data is Map
          ? (data['message'] as String?) ?? 'Failed to start matching'
          : 'Connection failed. Check your network.';
      throw ServerException(message: msg, statusCode: e.response?.statusCode);
    }
  }
}
