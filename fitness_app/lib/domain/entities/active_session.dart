class ActiveSession {
  final String sessionId;
  final DateTime inicioSesion;
  final List<ActiveExercise> ejercicios;
  final int caloriasActuales;
  final int duracionSegundos;
  final bool pausada;

  const ActiveSession({
    required this.sessionId,
    required this.inicioSesion,
    this.ejercicios = const [],
    this.caloriasActuales = 0,
    this.duracionSegundos = 0,
    this.pausada = false,
  });

  ActiveSession copyWith({
    String? sessionId,
    DateTime? inicioSesion,
    List<ActiveExercise>? ejercicios,
    int? caloriasActuales,
    int? duracionSegundos,
    bool? pausada,
  }) {
    return ActiveSession(
      sessionId: sessionId ?? this.sessionId,
      inicioSesion: inicioSesion ?? this.inicioSesion,
      ejercicios: ejercicios ?? this.ejercicios,
      caloriasActuales: caloriasActuales ?? this.caloriasActuales,
      duracionSegundos: duracionSegundos ?? this.duracionSegundos,
      pausada: pausada ?? this.pausada,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'session_id': sessionId,
      'inicio_sesion': inicioSesion.toIso8601String(),
      'ejercicios': ejercicios.map((e) => e.toMap()).toList(),
      'calorias_actuales': caloriasActuales,
      'duracion_segundos': duracionSegundos,
      'pausada': pausada,
    };
  }

  factory ActiveSession.fromMap(Map<String, dynamic> map) {
    return ActiveSession(
      sessionId: map['session_id'] ?? '',
      inicioSesion: DateTime.parse(
        map['inicio_sesion'] ?? DateTime.now().toIso8601String(),
      ),
      ejercicios: (map['ejercicios'] as List? ?? [])
          .map((e) => ActiveExercise.fromMap(e))
          .toList(),
      caloriasActuales: map['calorias_actuales'] ?? 0,
      duracionSegundos: map['duracion_segundos'] ?? 0,
      pausada: map['pausada'] ?? false,
    );
  }

  @override
  String toString() {
    return 'ActiveSession(sessionId: $sessionId, inicioSesion: $inicioSesion, ejercicios: $ejercicios, caloriasActuales: $caloriasActuales, duracionSegundos: $duracionSegundos, pausada: $pausada)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ActiveSession &&
        other.sessionId == sessionId &&
        other.inicioSesion == inicioSesion &&
        _listEquals(other.ejercicios, ejercicios) &&
        other.caloriasActuales == caloriasActuales &&
        other.duracionSegundos == duracionSegundos &&
        other.pausada == pausada;
  }

  @override
  int get hashCode {
    return sessionId.hashCode ^
        inicioSesion.hashCode ^
        ejercicios.hashCode ^
        caloriasActuales.hashCode ^
        duracionSegundos.hashCode ^
        pausada.hashCode;
  }

  // Helper method para comparar listas
  static bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

class ActiveExercise {
  final int exerciseId;
  final String nombre;
  final int seriesObjetivo;
  final int repeticionesObjetivo;
  final int seriesCompletadas;
  final List<Serie> seriesRealizadas;
  final bool completado;

  const ActiveExercise({
    required this.exerciseId,
    required this.nombre,
    required this.seriesObjetivo,
    required this.repeticionesObjetivo,
    this.seriesCompletadas = 0,
    this.seriesRealizadas = const [],
    this.completado = false,
  });

  ActiveExercise copyWith({
    int? exerciseId,
    String? nombre,
    int? seriesObjetivo,
    int? repeticionesObjetivo,
    int? seriesCompletadas,
    List<Serie>? seriesRealizadas,
    bool? completado,
  }) {
    return ActiveExercise(
      exerciseId: exerciseId ?? this.exerciseId,
      nombre: nombre ?? this.nombre,
      seriesObjetivo: seriesObjetivo ?? this.seriesObjetivo,
      repeticionesObjetivo: repeticionesObjetivo ?? this.repeticionesObjetivo,
      seriesCompletadas: seriesCompletadas ?? this.seriesCompletadas,
      seriesRealizadas: seriesRealizadas ?? this.seriesRealizadas,
      completado: completado ?? this.completado,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'exercise_id': exerciseId,
      'nombre': nombre,
      'series_objetivo': seriesObjetivo,
      'repeticiones_objetivo': repeticionesObjetivo,
      'series_completadas': seriesCompletadas,
      'series_realizadas': seriesRealizadas.map((e) => e.toMap()).toList(),
      'completado': completado,
    };
  }

  factory ActiveExercise.fromMap(Map<String, dynamic> map) {
    return ActiveExercise(
      exerciseId: map['exercise_id'] ?? 0,
      nombre: map['nombre'] ?? '',
      seriesObjetivo: map['series_objetivo'] ?? 0,
      repeticionesObjetivo: map['repeticiones_objetivo'] ?? 0,
      seriesCompletadas: map['series_completadas'] ?? 0,
      seriesRealizadas: (map['series_realizadas'] as List? ?? [])
          .map((e) => Serie.fromMap(e))
          .toList(),
      completado: map['completado'] ?? false,
    );
  }

  @override
  String toString() {
    return 'ActiveExercise(exerciseId: $exerciseId, nombre: $nombre, seriesObjetivo: $seriesObjetivo, repeticionesObjetivo: $repeticionesObjetivo, seriesCompletadas: $seriesCompletadas, seriesRealizadas: $seriesRealizadas, completado: $completado)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ActiveExercise &&
        other.exerciseId == exerciseId &&
        other.nombre == nombre &&
        other.seriesObjetivo == seriesObjetivo &&
        other.repeticionesObjetivo == repeticionesObjetivo &&
        other.seriesCompletadas == seriesCompletadas &&
        ActiveSession._listEquals(other.seriesRealizadas, seriesRealizadas) &&
        other.completado == completado;
  }

  @override
  int get hashCode {
    return exerciseId.hashCode ^
        nombre.hashCode ^
        seriesObjetivo.hashCode ^
        repeticionesObjetivo.hashCode ^
        seriesCompletadas.hashCode ^
        seriesRealizadas.hashCode ^
        completado.hashCode;
  }
}

class Serie {
  final int repeticiones;
  final double? peso;
  final int? tiempoSegundos;
  final DateTime timestamp;

  const Serie({
    required this.repeticiones,
    this.peso,
    this.tiempoSegundos,
    required this.timestamp,
  });

  Serie copyWith({
    int? repeticiones,
    double? peso,
    int? tiempoSegundos,
    DateTime? timestamp,
  }) {
    return Serie(
      repeticiones: repeticiones ?? this.repeticiones,
      peso: peso ?? this.peso,
      tiempoSegundos: tiempoSegundos ?? this.tiempoSegundos,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'repeticiones': repeticiones,
      'peso': peso,
      'tiempo_segundos': tiempoSegundos,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Serie.fromMap(Map<String, dynamic> map) {
    return Serie(
      repeticiones: map['repeticiones'] ?? 0,
      peso: map['peso']?.toDouble(),
      tiempoSegundos: map['tiempo_segundos'],
      timestamp: DateTime.parse(
        map['timestamp'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  @override
  String toString() {
    return 'Serie(repeticiones: $repeticiones, peso: $peso, tiempoSegundos: $tiempoSegundos, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Serie &&
        other.repeticiones == repeticiones &&
        other.peso == peso &&
        other.tiempoSegundos == tiempoSegundos &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return repeticiones.hashCode ^
        peso.hashCode ^
        tiempoSegundos.hashCode ^
        timestamp.hashCode;
  }
}
