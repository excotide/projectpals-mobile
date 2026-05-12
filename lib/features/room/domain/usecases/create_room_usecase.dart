import '../entities/room_entity.dart';
import '../repositories/room_repository.dart';

class CreateRoomUseCase {
  final RoomRepository repository;
  CreateRoomUseCase(this.repository);

  Future<RoomEntity> call({
    required String projectTheme,
    required List<String> roles,
    required int maxPerGroup,
    required int numberOfGroups,
    List<String>? productivityWindows,
    List<String>? environments,
  }) {
    return repository.createRoom(
      projectTheme: projectTheme,
      roles: roles,
      maxPerGroup: maxPerGroup,
      numberOfGroups: numberOfGroups,
      productivityWindows: productivityWindows,
      environments: environments,
    );
  }
}
