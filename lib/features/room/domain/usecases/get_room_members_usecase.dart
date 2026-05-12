import '../entities/member_entity.dart';
import '../repositories/room_repository.dart';

class GetRoomMembersUseCase {
  final RoomRepository repository;
  GetRoomMembersUseCase(this.repository);

  Future<List<MemberEntity>> call(String roomCode) =>
      repository.getRoomMembers(roomCode);
}
