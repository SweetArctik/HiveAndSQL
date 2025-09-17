class UserPrefs {
  final String tema;
  final bool recordatoriosActivos;
  final List<String> horariosRecordatorios;
  final int objetivoCalorias;
  final int objetivoPasos;
  final int objetivoEntrenamientosSemana;

  const UserPrefs({
    this.tema = 'light',
    this.recordatoriosActivos = true,
    this.horariosRecordatorios = const [],
    this.objetivoCalorias = 2000,
    this.objetivoPasos = 10000,
    this.objetivoEntrenamientosSemana = 3,
  });

  UserPrefs copyWith({
    String? tema,
    bool? recordatoriosActivos,
    List<String>? horariosRecordatorios,
    int? objetivoCalorias,
    int? objetivoPasos,
    int? objetivoEntrenamientosSemana,
  }) {
    return UserPrefs(
      tema: tema ?? this.tema,
      recordatoriosActivos: recordatoriosActivos ?? this.recordatoriosActivos,
      horariosRecordatorios: horariosRecordatorios ?? this.horariosRecordatorios,
      objetivoCalorias: objetivoCalorias ?? this.objetivoCalorias,
      objetivoPasos: objetivoPasos ?? this.objetivoPasos,
      objetivoEntrenamientosSemana: objetivoEntrenamientosSemana ?? this.objetivoEntrenamientosSemana,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tema': tema,
      'recordatorios_activos': recordatoriosActivos,
      'horarios_recordatorios': horariosRecordatorios,
      'objetivo_calorias': objetivoCalorias,
      'objetivo_pasos': objetivoPasos,
      'objetivo_entrenamientos_semana': objetivoEntrenamientosSemana,
    };
  }

  factory UserPrefs.fromMap(Map<String, dynamic> map) {
    return UserPrefs(
      tema: map['tema'] ?? 'light',
      recordatoriosActivos: map['recordatorios_activos'] ?? true,
      horariosRecordatorios: List<String>.from(map['horarios_recordatorios'] ?? []),
      objetivoCalorias: map['objetivo_calorias'] ?? 2000,
      objetivoPasos: map['objetivo_pasos'] ?? 10000,
      objetivoEntrenamientosSemana: map['objetivo_entrenamientos_semana'] ?? 3,
    );
  }

  @override
  String toString() {
    return 'UserPrefs(tema: $tema, recordatoriosActivos: $recordatoriosActivos, horariosRecordatorios: $horariosRecordatorios, objetivoCalorias: $objetivoCalorias, objetivoPasos: $objetivoPasos, objetivoEntrenamientosSemana: $objetivoEntrenamientosSemana)';
  }
}