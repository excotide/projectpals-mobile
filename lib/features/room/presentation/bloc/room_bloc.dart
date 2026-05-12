import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../room/domain/entities/member_entity.dart';
import '../../../room/domain/entities/room_entity.dart';
import '../../../room/domain/usecases/create_room_usecase.dart';
import '../../../room/domain/usecases/delete_room_usecase.dart';
import '../../../room/domain/usecases/get_my_rooms_usecase.dart';
import '../../../room/domain/usecases/get_room_members_usecase.dart';
import '../../../room/domain/usecases/get_room_preview_usecase.dart';
import '../../../room/domain/usecases/join_room_usecase.dart';
import '../../../room/domain/usecases/leave_room_usecase.dart';
import '../../../room/domain/usecases/update_room_usecase.dart';

part 'room_event.dart';
part 'room_state.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  final CreateRoomUseCase createRoomUseCase;
  final GetMyRoomsUseCase getMyRoomsUseCase;
  final JoinRoomUseCase joinRoomUseCase;
  final GetRoomPreviewUseCase getRoomPreviewUseCase;
  final UpdateRoomUseCase updateRoomUseCase;
  final DeleteRoomUseCase deleteRoomUseCase;
  final LeaveRoomUseCase leaveRoomUseCase;
  final GetRoomMembersUseCase getRoomMembersUseCase;

  RoomBloc({
    required this.createRoomUseCase,
    required this.getMyRoomsUseCase,
    required this.joinRoomUseCase,
    required this.getRoomPreviewUseCase,
    required this.updateRoomUseCase,
    required this.deleteRoomUseCase,
    required this.leaveRoomUseCase,
    required this.getRoomMembersUseCase,
  }) : super(RoomInitial()) {
    on<RoomMyRoomsLoadRequested>(_onMyRoomsLoad);
    on<RoomCreateRequested>(_onCreateRoom);
    on<RoomPreviewRequested>(_onPreviewRoom);
    on<RoomJoinRequested>(_onJoinRoom);
    on<RoomLeaveRequested>(_onLeaveRoom);
    on<RoomDeleteRequested>(_onDeleteRoom);
    on<RoomUpdateRequested>(_onUpdateRoom);
    on<RoomMembersLoadRequested>(_onMembersLoad);
  }

  Future<void> _onMyRoomsLoad(
    RoomMyRoomsLoadRequested event,
    Emitter<RoomState> emit,
  ) async {
    emit(RoomLoading());
    try {
      final rooms = await getMyRoomsUseCase();
      emit(RoomMyRoomsLoaded(rooms));
    } on ServerException catch (e) {
      emit(RoomFailure(e.message));
    } catch (_) {
      emit(RoomFailure('Network error. Check your connection.'));
    }
  }

  Future<void> _onCreateRoom(
    RoomCreateRequested event,
    Emitter<RoomState> emit,
  ) async {
    emit(RoomLoading());
    try {
      final room = await createRoomUseCase(
        projectTheme: event.projectTheme,
        roles: event.roles,
        maxPerGroup: event.maxPerGroup,
        numberOfGroups: event.numberOfGroups,
        productivityWindows: event.productivityWindows,
        environments: event.environments,
      );
      emit(RoomCreated(room));
    } on ServerException catch (e) {
      emit(RoomFailure(e.message));
    } catch (_) {
      emit(RoomFailure('Network error. Check your connection.'));
    }
  }

  Future<void> _onPreviewRoom(
    RoomPreviewRequested event,
    Emitter<RoomState> emit,
  ) async {
    emit(RoomLoading());
    try {
      final preview = await getRoomPreviewUseCase(event.roomCode);
      emit(RoomPreviewLoaded(preview));
    } on ServerException catch (e) {
      emit(RoomFailure(e.message));
    } catch (_) {
      emit(RoomFailure('Network error. Check your connection.'));
    }
  }

  Future<void> _onJoinRoom(
    RoomJoinRequested event,
    Emitter<RoomState> emit,
  ) async {
    emit(RoomLoading());
    try {
      final result = await joinRoomUseCase(
        roomCode: event.roomCode,
        primaryRole: event.primaryRole,
        backupRole: event.backupRole,
        productivityWindows: event.productivityWindows,
      );
      emit(RoomJoined(result));
    } on ServerException catch (e) {
      emit(RoomFailure(e.message));
    } catch (_) {
      emit(RoomFailure('Network error. Check your connection.'));
    }
  }

  Future<void> _onLeaveRoom(
    RoomLeaveRequested event,
    Emitter<RoomState> emit,
  ) async {
    emit(RoomLoading());
    try {
      await leaveRoomUseCase(event.roomCode);
      emit(RoomLeft());
    } on ServerException catch (e) {
      emit(RoomFailure(e.message));
    } catch (_) {
      emit(RoomFailure('Network error. Check your connection.'));
    }
  }

  Future<void> _onDeleteRoom(
    RoomDeleteRequested event,
    Emitter<RoomState> emit,
  ) async {
    emit(RoomLoading());
    try {
      await deleteRoomUseCase(event.roomCode);
      emit(RoomDeleted());
    } on ServerException catch (e) {
      emit(RoomFailure(e.message));
    } catch (_) {
      emit(RoomFailure('Network error. Check your connection.'));
    }
  }

  Future<void> _onUpdateRoom(
    RoomUpdateRequested event,
    Emitter<RoomState> emit,
  ) async {
    emit(RoomLoading());
    try {
      final room = await updateRoomUseCase(event.roomCode, event.data);
      emit(RoomUpdated(room));
    } on ServerException catch (e) {
      emit(RoomFailure(e.message));
    } catch (_) {
      emit(RoomFailure('Network error. Check your connection.'));
    }
  }

  Future<void> _onMembersLoad(
    RoomMembersLoadRequested event,
    Emitter<RoomState> emit,
  ) async {
    emit(RoomLoading());
    try {
      final members = await getRoomMembersUseCase(event.roomCode);
      emit(RoomMembersLoaded(members));
    } on ServerException catch (e) {
      emit(RoomFailure(e.message));
    } catch (_) {
      emit(RoomFailure('Network error. Check your connection.'));
    }
  }
}
