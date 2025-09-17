import '../entities/entities.dart';

abstract class PreferencesRepository {
  // User Preferences
  Future<UserPrefs> getUserPreferences();
  Future<void> saveUserPreferences(UserPrefs preferences);
  Future<void> updatePreference(String key, dynamic value);

  // Active Session Management
  Future<ActiveSession?> getActiveSession();
  Future<ActiveSession> createSession({List<ActiveExercise>? exercises});
  Future<void> updateSession(ActiveSession session);
  Future<void> clearSession();
  Future<bool> hasActiveSession();

  // Session Exercise Management
  Future<void> addExerciseToSession(ActiveExercise exercise);
  Future<void> updateExerciseInSession(int index, ActiveExercise exercise);
  Future<void> removeExerciseFromSession(int index);
  Future<void> addSerieToExercise(int exerciseIndex, Serie serie);
  
  // Session State Management
  Future<void> pauseSession();
  Future<void> resumeSession();
  Future<void> updateSessionDuration(int seconds);
  Future<void> updateSessionCalories(int calories);

  // Session Analytics
  Future<bool> isSessionActive();
  Future<bool> isSessionPaused();
  Future<int> getSessionDurationSeconds();
  Future<double> getSessionCompletionPercentage();

  // Filters
  Future<Map<String, dynamic>> getLastFilters();
  Future<void> saveLastFilters(Map<String, dynamic> filters);
  Future<void> updateFilter(String key, dynamic value);
  Future<void> clearFilters();

  // Templates
  Future<void> saveWorkoutTemplate(String name, List<ActiveExercise> exercises);
  Future<List<ActiveExercise>?> getWorkoutTemplate(String name);
  Future<List<String>> getWorkoutTemplateNames();
  Future<void> deleteWorkoutTemplate(String name);

  // Cache Management
  Future<void> cacheTodayStats(Map<String, dynamic> stats);
  Future<Map<String, dynamic>> getCachedTodayStats();
  Future<bool> isTodayStatsCacheValid();
  Future<void> invalidateCache([String? key]);
}