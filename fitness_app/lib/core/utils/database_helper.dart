import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const String _databaseName = 'fitness_app.db';
  static const int _databaseVersion = 1;

  // Nombres de las tablas
  static const String usersTable = 'users';
  static const String workoutsTable = 'workouts';
  static const String exercisesTable = 'exercises';
  static const String workoutExercisesTable = 'workout_exercises';
  static const String progressTable = 'progress';

  static Database? _database;

  // Singleton instance
  DatabaseHelper._();
  static final DatabaseHelper _instance = DatabaseHelper._();
  static DatabaseHelper get instance => _instance;

  // Database getter
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize database
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // Create tables
  Future<void> _onCreate(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE $usersTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        edad INTEGER NOT NULL,
        peso_inicial REAL NOT NULL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Exercises table
    await db.execute('''
      CREATE TABLE $exercisesTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        grupo_muscular TEXT NOT NULL,
        nivel_dificultad TEXT NOT NULL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Workouts table
    await db.execute('''
      CREATE TABLE $workoutsTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        fecha TEXT NOT NULL,
        duracion INTEGER NOT NULL,
        calorias INTEGER NOT NULL,
        tipo TEXT NOT NULL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES $usersTable (id) ON DELETE CASCADE
      )
    ''');

    // Workout exercises table
    await db.execute('''
      CREATE TABLE $workoutExercisesTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        workout_id INTEGER NOT NULL,
        exercise_id INTEGER NOT NULL,
        series INTEGER NOT NULL,
        repeticiones INTEGER NOT NULL,
        peso REAL,
        tiempo_segundos INTEGER,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (workout_id) REFERENCES $workoutsTable (id) ON DELETE CASCADE,
        FOREIGN KEY (exercise_id) REFERENCES $exercisesTable (id) ON DELETE CASCADE
      )
    ''');

    // Progress table
    await db.execute('''
      CREATE TABLE $progressTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        fecha TEXT NOT NULL,
        peso REAL NOT NULL,
        imc REAL NOT NULL,
        medidas TEXT DEFAULT '{}',
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES $usersTable (id) ON DELETE CASCADE
      )
    ''');

    // Insert default exercises
    await _insertDefaultExercises(db);
  }

  // Handle database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database schema upgrades here
    // For now, we'll drop and recreate all tables
    await db.execute('DROP TABLE IF EXISTS $progressTable');
    await db.execute('DROP TABLE IF EXISTS $workoutExercisesTable');
    await db.execute('DROP TABLE IF EXISTS $workoutsTable');
    await db.execute('DROP TABLE IF EXISTS $exercisesTable');
    await db.execute('DROP TABLE IF EXISTS $usersTable');
    
    await _onCreate(db, newVersion);
  }

  // Insert default exercises
  Future<void> _insertDefaultExercises(Database db) async {
    final List<Map<String, dynamic>> defaultExercises = [
      // Pecho
      {'nombre': 'Press de banca', 'grupo_muscular': 'pecho', 'nivel_dificultad': 'intermedio'},
      {'nombre': 'Flexiones', 'grupo_muscular': 'pecho', 'nivel_dificultad': 'principiante'},
      {'nombre': 'Press inclinado', 'grupo_muscular': 'pecho', 'nivel_dificultad': 'intermedio'},
      
      // Espalda
      {'nombre': 'Dominadas', 'grupo_muscular': 'espalda', 'nivel_dificultad': 'avanzado'},
      {'nombre': 'Remo con barra', 'grupo_muscular': 'espalda', 'nivel_dificultad': 'intermedio'},
      {'nombre': 'Jalones al pecho', 'grupo_muscular': 'espalda', 'nivel_dificultad': 'principiante'},
      
      // Piernas
      {'nombre': 'Sentadillas', 'grupo_muscular': 'piernas', 'nivel_dificultad': 'principiante'},
      {'nombre': 'Peso muerto', 'grupo_muscular': 'piernas', 'nivel_dificultad': 'avanzado'},
      {'nombre': 'Prensa de piernas', 'grupo_muscular': 'piernas', 'nivel_dificultad': 'intermedio'},
      
      // Brazos
      {'nombre': 'Curl de bíceps', 'grupo_muscular': 'brazos', 'nivel_dificultad': 'principiante'},
      {'nombre': 'Press francés', 'grupo_muscular': 'brazos', 'nivel_dificultad': 'intermedio'},
      {'nombre': 'Dips', 'grupo_muscular': 'brazos', 'nivel_dificultad': 'intermedio'},
      
      // Hombros
      {'nombre': 'Press militar', 'grupo_muscular': 'hombros', 'nivel_dificultad': 'intermedio'},
      {'nombre': 'Elevaciones laterales', 'grupo_muscular': 'hombros', 'nivel_dificultad': 'principiante'},
      
      // Abdomen
      {'nombre': 'Crunches', 'grupo_muscular': 'abdomen', 'nivel_dificultad': 'principiante'},
      {'nombre': 'Plancha', 'grupo_muscular': 'abdomen', 'nivel_dificultad': 'intermedio'},
      
      // Cardio
      {'nombre': 'Cinta de correr', 'grupo_muscular': 'cardio', 'nivel_dificultad': 'principiante'},
      {'nombre': 'Bicicleta estática', 'grupo_muscular': 'cardio', 'nivel_dificultad': 'principiante'},
      {'nombre': 'Elíptica', 'grupo_muscular': 'cardio', 'nivel_dificultad': 'principiante'},
    ];

    for (final exercise in defaultExercises) {
      await db.insert(exercisesTable, exercise);
    }
  }

  // Create default user if none exists
  Future<void> ensureDefaultUser() async {
    final db = await database;
    final users = await db.query(usersTable, limit: 1);
    
    if (users.isEmpty) {
      await db.insert(usersTable, {
        'nombre': 'Usuario',
        'email': 'usuario@fitness.com',
        'edad': 25,
        'peso_inicial': 70.0,
      });
    }
  }

  // Close database
  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}