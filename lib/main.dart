import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Core
import 'core/network/api_client.dart';

// Auth — data
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';

// Auth — domain
import 'features/auth/domain/usecases/get_me_usecase.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';

// Auth — bloc
import 'features/auth/presentation/bloc/auth_bloc.dart';

// Room — data
import 'features/room/data/datasources/room_remote_data_source.dart';
import 'features/room/data/repositories/room_repository_impl.dart';

// Room — domain
import 'features/room/domain/usecases/create_room_usecase.dart';
import 'features/room/domain/usecases/delete_room_usecase.dart';
import 'features/room/domain/usecases/get_my_rooms_usecase.dart';
import 'features/room/domain/usecases/get_room_members_usecase.dart';
import 'features/room/domain/usecases/get_room_preview_usecase.dart';
import 'features/room/domain/usecases/join_room_usecase.dart';
import 'features/room/domain/usecases/leave_room_usecase.dart';
import 'features/room/domain/usecases/update_room_usecase.dart';

// Room — bloc
import 'features/room/presentation/bloc/room_bloc.dart';

// Screens
import 'features/splash/splash_screen.dart';
import 'features/room/presentation/screens/create_screen.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/register_screen.dart';
import 'shared/widgets/main_scaffold.dart';
import 'onboarding.dart';

void main() {
  runApp(const ProjectPalsApp());
}

class ProjectPalsApp extends StatelessWidget {
  const ProjectPalsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final dio = ApiClient.instance;

    final authRepo = AuthRepositoryImpl(
      remoteDataSource: AuthRemoteDataSourceImpl(dio: dio),
    );
    final roomRepo = RoomRepositoryImpl(
      remoteDataSource: RoomRemoteDataSourceImpl(dio: dio),
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(
            loginUseCase: LoginUseCase(authRepo),
            registerUseCase: RegisterUseCase(authRepo),
            logoutUseCase: LogoutUseCase(authRepo),
            getMeUseCase: GetMeUseCase(authRepo),
          ),
        ),
        BlocProvider(
          create: (_) => RoomBloc(
            createRoomUseCase: CreateRoomUseCase(roomRepo),
            getMyRoomsUseCase: GetMyRoomsUseCase(roomRepo),
            joinRoomUseCase: JoinRoomUseCase(roomRepo),
            getRoomPreviewUseCase: GetRoomPreviewUseCase(roomRepo),
            updateRoomUseCase: UpdateRoomUseCase(roomRepo),
            deleteRoomUseCase: DeleteRoomUseCase(roomRepo),
            leaveRoomUseCase: LeaveRoomUseCase(roomRepo),
            getRoomMembersUseCase: GetRoomMembersUseCase(roomRepo),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ProjectPals',
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
          fontFamily: 'sans-serif',
        ),
        initialRoute: '/',
        routes: {
          '/': (_) => const SplashScreen(),
          '/onboarding': (_) => const OnboardingScreen(),
          '/login': (_) => const LoginScreen(),
          '/register': (_) => const RegisterScreen(),
          '/dashboard': (_) => const MainScaffold(initialIndex: 0),
          '/join': (_) => const MainScaffold(initialIndex: 1),
          '/rooms': (_) => const MainScaffold(initialIndex: 2),
          '/profile': (_) => const MainScaffold(initialIndex: 3),
          '/create': (_) => const CreateRoomScreen(),
        },
      ),
    );
  }
}
