class ApiConstants {
  // Production API (lihat API.md)
  static const String baseUrl = 'https://api.excotide.app';

  // Untuk pengembangan lokal (nginx Docker), ganti ke salah satu:
  // Web/iOS simulator : http://localhost:8000
  // Android emulator  : http://10.0.2.2:8000

  // Auth endpoints
  static const String register = '/api/auth/register';
  static const String login = '/api/auth/login';
  static const String logout = '/api/auth/logout';
  static const String me = '/api/auth/me';

  // Role
  static const String normalizeRole = '/api/normalize-role';

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