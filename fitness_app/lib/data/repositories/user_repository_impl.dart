import '../../domain/entities/entities.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/local_database_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final LocalDatabaseDataSource _localDataSource;

  UserRepositoryImpl({required LocalDatabaseDataSource localDataSource})
      : _localDataSource = localDataSource;

  @override
  Future<User?> getCurrentUser() async {
    return await _localDataSource.getFirstUser();
  }

  @override
  Future<User?> getUserById(int id) async {
    return await _localDataSource.getUserById(id);
  }

  @override
  Future<User> createUser(User user) async {
    final id = await _localDataSource.createUser(user);
    return user.copyWith(id: id);
  }

  @override
  Future<User> updateUser(User user) async {
    await _localDataSource.updateUser(user);
    return user;
  }

  @override
  Future<void> deleteUser(int id) async {
    await _localDataSource.deleteUser(id);
  }

  @override
  Future<List<User>> getAllUsers() async {
    return await _localDataSource.getAllUsers();
  }

  @override
  Future<Map<String, dynamic>> getUserStats(int userId) async {
    return await _localDataSource.getUserStats(userId);
  }
}