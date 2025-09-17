import '../../domain/entities/entities.dart';
import '../../domain/repositories/workout_repository.dart';
import '../datasources/local_database_datasource.dart';
import '../datasources/hive_datasource.dart';

class WorkoutRepositoryImpl implements WorkoutRepository {
  final LocalDatabaseDataSource _localDataSource;
  final HiveDataSource _hiveDataSource;

  WorkoutRepositoryImpl({
    required LocalDatabaseDataSource localDataSource,
    required HiveDataSource hiveDataSource,
  })  : _localDataSource = localDataSource,
        _hiveDataSource = hiveDataSource;

  // ========== Workout CRUD ==========
  @override
  Future<Workout> createWorkout(Workout workout) async {
    final id = await _localDataSource.createWorkout(workout);
    final createdWorkout = workout.copyWith(id: id);
    
    // Invalidate cache after creating new workout
    await _hiveDataSource.invalidateCache('recent_workouts');
    
    return createdWorkout;
  }

  @override
  Future<Workout?> getWorkoutById(int id) async {
    return await _localDataSource.getWorkoutById(id);
  }

  @override
  Future<List<Workout>> getUserWorkouts(int userId, {int? limit}) async {
    return await _localDataSource.getWorkoutsByUserId(userId, limit: limit);
  }

  @override
  Future<List<Workout>> getWorkoutsByDateRange(
    int userId,
    DateTime start,
    DateTime end,
  ) async {
    return await _localDataSource.getWorkoutsByDateRange(userId, start, end);
  }

  @override
  Future<List<Workout>> getWorkoutsByType(int userId, WorkoutType type) async {
    return await _localDataSource.getWorkoutsByType(userId, type);
  }

  @override
  Future<Workout> updateWorkout(Workout workout) async {
    await _localDataSource.updateWorkout(workout);
    await _hiveDataSource.invalidateCache('recent_workouts');
    return workout;
  }

  @override
  Future<void> deleteWorkout(int id) async {
    await _localDataSource.deleteWorkout(id);
    await _hiveDataSource.invalidateCache('recent_workouts');
  }

  // ========== Exercise CRUD ==========
  @override
  Future<Exercise> createExercise(Exercise exercise) async {
    final id = await _localDataSource.createExercise(exercise);
    return exercise.copyWith(id: id);
  }

  @override
  Future<Exercise?> getExerciseById(int id) async {
    return await _localDataSource.getExerciseById(id);
  }

  @override
  Future<List<Exercise>> getAllExercises() async {
    // Try to get from cache first
    try {
      final cached = await _hiveDataSource.getCachedExerciseList();
      if (cached.isNotEmpty) {
        return cached;
      }
    } catch (e) {
      // Cache miss, continue to database
    }
    
    final exercises = await _localDataSource.getAllExercises();
    
    // Cache the results
    await _hiveDataSource.cacheExerciseList(exercises);
    
    return exercises;
  }

  @override
  Future<List<Exercise>> getExercisesByMuscleGroup(MuscleGroup muscleGroup) async {
    return await _localDataSource.getExercisesByMuscleGroup(muscleGroup);
  }

  @override
  Future<List<Exercise>> getExercisesByDifficulty(DifficultyLevel difficulty) async {
    return await _localDataSource.getExercisesByDifficulty(difficulty);
  }

  @override
  Future<Exercise> updateExercise(Exercise exercise) async {
    await _localDataSource.updateExercise(exercise);
    await _hiveDataSource.invalidateCache('exercises');
    return exercise;
  }

  @override
  Future<void> deleteExercise(int id) async {
    await _localDataSource.deleteExercise(id);
    await _hiveDataSource.invalidateCache('exercises');
  }

  // ========== Workout Exercise CRUD ==========
  @override
  Future<WorkoutExercise> createWorkoutExercise(WorkoutExercise workoutExercise) async {
    final id = await _localDataSource.createWorkoutExercise(workoutExercise);
    return workoutExercise.copyWith(id: id);
  }

  @override
  Future<List<WorkoutExercise>> getWorkoutExercises(int workoutId) async {
    return await _localDataSource.getWorkoutExercisesByWorkoutId(workoutId);
  }

  @override
  Future<WorkoutExercise> updateWorkoutExercise(WorkoutExercise workoutExercise) async {
    await _localDataSource.updateWorkoutExercise(workoutExercise);
    return workoutExercise;
  }

  @override
  Future<void> deleteWorkoutExercise(int id) async {
    await _localDataSource.deleteWorkoutExercise(id);
  }

  // ========== Complete Workout Creation ==========
  @override
  Future<Workout> createCompleteWorkout(
    Workout workout,
    List<WorkoutExercise> exercises,
  ) async {
    final workoutId = await _localDataSource.createWorkout(workout);
    final createdWorkout = workout.copyWith(id: workoutId);
    
    // Create all workout exercises
    for (final exercise in exercises) {
      final exerciseWithWorkoutId = exercise.copyWith(workoutId: workoutId);
      await _localDataSource.createWorkoutExercise(exerciseWithWorkoutId);
    }
    
    // Update cache
    await cacheRecentWorkouts(workout.userId);
    await _hiveDataSource.invalidateCache('today_stats');
    
    return createdWorkout;
  }

  // ========== Analytics ==========
  @override
  Future<Map<String, dynamic>> getUserStats(int userId) async {
    return await _localDataSource.getUserStats(userId);
  }

  @override
  Future<List<Map<String, dynamic>>> getWeeklyStats(int userId) async {
    return await _localDataSource.getWeeklyStats(userId);
  }

  // ========== Cache Management ==========
  @override
  Future<void> cacheRecentWorkouts(int userId) async {
    final workouts = await _localDataSource.getWorkoutsByUserId(userId, limit: 10);
    await _hiveDataSource.cacheRecentWorkouts(workouts);
  }

  @override
  Future<List<Workout>> getCachedRecentWorkouts() async {
    return await _hiveDataSource.getCachedRecentWorkouts();
  }

  // ========== Helper Methods ==========
  Future<Workout> createWorkoutFromActiveSession(ActiveSession session, int userId) async {
    // Calculate total calories and duration
    int totalCalories = session.caloriasActuales;
    int totalDuration = session.duracionSegundos ~/ 60; // Convert to minutes
    
    // Determine workout type based on exercises
    WorkoutType workoutType = _determineWorkoutType(session.ejercicios);
    
    // Create workout
    final workout = Workout(
      userId: userId,
      fecha: session.inicioSesion,
      duracion: totalDuration,
      calorias: totalCalories,
      tipo: workoutType,
    );
    
    // Create workout exercises from session
    List<WorkoutExercise> workoutExercises = [];
    for (final activeExercise in session.ejercicios) {
      if (activeExercise.seriesRealizadas.isNotEmpty) {
        // Calculate average values from series
        double avgPeso = 0;
        int totalReps = 0;
        int totalTime = 0;
        
        for (final serie in activeExercise.seriesRealizadas) {
          if (serie.peso != null) avgPeso += serie.peso!;
          totalReps += serie.repeticiones;
          if (serie.tiempoSegundos != null) totalTime += serie.tiempoSegundos!;
        }
        
        if (activeExercise.seriesRealizadas.isNotEmpty) {
          avgPeso /= activeExercise.seriesRealizadas.length;
        }
        
        final workoutExercise = WorkoutExercise(
          workoutId: 0, // Will be set when workout is created
          exerciseId: activeExercise.exerciseId,
          series: activeExercise.seriesRealizadas.length,
          repeticiones: totalReps ~/ activeExercise.seriesRealizadas.length,
          peso: avgPeso > 0 ? avgPeso : null,
          tiempoSegundos: totalTime > 0 ? totalTime : null,
        );
        
        workoutExercises.add(workoutExercise);
      }
    }
    
    // Create complete workout
    return await createCompleteWorkout(workout, workoutExercises);
  }

  WorkoutType _determineWorkoutType(List<ActiveExercise> exercises) {
    if (exercises.isEmpty) return WorkoutType.mixto;
    
    // Simple heuristic: if most exercises have weight, it's strength training
    int weightExercises = exercises.where((e) => 
      e.seriesRealizadas.any((s) => s.peso != null && s.peso! > 0)).length;
    
    int cardioExercises = exercises.where((e) => 
      e.seriesRealizadas.any((s) => s.tiempoSegundos != null && s.tiempoSegundos! > 0)).length;
    
    if (weightExercises > cardioExercises) {
      return WorkoutType.fuerza;
    } else if (cardioExercises > weightExercises) {
      return WorkoutType.cardio;
    } else {
      return WorkoutType.mixto;
    }
  }
}