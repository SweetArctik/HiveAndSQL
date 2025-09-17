import 'package:hive_flutter/hive_flutter.dart';

class HiveHelper {
  // Box names
  static const String userPrefsBox = 'user_prefs';
  static const String activeSessionBox = 'active_session';
  static const String lastFiltersBox = 'last_filters';
  static const String quickCacheBox = 'quick_cache';

  // Private constructor
  HiveHelper._();
  static final HiveHelper _instance = HiveHelper._();
  static HiveHelper get instance => _instance;

  // Initialize Hive
  Future<void> initHive() async {
    // Initialize Hive for Flutter
    await Hive.initFlutter();

    // Register type adapters if using code generation
    // For now we'll use simple Map serialization

    // Open all boxes
    await _openBoxes();

    // Initialize default preferences if they don't exist
    await _initializeDefaultPreferences();
  }

  // Open all Hive boxes
  Future<void> _openBoxes() async {
    await Future.wait([
      Hive.openBox(userPrefsBox),
      Hive.openBox(activeSessionBox),
      Hive.openBox(lastFiltersBox),
      Hive.openBox(quickCacheBox),
    ]);
  }

  // Initialize default user preferences
  Future<void> _initializeDefaultPreferences() async {
    final prefsBox = Hive.box(userPrefsBox);

    if (prefsBox.isEmpty) {
      await prefsBox.put('prefs', {
        'tema': 'light',
        'recordatorios_activos': true,
        'horarios_recordatorios': <String>[],
        'objetivo_calorias': 2000,
        'objetivo_pasos': 10000,
        'objetivo_entrenamientos_semana': 3,
      });
    }
  }

  // Get a box by name
  Box getBox(String boxName) {
    return Hive.box(boxName);
  }

  // User Preferences methods
  Box get userPreferences => Hive.box(userPrefsBox);

  Future<void> saveUserPreferences(Map<String, dynamic> prefs) async {
    await userPreferences.put('prefs', prefs);
  }

  Map<String, dynamic> getUserPreferences() {
    return Map<String, dynamic>.from(
      userPreferences.get(
        'prefs',
        defaultValue: {
          'tema': 'light',
          'recordatorios_activos': true,
          'horarios_recordatorios': <String>[],
          'objetivo_calorias': 2000,
          'objetivo_pasos': 10000,
          'objetivo_entrenamientos_semana': 3,
        },
      ),
    );
  }

  // Active Session methods
  Box get activeSession => Hive.box(activeSessionBox);

  Future<void> saveActiveSession(Map<String, dynamic> session) async {
    await activeSession.put('current_session', session);
  }

  Map<String, dynamic>? getActiveSession() {
    final session = activeSession.get('current_session');
    return session != null ? Map<String, dynamic>.from(session) : null;
  }

  Future<void> clearActiveSession() async {
    await activeSession.clear();
  }

  bool hasActiveSession() {
    return activeSession.containsKey('current_session');
  }

  // Last Filters methods
  Box get lastFilters => Hive.box(lastFiltersBox);

  Future<void> saveLastFilters(Map<String, dynamic> filters) async {
    await lastFilters.put('filters', filters);
  }

  Map<String, dynamic> getLastFilters() {
    return Map<String, dynamic>.from(
      lastFilters.get(
        'filters',
        defaultValue: {
          'fecha_inicio': null,
          'fecha_fin': null,
          'tipo_ejercicio': null,
          'grupo_muscular': null,
        },
      ),
    );
  }

  // Quick Cache methods
  Box get quickCache => Hive.box(quickCacheBox);

  Future<void> saveQuickCache(
    String key,
    List<Map<String, dynamic>> data,
  ) async {
    await quickCache.put(key, data);
  }

  List<Map<String, dynamic>> getQuickCache(String key) {
    final data = quickCache.get(key);
    if (data is List) {
      return data.cast<Map<String, dynamic>>();
    }
    return [];
  }

  Future<void> clearQuickCache([String? key]) async {
    if (key != null) {
      await quickCache.delete(key);
    } else {
      await quickCache.clear();
    }
  }

  // Today's stats cache
  Future<void> saveTodayStats(Map<String, dynamic> stats) async {
    await quickCache.put('today_stats', stats);
  }

  Map<String, dynamic> getTodayStats() {
    return Map<String, dynamic>.from(
      quickCache.get(
        'today_stats',
        defaultValue: {
          'workouts_completed': 0,
          'calories_burned': 0,
          'minutes_exercised': 0,
          'date': DateTime.now().toIso8601String().split('T')[0],
        },
      ),
    );
  }

  // Recent workouts cache
  Future<void> saveRecentWorkouts(List<Map<String, dynamic>> workouts) async {
    await saveQuickCache('recent_workouts', workouts);
  }

  List<Map<String, dynamic>> getRecentWorkouts() {
    return getQuickCache('recent_workouts');
  }

  // Close all boxes
  Future<void> closeAll() async {
    await Hive.close();
  }

  // Clear all data (for testing/reset)
  Future<void> clearAllData() async {
    await userPreferences.clear();
    await activeSession.clear();
    await lastFilters.clear();
    await quickCache.clear();

    // Reinitialize default preferences
    await _initializeDefaultPreferences();
  }
}
