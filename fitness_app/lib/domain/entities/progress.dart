class Progress {
  final int? id;
  final int userId;
  final DateTime fecha;
  final double peso;
  final double imc;
  final Map<String, double> medidas; // e.g., {'cintura': 80.0, 'brazos': 35.0}

  const Progress({
    this.id,
    required this.userId,
    required this.fecha,
    required this.peso,
    required this.imc,
    required this.medidas,
  });

  Progress copyWith({
    int? id,
    int? userId,
    DateTime? fecha,
    double? peso,
    double? imc,
    Map<String, double>? medidas,
  }) {
    return Progress(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fecha: fecha ?? this.fecha,
      peso: peso ?? this.peso,
      imc: imc ?? this.imc,
      medidas: medidas ?? this.medidas,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'fecha': fecha.toIso8601String(),
      'peso': peso,
      'imc': imc,
      'medidas': _medidasToString(medidas),
    };
  }

  factory Progress.fromMap(Map<String, dynamic> map) {
    return Progress(
      id: map['id'],
      userId: map['user_id'] ?? 0,
      fecha: DateTime.parse(map['fecha'] ?? DateTime.now().toIso8601String()),
      peso: map['peso']?.toDouble() ?? 0.0,
      imc: map['imc']?.toDouble() ?? 0.0,
      medidas: _stringToMedidas(map['medidas'] ?? '{}'),
    );
  }

  // Helper methods para serializar/deserializar el Map de medidas
  static String _medidasToString(Map<String, double> medidas) {
    final List<String> entries = [];
    medidas.forEach((key, value) {
      entries.add('$key:$value');
    });
    return entries.join(',');
  }

  static Map<String, double> _stringToMedidas(String medidasString) {
    final Map<String, double> medidas = {};
    if (medidasString.isEmpty) return medidas;
    
    final entries = medidasString.split(',');
    for (final entry in entries) {
      final parts = entry.split(':');
      if (parts.length == 2) {
        medidas[parts[0]] = double.tryParse(parts[1]) ?? 0.0;
      }
    }
    return medidas;
  }

  @override
  String toString() {
    return 'Progress(id: $id, userId: $userId, fecha: $fecha, peso: $peso, imc: $imc, medidas: $medidas)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Progress &&
        other.id == id &&
        other.userId == userId &&
        other.fecha == fecha &&
        other.peso == peso &&
        other.imc == imc &&
        _mapEquals(other.medidas, medidas);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        fecha.hashCode ^
        peso.hashCode ^
        imc.hashCode ^
        medidas.hashCode;
  }

  // Helper method para comparar Maps
  static bool _mapEquals(Map<String, double> a, Map<String, double> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
  }
}