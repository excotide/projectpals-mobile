import '../entities/room_entity.dart';
import '../repositories/room_repository.dart';

class GetJoinedRoomsUsecase {
  GetJoinedRoomsUsecase(this._repository);

  final RoomRepository _repository;

  Future<List<RoomEntity>> call() {
    return _repository.getJoinedRooms();
  }
}
