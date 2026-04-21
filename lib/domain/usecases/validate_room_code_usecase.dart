import '../repositories/join_repository.dart';

class ValidateRoomCodeUsecase {
  ValidateRoomCodeUsecase(this._repository);

  final JoinRepository _repository;

  Future<bool> call(String code) {
    return _repository.validateRoomCode(code);
  }
}
