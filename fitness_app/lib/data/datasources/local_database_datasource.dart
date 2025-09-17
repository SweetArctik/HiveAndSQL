import 'package:sqflite/sqflite.dart';
import '../../core/utils/database_helper.dart';
import '../../domain/entities/entities.dart';

class LocalDatabaseDataSource {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // ========== Users CRUD ==========
  Future<int> createUser(User user) async {
    final db = await _dbHelper.database;
    return await db.insert(DatabaseHelper.usersTable, user.toMap());
  }

  Future<User?> getUserById(int id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.usersTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<User?> getFirstUser() async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.usersTable,
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<List<User>> getAllUsers() async {
    final db = await _dbHelper.database;
    final maps = await db.query(DatabaseHelper.usersTable);
    return maps.map((map) => User.fromMap(map)).toList();
  }

  Future<int> updateUser(User user) async {
    final db = await _dbHelper.database;
    return await db.update(
      DatabaseHelper.usersTable,
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      DatabaseHelper.usersTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ========== Exercises CRUD ==========
  Future<int> createExercise(Exercise exercise) async {
    final db = await _dbHelper.database;
    return await db.insert(DatabaseHelper.exercisesTable, exercise.toMap());
  }

  Future<Exercise?> getExerciseById(int id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.exercisesTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Exercise.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Exercise>> getAllExercises() async {
    final db = await _dbHelper.database;
    final maps = await db.query(DatabaseHelper.exercisesTable);
    return maps.map((map) => Exercise.fromMap(map)).toList();
  }

  Future<List<Exercise>> getExercisesByMuscleGroup(MuscleGroup muscleGroup) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.exercisesTable,
      where: 'grupo_muscular = ?',
      whereArgs: [muscleGroup.name],
    );
    return maps.map((map) => Exercise.fromMap(map)).toList();
  }

  Future<List<Exercise>> getExercisesByDifficulty(DifficultyLevel difficulty) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.exercisesTable,
      where: 'nivel_dificultad = ?',
      whereArgs: [difficulty.name],
    );
    return maps.map((map) => Exercise.fromMap(map)).toList();
  }

  Future<int> updateExercise(Exercise exercise) async {
    final db = await _dbHelper.database;
    return await db.update(
      DatabaseHelper.exercisesTable,
      exercise.toMap(),
      where: 'id = ?',
      whereArgs: [exercise.id],
    );
  }

  Future<int> deleteExercise(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      DatabaseHelper.exercisesTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ========== Workouts CRUD ==========
  Future<int> createWorkout(Workout workout) async {
    final db = await _dbHelper.database;
    return await db.insert(DatabaseHelper.workoutsTable, workout.toMap());
  }

  Future<Workout?> getWorkoutById(int id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.workoutsTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Workout.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Workout>> getWorkoutsByUserId(int userId, {int? limit}) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.workoutsTable,
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'fecha DESC',
      limit: limit,
    );
    return maps.map((map) => Workout.fromMap(map)).toList();
  }

  Future<List<Workout>> getWorkoutsByDateRange(
    int userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.workoutsTable,
      where: 'user_id = ? AND fecha BETWEEN ? AND ?',
      whereArgs: [
        userId,
        startDate.toIso8601String(),
        endDate.toIso8601String(),
      ],
      orderBy: 'fecha DESC',
    );
    return maps.map((map) => Workout.fromMap(map)).toList();
  }

  Future<List<Workout>> getWorkoutsByType(int userId, WorkoutType type) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.workoutsTable,
      where: 'user_id = ? AND tipo = ?',
      whereArgs: [userId, type.name],
      orderBy: 'fecha DESC',
    );
    return maps.map((map) => Workout.fromMap(map)).toList();
  }

  Future<int> updateWorkout(Workout workout) async {
    final db = await _dbHelper.database;
    return await db.update(
      DatabaseHelper.workoutsTable,
      workout.toMap(),
      where: 'id = ?',
      whereArgs: [workout.id],
    );
  }

  Future<int> deleteWorkout(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      DatabaseHelper.workoutsTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ========== Workout Exercises CRUD ==========
  Future<int> createWorkoutExercise(WorkoutExercise workoutExercise) async {
    final db = await _dbHelper.database;
    return await db.insert(DatabaseHelper.workoutExercisesTable, workoutExercise.toMap());
  }

  Future<List<WorkoutExercise>> getWorkoutExercisesByWorkoutId(int workoutId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.workoutExercisesTable,
      where: 'workout_id = ?',
      whereArgs: [workoutId],
    );
    return maps.map((map) => WorkoutExercise.fromMap(map)).toList();
  }

  Future<int> updateWorkoutExercise(WorkoutExercise workoutExercise) async {
    final db = await _dbHelper.database;
    return await db.update(
      DatabaseHelper.workoutExercisesTable,
      workoutExercise.toMap(),
      where: 'id = ?',
      whereArgs: [workoutExercise.id],
    );
  }

  Future<int> deleteWorkoutExercise(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      DatabaseHelper.workoutExercisesTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteWorkoutExercisesByWorkoutId(int workoutId) async {
    final db = await _dbHelper.database;
    return await db.delete(
      DatabaseHelper.workoutExercisesTable,
      where: 'workout_id = ?',
      whereArgs: [workoutId],
    );
  }

  // ========== Progress CRUD ==========
  Future<int> createProgress(Progress progress) async {
    final db = await _dbHelper.database;
    return await db.insert(DatabaseHelper.progressTable, progress.toMap());
  }

  Future<Progress?> getProgressById(int id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.progressTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Progress.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Progress>> getProgressByUserId(int userId, {int? limit}) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.progressTable,
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'fecha DESC',
      limit: limit,
    );
    return maps.map((map) => Progress.fromMap(map)).toList();
  }

  Future<Progress?> getLatestProgress(int userId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.progressTable,
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'fecha DESC',
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return Progress.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Progress>> getProgressByDateRange(
    int userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.progressTable,
      where: 'user_id = ? AND fecha BETWEEN ? AND ?',
      whereArgs: [
        userId,
        startDate.toIso8601String(),
        endDate.toIso8601String(),
      ],
      orderBy: 'fecha ASC',
    );
    return maps.map((map) => Progress.fromMap(map)).toList();
  }

  Future<int> updateProgress(Progress progress) async {
    final db = await _dbHelper.database;
    return await db.update(
      DatabaseHelper.progressTable,
      progress.toMap(),
      where: 'id = ?',
      whereArgs: [progress.id],
    );
  }

  Future<int> deleteProgress(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      DatabaseHelper.progressTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ========== Analytics Methods ==========
  Future<Map<String, dynamic>> getUserStats(int userId) async {
    final db = await _dbHelper.database;
    
    // Total workouts
    final totalWorkoutsResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${DatabaseHelper.workoutsTable} WHERE user_id = ?',
      [userId],
    );
    final totalWorkouts = totalWorkoutsResult.first['count'] as int;
    
    // Total calories burned
    final totalCaloriesResult = await db.rawQuery(
      'SELECT SUM(calorias) as total FROM ${DatabaseHelper.workoutsTable} WHERE user_id = ?',
      [userId],
    );
    final totalCalories = totalCaloriesResult.first['total'] as int? ?? 0;
    
    // Total exercise time
    final totalTimeResult = await db.rawQuery(
      'SELECT SUM(duracion) as total FROM ${DatabaseHelper.workoutsTable} WHERE user_id = ?',
      [userId],
    );
    final totalTime = totalTimeResult.first['total'] as int? ?? 0;
    
    return {
      'total_workouts': totalWorkouts,
      'total_calories': totalCalories,
      'total_time_minutes': totalTime,
    };
  }

  Future<List<Map<String, dynamic>>> getWeeklyStats(int userId) async {
    final db = await _dbHelper.database;
    final endDate = DateTime.now();
    final startDate = endDate.subtract(const Duration(days: 7));
    
    final result = await db.rawQuery('''
      SELECT 
        date(fecha) as date,
        COUNT(*) as workouts,
        SUM(calorias) as calories,
        SUM(duracion) as minutes
      FROM ${DatabaseHelper.workoutsTable}
      WHERE user_id = ? AND fecha BETWEEN ? AND ?
      GROUP BY date(fecha)
      ORDER BY date(fecha)
    ''', [userId, startDate.toIso8601String(), endDate.toIso8601String()]);
    
    return result;
  }
}