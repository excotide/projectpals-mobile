import '../../domain/repositories/join_repository.dart';
import '../datasources/local/room_local_datasource.dart';

class JoinRepositoryImpl implements JoinRepository {
  JoinRepositoryImpl(this._localDataSource);

  final RoomLocalDataSource _localDataSource;

  @override
  Future<bool> validateRoomCode(String code) async {
    final validCodes = _localDataSource.getValidRoomCodes();
    return validCodes.contains(code.toUpperCase());
  }
}
