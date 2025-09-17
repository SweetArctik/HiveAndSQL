import '../../domain/entities/entities.dart';
import '../../domain/repositories/preferences_repository.dart';
import '../datasources/hive_datasource.dart';

class PreferencesRepositoryImpl implements PreferencesRepository {
  final HiveDataSource _hiveDataSource;

  PreferencesRepositoryImpl({required HiveDataSource hiveDataSource})
      : _hiveDataSource = hiveDataSource;

  // ========== User Preferences ==========
  @override
  Future<UserPrefs> getUserPreferences() async {
    return await _hiveDataSource.getUserPreferences();
  }

  @override
  Future<void> saveUserPreferences(UserPrefs preferences) async {
    await _hiveDataSource.saveUserPreferences(preferences);
  }

  @override
  Future<void> updatePreference(String key, dynamic value) async {
    await _hiveDataSource.updatePreference(key, value);
  }

  // ========== Active Session Management ==========
  @override
  Future<ActiveSession?> getActiveSession() async {
    return await _hiveDataSource.getActiveSession();
  }

  @override
  Future<ActiveSession> createSession({List<ActiveExercise>? exercises}) async {
    return await _hiveDataSource.createNewSession(exercises: exercises);
  }

  @override
  Future<void> updateSession(ActiveSession session) async {
    await _hiveDataSource.updateActiveSession(session);
  }

  @override
  Future<void> clearSession() async {
    await _hiveDataSource.clearActiveSession();
  }

  @override
  Future<bool> hasActiveSession() async {
    return _hiveDataSource.hasActiveSession();
  }

  // ========== Session Exercise Management ==========
  @override
  Future<void> addExerciseToSession(ActiveExercise exercise) async {
    await _hiveDataSource.addExerciseToSession(exercise);
  }

  @override
  Future<void> updateExerciseInSession(int index, ActiveExercise exercise) async {
    await _hiveDataSource.updateExerciseInSession(index, exercise);
  }

  @override
  Future<void> removeExerciseFromSession(int index) async {
    await _hiveDataSource.removeExerciseFromSession(index);
  }

  @override
  Future<void> addSerieToExercise(int exerciseIndex, Serie serie) async {
    await _hiveDataSource.addSerieToExercise(exerciseIndex, serie);
  }

  // ========== Session State Management ==========
  @override
  Future<void> pauseSession() async {
    await _hiveDataSource.pauseSession();
  }

  @override
  Future<void> resumeSession() async {
    await _hiveDataSource.resumeSession();
  }

  @override
  Future<void> updateSessionDuration(int seconds) async {
    await _hiveDataSource.updateSessionDuration(seconds);
  }

  @override
  Future<void> updateSessionCalories(int calories) async {
    await _hiveDataSource.updateSessionCalories(calories);
  }

  // ========== Session Analytics ==========
  @override
  Future<bool> isSessionActive() async {
    return await _hiveDataSource.isSessionActive();
  }

  @override
  Future<bool> isSessionPaused() async {
    return await _hiveDataSource.isSessionPaused();
  }

  @override
  Future<int> getSessionDurationSeconds() async {
    return await _hiveDataSource.getSessionDurationSeconds();
  }

  @override
  Future<double> getSessionCompletionPercentage() async {
    return await _hiveDataSource.getSessionCompletionPercentage();
  }

  // ========== Filters ==========
  @override
  Future<Map<String, dynamic>> getLastFilters() async {
    return await _hiveDataSource.getLastFilters();
  }

  @override
  Future<void> saveLastFilters(Map<String, dynamic> filters) async {
    await _hiveDataSource.saveLastFilters(filters);
  }

  @override
  Future<void> updateFilter(String key, dynamic value) async {
    await _hiveDataSource.updateFilter(key, value);
  }

  @override
  Future<void> clearFilters() async {
    await _hiveDataSource.clearFilters();
  }

  // ========== Templates ==========
  @override
  Future<void> saveWorkoutTemplate(String name, List<ActiveExercise> exercises) async {
    await _hiveDataSource.cacheWorkoutTemplate(name, exercises);
  }

  @override
  Future<List<ActiveExercise>?> getWorkoutTemplate(String name) async {
    return await _hiveDataSource.getWorkoutTemplate(name);
  }

  @override
  Future<List<String>> getWorkoutTemplateNames() async {
    return await _hiveDataSource.getWorkoutTemplateNames();
  }

  @override
  Future<void> deleteWorkoutTemplate(String name) async {
    await _hiveDataSource.deleteWorkoutTemplate(name);
  }

  // ========== Cache Management ==========
  @override
  Future<void> cacheTodayStats(Map<String, dynamic> stats) async {
    await _hiveDataSource.cacheTodayStats(stats);
  }

  @override
  Future<Map<String, dynamic>> getCachedTodayStats() async {
    return await _hiveDataSource.getCachedTodayStats();
  }

  @override
  Future<bool> isTodayStatsCacheValid() async {
    return await _hiveDataSource.isTodayStatsCacheValid();
  }

  @override
  Future<void> invalidateCache([String? key]) async {
    await _hiveDataSource.invalidateCache(key);
  }
}