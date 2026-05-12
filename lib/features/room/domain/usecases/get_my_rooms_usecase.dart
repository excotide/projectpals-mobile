import '../entities/room_entity.dart';
import '../repositories/room_repository.dart';

class GetMyRoomsUseCase {
  final RoomRepository repository;
  GetMyRoomsUseCase(this.repository);

  Future<List<RoomEntity>> call() => repository.getMyRooms();
}
