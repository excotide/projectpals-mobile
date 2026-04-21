import '../../domain/entities/room_entity.dart';
import '../../domain/repositories/room_repository.dart';
import '../datasources/local/room_local_datasource.dart';
import '../models/room_model.dart';

class RoomRepositoryImpl implements RoomRepository {
  RoomRepositoryImpl(this._localDataSource);

  final RoomLocalDataSource _localDataSource;

  @override
  Future<List<RoomEntity>> getJoinedRooms() async {
    final jsonList = _localDataSource.getJoinedRoomsJson();
    return jsonList.map(RoomModel.fromJson).toList();
  }
}
