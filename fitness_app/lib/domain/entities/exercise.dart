enum MuscleGroup {
  pecho,
  espalda,
  piernas,
  brazos,
  hombros,
  abdomen,
  cardio,
}

enum DifficultyLevel {
  principiante,
  intermedio,
  avanzado,
}

class Exercise {
  final int? id;
  final String nombre;
  final MuscleGroup grupoMuscular;
  final DifficultyLevel nivelDificultad;

  const Exercise({
    this.id,
    required this.nombre,
    required this.grupoMuscular,
    required this.nivelDificultad,
  });

  Exercise copyWith({
    int? id,
    String? nombre,
    MuscleGroup? grupoMuscular,
    DifficultyLevel? nivelDificultad,
  }) {
    return Exercise(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      grupoMuscular: grupoMuscular ?? this.grupoMuscular,
      nivelDificultad: nivelDificultad ?? this.nivelDificultad,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'grupo_muscular': grupoMuscular.name,
      'nivel_dificultad': nivelDificultad.name,
    };
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'],
      nombre: map['nombre'] ?? '',
      grupoMuscular: MuscleGroup.values.firstWhere(
        (e) => e.name == map['grupo_muscular'],
        orElse: () => MuscleGroup.cardio,
      ),
      nivelDificultad: DifficultyLevel.values.firstWhere(
        (e) => e.name == map['nivel_dificultad'],
        orElse: () => DifficultyLevel.principiante,
      ),
    );
  }

  @override
  String toString() {
    return 'Exercise(id: $id, nombre: $nombre, grupoMuscular: $grupoMuscular, nivelDificultad: $nivelDificultad)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Exercise &&
        other.id == id &&
        other.nombre == nombre &&
        other.grupoMuscular == grupoMuscular &&
        other.nivelDificultad == nivelDificultad;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nombre.hashCode ^
        grupoMuscular.hashCode ^
        nivelDificultad.hashCode;
  }
}