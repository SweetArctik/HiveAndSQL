import '../../core/utils/hive_helper.dart';
import '../../domain/entities/entities.dart';

class HiveDataSource {
  final HiveHelper _hiveHelper = HiveHelper.instance;

  // ========== User Preferences ==========
  Future<UserPrefs> getUserPreferences() async {
    final prefsMap = _hiveHelper.getUserPreferences();
    return UserPrefs.fromMap(prefsMap);
  }

  Future<void> saveUserPreferences(UserPrefs userPrefs) async {
    await _hiveHelper.saveUserPreferences(userPrefs.toMap());
  }

  Future<void> updatePreference(String key, dynamic value) async {
    final currentPrefs = _hiveHelper.getUserPreferences();
    currentPrefs[key] = value;
    await _hiveHelper.saveUserPreferences(currentPrefs);
  }

  // ========== Active Session ==========
  Future<ActiveSession?> getActiveSession() async {
    final sessionMap = _hiveHelper.getActiveSession();
    if (sessionMap != null) {
      return ActiveSession.fromMap(sessionMap);
    }
    return null;
  }

  Future<void> saveActiveSession(ActiveSession session) async {
    await _hiveHelper.saveActiveSession(session.toMap());
  }

  Future<void> updateActiveSession(ActiveSession session) async {
    await _hiveHelper.saveActiveSession(session.toMap());
  }

  Future<void> clearActiveSession() async {
    await _hiveHelper.clearActiveSession();
  }

  bool hasActiveSession() {
    return _hiveHelper.hasActiveSession();
  }

  // ========== Active Session Exercise Management ==========
  Future<void> addExerciseToSession(ActiveExercise exercise) async {
    final currentSession = await getActiveSession();
    if (currentSession != null) {
      final updatedExercises = [...currentSession.ejercicios, exercise];
      final updatedSession = currentSession.copyWith(ejercicios: updatedExercises);
      await saveActiveSession(updatedSession);
    }
  }

  Future<void> updateExerciseInSession(int exerciseIndex, ActiveExercise updatedExercise) async {
    final currentSession = await getActiveSession();
    if (currentSession != null && exerciseIndex < currentSession.ejercicios.length) {
      final updatedExercises = [...currentSession.ejercicios];
      updatedExercises[exerciseIndex] = updatedExercise;
      final updatedSession = currentSession.copyWith(ejercicios: updatedExercises);
      await saveActiveSession(updatedSession);
    }
  }

  Future<void> removeExerciseFromSession(int exerciseIndex) async {
    final currentSession = await getActiveSession();
    if (currentSession != null && exerciseIndex < currentSession.ejercicios.length) {
      final updatedExercises = [...currentSession.ejercicios];
      updatedExercises.removeAt(exerciseIndex);
      final updatedSession = currentSession.copyWith(ejercicios: updatedExercises);
      await saveActiveSession(updatedSession);
    }
  }

  Future<void> addSerieToExercise(int exerciseIndex, Serie serie) async {
    final currentSession = await getActiveSession();
    if (currentSession != null && exerciseIndex < currentSession.ejercicios.length) {
      final exercise = currentSession.ejercicios[exerciseIndex];
      final updatedSeries = [...exercise.seriesRealizadas, serie];
      final updatedExercise = exercise.copyWith(
        seriesRealizadas: updatedSeries,
        seriesCompletadas: updatedSeries.length,
        completado: updatedSeries.length >= exercise.seriesObjetivo,
      );
      await updateExerciseInSession(exerciseIndex, updatedExercise);
    }
  }

  Future<void> updateSessionDuration(int seconds) async {
    final currentSession = await getActiveSession();
    if (currentSession != null) {
      final updatedSession = currentSession.copyWith(duracionSegundos: seconds);
      await saveActiveSession(updatedSession);
    }
  }

  Future<void> updateSessionCalories(int calories) async {
    final currentSession = await getActiveSession();
    if (currentSession != null) {
      final updatedSession = currentSession.copyWith(caloriasActuales: calories);
      await saveActiveSession(updatedSession);
    }
  }

  Future<void> pauseSession() async {
    final currentSession = await getActiveSession();
    if (currentSession != null) {
      final updatedSession = currentSession.copyWith(pausada: true);
      await saveActiveSession(updatedSession);
    }
  }

  Future<void> resumeSession() async {
    final currentSession = await getActiveSession();
    if (currentSession != null) {
      final updatedSession = currentSession.copyWith(pausada: false);
      await saveActiveSession(updatedSession);
    }
  }

  // ========== Last Filters ==========
  Future<Map<String, dynamic>> getLastFilters() async {
    return _hiveHelper.getLastFilters();
  }

  Future<void> saveLastFilters(Map<String, dynamic> filters) async {
    await _hiveHelper.saveLastFilters(filters);
  }

  Future<void> updateFilter(String key, dynamic value) async {
    final currentFilters = _hiveHelper.getLastFilters();
    currentFilters[key] = value;
    await _hiveHelper.saveLastFilters(currentFilters);
  }

  Future<void> clearFilters() async {
    await _hiveHelper.saveLastFilters({
      'fecha_inicio': null,
      'fecha_fin': null,
      'tipo_ejercicio': null,
      'grupo_muscular': null,
    });
  }

  // ========== Quick Cache ==========
  Future<void> cacheRecentWorkouts(List<Workout> workouts) async {
    final workoutMaps = workouts.map((w) => w.toMap()).toList();
    await _hiveHelper.saveRecentWorkouts(workoutMaps);
  }

  Future<List<Workout>> getCachedRecentWorkouts() async {
    final workoutMaps = _hiveHelper.getRecentWorkouts();
    return workoutMaps.map((map) => Workout.fromMap(map)).toList();
  }

  Future<void> cacheTodayStats(Map<String, dynamic> stats) async {
    await _hiveHelper.saveTodayStats(stats);
  }

  Future<Map<String, dynamic>> getCachedTodayStats() async {
    return _hiveHelper.getTodayStats();
  }

  Future<bool> isTodayStatsCacheValid() async {
    final stats = _hiveHelper.getTodayStats();
    final today = DateTime.now().toIso8601String().split('T')[0];
    return stats['date'] == today;
  }

  // ========== Custom Cache Methods ==========
  Future<void> cacheExerciseList(List<Exercise> exercises, {String? cacheKey}) async {
    final key = cacheKey ?? 'exercises';
    final exerciseMaps = exercises.map((e) => e.toMap()).toList();
    await _hiveHelper.saveQuickCache(key, exerciseMaps);
  }

  Future<List<Exercise>> getCachedExerciseList({String? cacheKey}) async {
    final key = cacheKey ?? 'exercises';
    final exerciseMaps = _hiveHelper.getQuickCache(key);
    return exerciseMaps.map((map) => Exercise.fromMap(map)).toList();
  }

  Future<void> cacheProgressList(List<Progress> progressList, {String? cacheKey}) async {
    final key = cacheKey ?? 'progress';
    final progressMaps = progressList.map((p) => p.toMap()).toList();
    await _hiveHelper.saveQuickCache(key, progressMaps);
  }

  Future<List<Progress>> getCachedProgressList({String? cacheKey}) async {
    final key = cacheKey ?? 'progress';
    final progressMaps = _hiveHelper.getQuickCache(key);
    return progressMaps.map((map) => Progress.fromMap(map)).toList();
  }

  // ========== Cache Invalidation ==========
  Future<void> invalidateCache([String? key]) async {
    await _hiveHelper.clearQuickCache(key);
  }

  Future<void> invalidateAllCaches() async {
    await _hiveHelper.clearQuickCache();
  }

  // ========== Session Helpers ==========
  Future<ActiveSession> createNewSession({List<ActiveExercise>? exercises}) async {
    final sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    final newSession = ActiveSession(
      sessionId: sessionId,
      inicioSesion: DateTime.now(),
      ejercicios: exercises ?? [],
    );
    await saveActiveSession(newSession);
    return newSession;
  }

  Future<bool> isSessionActive() async {
    final session = await getActiveSession();
    return session != null && !session.pausada;
  }

  Future<bool> isSessionPaused() async {
    final session = await getActiveSession();
    return session != null && session.pausada;
  }

  Future<int> getSessionDurationSeconds() async {
    final session = await getActiveSession();
    if (session != null) {
      final now = DateTime.now();
      final elapsed = now.difference(session.inicioSesion).inSeconds;
      return elapsed;
    }
    return 0;
  }

  Future<double> getSessionCompletionPercentage() async {
    final session = await getActiveSession();
    if (session == null || session.ejercicios.isEmpty) return 0.0;
    
    int completedExercises = 0;
    for (final exercise in session.ejercicios) {
      if (exercise.completado) {
        completedExercises++;
      }
    }
    
    return completedExercises / session.ejercicios.length;
  }

  // ========== Workout Template Cache ==========
  Future<void> cacheWorkoutTemplate(String name, List<ActiveExercise> exercises) async {
    final templateKey = 'template_$name';
    final exerciseMaps = exercises.map((e) => e.toMap()).toList();
    await _hiveHelper.saveQuickCache(templateKey, exerciseMaps);
  }

  Future<List<ActiveExercise>?> getWorkoutTemplate(String name) async {
    final templateKey = 'template_$name';
    final exerciseMaps = _hiveHelper.getQuickCache(templateKey);
    if (exerciseMaps.isNotEmpty) {
      return exerciseMaps.map((map) => ActiveExercise.fromMap(map)).toList();
    }
    return null;
  }

  Future<List<String>> getWorkoutTemplateNames() async {
    final box = _hiveHelper.quickCache;
    final keys = box.keys.where((key) => key.toString().startsWith('template_')).toList();
    return keys.map((key) => key.toString().replaceFirst('template_', '')).toList();
  }

  Future<void> deleteWorkoutTemplate(String name) async {
    final templateKey = 'template_$name';
    await _hiveHelper.clearQuickCache(templateKey);
  }
}