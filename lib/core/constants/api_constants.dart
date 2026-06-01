class ApiConstants {
  // Flutter Web (browser) → pakai localhost:8000 (nginx Docker)
  static const String baseUrl = 'http://localhost:8000';

  // Kalau test di Android emulator, ganti ke:
  // static const String baseUrl = 'http://10.0.2.2:8000';

  // Kalau test di iOS simulator, ganti ke:
  // static const String baseUrl = 'http://localhost:8000';

  // Auth endpoints
  static const String register = '/api/auth/register';
  static const String login = '/api/auth/login';
  static const String logout = '/api/auth/logout';
  static const String me = '/api/auth/me';

  // Room endpoints
  static const String rooms = '/api/rooms';
  static const String myRooms = '/api/rooms/my-rooms';
  static const String joinRoom = '/api/rooms/join';
  static String joinPreview(String roomCode) => '/api/rooms/$roomCode/join-preview';
  static String roomDetail(String roomCode) => '/api/rooms/$roomCode';
  static String updateRoom(String roomCode) => '/api/rooms/$roomCode';
  static String deleteRoom(String roomCode) => '/api/rooms/$roomCode';
  static String leaveRoom(String roomCode) => '/api/rooms/$roomCode/leave';
  static String roomMembers(String roomCode) => '/api/rooms/$roomCode/members';
}