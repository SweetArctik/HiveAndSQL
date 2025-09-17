import '../entities/entities.dart';

abstract class WorkoutRepository {
  // Workout CRUD
  Future<Workout> createWorkout(Workout workout);
  Future<Workout?> getWorkoutById(int id);
  Future<List<Workout>> getUserWorkouts(int userId, {int? limit});
  Future<List<Workout>> getWorkoutsByDateRange(int userId, DateTime start, DateTime end);
  Future<List<Workout>> getWorkoutsByType(int userId, WorkoutType type);
  Future<Workout> updateWorkout(Workout workout);
  Future<void> deleteWorkout(int id);

  // Exercise CRUD
  Future<Exercise> createExercise(Exercise exercise);
  Future<Exercise?> getExerciseById(int id);
  Future<List<Exercise>> getAllExercises();
  Future<List<Exercise>> getExercisesByMuscleGroup(MuscleGroup muscleGroup);
  Future<List<Exercise>> getExercisesByDifficulty(DifficultyLevel difficulty);
  Future<Exercise> updateExercise(Exercise exercise);
  Future<void> deleteExercise(int id);

  // Workout Exercise CRUD
  Future<WorkoutExercise> createWorkoutExercise(WorkoutExercise workoutExercise);
  Future<List<WorkoutExercise>> getWorkoutExercises(int workoutId);
  Future<WorkoutExercise> updateWorkoutExercise(WorkoutExercise workoutExercise);
  Future<void> deleteWorkoutExercise(int id);

  // Complete Workout Creation (Workout + Exercises)
  Future<Workout> createCompleteWorkout(
    Workout workout,
    List<WorkoutExercise> exercises,
  );

  // Analytics
  Future<Map<String, dynamic>> getUserStats(int userId);
  Future<List<Map<String, dynamic>>> getWeeklyStats(int userId);
  
  // Cache Management
  Future<void> cacheRecentWorkouts(int userId);
  Future<List<Workout>> getCachedRecentWorkouts();
}