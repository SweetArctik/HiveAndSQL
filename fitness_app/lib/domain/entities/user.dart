class User {
  final int? id;
  final String nombre;
  final String email;
  final int edad;
  final double pesoInicial;

  const User({
    this.id,
    required this.nombre,
    required this.email,
    required this.edad,
    required this.pesoInicial,
  });

  User copyWith({
    int? id,
    String? nombre,
    String? email,
    int? edad,
    double? pesoInicial,
  }) {
    return User(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      email: email ?? this.email,
      edad: edad ?? this.edad,
      pesoInicial: pesoInicial ?? this.pesoInicial,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'email': email,
      'edad': edad,
      'peso_inicial': pesoInicial,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      nombre: map['nombre'] ?? '',
      email: map['email'] ?? '',
      edad: map['edad'] ?? 0,
      pesoInicial: map['peso_inicial']?.toDouble() ?? 0.0,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, nombre: $nombre, email: $email, edad: $edad, pesoInicial: $pesoInicial)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.id == id &&
        other.nombre == nombre &&
        other.email == email &&
        other.edad == edad &&
        other.pesoInicial == pesoInicial;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nombre.hashCode ^
        email.hashCode ^
        edad.hashCode ^
        pesoInicial.hashCode;
  }
}