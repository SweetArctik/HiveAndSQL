class WorkoutExercise {
  final int? id;
  final int workoutId;
  final int exerciseId;
  final int series;
  final int repeticiones;
  final double? peso; // opcional, para ejercicios con peso
  final int? tiempoSegundos; // opcional, para ejercicios de tiempo (cardio)

  const WorkoutExercise({
    this.id,
    required this.workoutId,
    required this.exerciseId,
    required this.series,
    required this.repeticiones,
    this.peso,
    this.tiempoSegundos,
  });

  WorkoutExercise copyWith({
    int? id,
    int? workoutId,
    int? exerciseId,
    int? series,
    int? repeticiones,
    double? peso,
    int? tiempoSegundos,
  }) {
    return WorkoutExercise(
      id: id ?? this.id,
      workoutId: workoutId ?? this.workoutId,
      exerciseId: exerciseId ?? this.exerciseId,
      series: series ?? this.series,
      repeticiones: repeticiones ?? this.repeticiones,
      peso: peso ?? this.peso,
      tiempoSegundos: tiempoSegundos ?? this.tiempoSegundos,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'workout_id': workoutId,
      'exercise_id': exerciseId,
      'series': series,
      'repeticiones': repeticiones,
      'peso': peso,
      'tiempo_segundos': tiempoSegundos,
    };
  }

  factory WorkoutExercise.fromMap(Map<String, dynamic> map) {
    return WorkoutExercise(
      id: map['id'],
      workoutId: map['workout_id'] ?? 0,
      exerciseId: map['exercise_id'] ?? 0,
      series: map['series'] ?? 0,
      repeticiones: map['repeticiones'] ?? 0,
      peso: map['peso']?.toDouble(),
      tiempoSegundos: map['tiempo_segundos'],
    );
  }

  @override
  String toString() {
    return 'WorkoutExercise(id: $id, workoutId: $workoutId, exerciseId: $exerciseId, series: $series, repeticiones: $repeticiones, peso: $peso, tiempoSegundos: $tiempoSegundos)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WorkoutExercise &&
        other.id == id &&
        other.workoutId == workoutId &&
        other.exerciseId == exerciseId &&
        other.series == series &&
        other.repeticiones == repeticiones &&
        other.peso == peso &&
        other.tiempoSegundos == tiempoSegundos;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        workoutId.hashCode ^
        exerciseId.hashCode ^
        series.hashCode ^
        repeticiones.hashCode ^
        peso.hashCode ^
        tiempoSegundos.hashCode;
  }
}