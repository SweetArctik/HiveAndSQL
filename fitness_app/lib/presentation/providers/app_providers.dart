import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/local_database_datasource.dart';
import '../../data/datasources/hive_datasource.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../data/repositories/workout_repository_impl.dart';
import '../../data/repositories/preferences_repository_impl.dart';
import '../../data/repositories/progress_repository_impl.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/repositories/workout_repository.dart';
import '../../domain/repositories/preferences_repository.dart';
import '../../domain/repositories/progress_repository.dart';
import '../../domain/entities/entities.dart';

// ========== Data Sources ==========
final localDatabaseDataSourceProvider = Provider<LocalDatabaseDataSource>((ref) {
  return LocalDatabaseDataSource();
});

final hiveDataSourceProvider = Provider<HiveDataSource>((ref) {
  return HiveDataSource();
});

// ========== Repositories ==========
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final localDataSource = ref.read(localDatabaseDataSourceProvider);
  return UserRepositoryImpl(localDataSource: localDataSource);
});

final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  final localDataSource = ref.read(localDatabaseDataSourceProvider);
  final hiveDataSource = ref.read(hiveDataSourceProvider);
  return WorkoutRepositoryImpl(
    localDataSource: localDataSource,
    hiveDataSource: hiveDataSource,
  );
});

final preferencesRepositoryProvider = Provider<PreferencesRepository>((ref) {
  final hiveDataSource = ref.read(hiveDataSourceProvider);
  return PreferencesRepositoryImpl(hiveDataSource: hiveDataSource);
});

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  final localDataSource = ref.read(localDatabaseDataSourceProvider);
  final hiveDataSource = ref.read(hiveDataSourceProvider);
  return ProgressRepositoryImpl(
    localDataSource: localDataSource,
    hiveDataSource: hiveDataSource,
  );
});

// ========== Current User ==========
final currentUserProvider = FutureProvider<User?>((ref) async {
  final userRepository = ref.read(userRepositoryProvider);
  return await userRepository.getCurrentUser();
});

// ========== User Preferences ==========
final userPreferencesProvider = FutureProvider<UserPrefs>((ref) async {
  final preferencesRepository = ref.read(preferencesRepositoryProvider);
  return await preferencesRepository.getUserPreferences();
});

// ========== Active Session ==========
final activeSessionProvider = StateNotifierProvider<ActiveSessionNotifier, AsyncValue<ActiveSession?>>((ref) {
  final preferencesRepository = ref.read(preferencesRepositoryProvider);
  return ActiveSessionNotifier(preferencesRepository);
});

class ActiveSessionNotifier extends StateNotifier<AsyncValue<ActiveSession?>> {
  final PreferencesRepository _preferencesRepository;

  ActiveSessionNotifier(this._preferencesRepository) : super(const AsyncValue.loading()) {
    _loadActiveSession();
  }

  Future<void> _loadActiveSession() async {
    try {
      final session = await _preferencesRepository.getActiveSession();
      state = AsyncValue.data(session);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> createSession({List<ActiveExercise>? exercises}) async {
    try {
      final session = await _preferencesRepository.createSession(exercises: exercises);
      state = AsyncValue.data(session);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> clearSession() async {
    try {
      await _preferencesRepository.clearSession();
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addExercise(ActiveExercise exercise) async {
    try {
      await _preferencesRepository.addExerciseToSession(exercise);
      await _loadActiveSession(); // Reload to get updated state
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addSerie(int exerciseIndex, Serie serie) async {
    try {
      await _preferencesRepository.addSerieToExercise(exerciseIndex, serie);
      await _loadActiveSession(); // Reload to get updated state
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

// ========== Exercises ==========
final exercisesProvider = FutureProvider<List<Exercise>>((ref) async {
  final workoutRepository = ref.read(workoutRepositoryProvider);
  return await workoutRepository.getAllExercises();
});

final exercisesByMuscleGroupProvider = FutureProvider.family<List<Exercise>, MuscleGroup>((ref, muscleGroup) async {
  final workoutRepository = ref.read(workoutRepositoryProvider);
  return await workoutRepository.getExercisesByMuscleGroup(muscleGroup);
});

// ========== User Workouts ==========
final userWorkoutsProvider = FutureProvider.family<List<Workout>, int>((ref, userId) async {
  final workoutRepository = ref.read(workoutRepositoryProvider);
  return await workoutRepository.getUserWorkouts(userId, limit: 20);
});

// ========== Recent Workouts ==========
final recentWorkoutsProvider = FutureProvider<List<Workout>>((ref) async {
  final workoutRepository = ref.read(workoutRepositoryProvider);
  return await workoutRepository.getCachedRecentWorkouts();
});

// ========== User Stats ==========
final userStatsProvider = FutureProvider.family<Map<String, dynamic>, int>((ref, userId) async {
  final workoutRepository = ref.read(workoutRepositoryProvider);
  return await workoutRepository.getUserStats(userId);
});

// ========== Today Stats ==========
final todayStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final preferencesRepository = ref.read(preferencesRepositoryProvider);
  
  final isValid = await preferencesRepository.isTodayStatsCacheValid();
  if (isValid) {
    return await preferencesRepository.getCachedTodayStats();
  }
  
  // If cache is not valid, return default values
  // In a real app, you would calculate today's stats here
  final defaultStats = {
    'workouts_completed': 0,
    'calories_burned': 0,
    'minutes_exercised': 0,
    'date': DateTime.now().toIso8601String().split('T')[0],
  };
  
  await preferencesRepository.cacheTodayStats(defaultStats);
  return defaultStats;
});

// ========== User Progress ==========
final userProgressProvider = FutureProvider.family<List<Progress>, int>((ref, userId) async {
  final progressRepository = ref.read(progressRepositoryProvider);
  return await progressRepository.getUserProgress(userId, limit: 10);
});

final latestProgressProvider = FutureProvider.family<Progress?, int>((ref, userId) async {
  final progressRepository = ref.read(progressRepositoryProvider);
  return await progressRepository.getLatestProgress(userId);
});