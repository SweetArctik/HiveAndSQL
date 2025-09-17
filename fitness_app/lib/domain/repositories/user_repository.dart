import '../entities/entities.dart';

abstract class UserRepository {
  Future<User?> getCurrentUser();
  Future<User?> getUserById(int id);
  Future<User> createUser(User user);
  Future<User> updateUser(User user);
  Future<void> deleteUser(int id);
  Future<List<User>> getAllUsers();
  Future<Map<String, dynamic>> getUserStats(int userId);
}