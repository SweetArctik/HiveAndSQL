enum WorkoutType {
  fuerza,
  cardio,
  mixto,
  flexibilidad,
}

class Workout {
  final int? id;
  final int userId;
  final DateTime fecha;
  final int duracion; // en minutos
  final int calorias;
  final WorkoutType tipo;

  const Workout({
    this.id,
    required this.userId,
    required this.fecha,
    required this.duracion,
    required this.calorias,
    required this.tipo,
  });

  Workout copyWith({
    int? id,
    int? userId,
    DateTime? fecha,
    int? duracion,
    int? calorias,
    WorkoutType? tipo,
  }) {
    return Workout(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fecha: fecha ?? this.fecha,
      duracion: duracion ?? this.duracion,
      calorias: calorias ?? this.calorias,
      tipo: tipo ?? this.tipo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'fecha': fecha.toIso8601String(),
      'duracion': duracion,
      'calorias': calorias,
      'tipo': tipo.name,
    };
  }

  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      id: map['id'],
      userId: map['user_id'] ?? 0,
      fecha: DateTime.parse(map['fecha'] ?? DateTime.now().toIso8601String()),
      duracion: map['duracion'] ?? 0,
      calorias: map['calorias'] ?? 0,
      tipo: WorkoutType.values.firstWhere(
        (e) => e.name == map['tipo'],
        orElse: () => WorkoutType.mixto,
      ),
    );
  }

  @override
  String toString() {
    return 'Workout(id: $id, userId: $userId, fecha: $fecha, duracion: $duracion, calorias: $calorias, tipo: $tipo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Workout &&
        other.id == id &&
        other.userId == userId &&
        other.fecha == fecha &&
        other.duracion == duracion &&
        other.calorias == calorias &&
        other.tipo == tipo;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        fecha.hashCode ^
        duracion.hashCode ^
        calorias.hashCode ^
        tipo.hashCode;
  }
}