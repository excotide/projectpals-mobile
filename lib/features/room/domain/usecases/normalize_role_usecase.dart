import '../entities/role_normalization.dart';
import '../repositories/room_repository.dart';

class NormalizeRoleUseCase {
  final RoomRepository repository;
  NormalizeRoleUseCase(this.repository);

  Future<RoleNormalization> call(String role) =>
      repository.normalizeRole(role);
}
