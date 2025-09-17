import '../../domain/entities/entities.dart';
import '../../domain/repositories/progress_repository.dart';
import '../datasources/local_database_datasource.dart';
import '../datasources/hive_datasource.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  final LocalDatabaseDataSource _localDataSource;
  final HiveDataSource _hiveDataSource;

  ProgressRepositoryImpl({
    required LocalDatabaseDataSource localDataSource,
    required HiveDataSource hiveDataSource,
  })  : _localDataSource = localDataSource,
        _hiveDataSource = hiveDataSource;

  @override
  Future<Progress> createProgress(Progress progress) async {
    final id = await _localDataSource.createProgress(progress);
    final createdProgress = progress.copyWith(id: id);
    
    // Invalidate cache
    await _hiveDataSource.invalidateCache('progress');
    
    return createdProgress;
  }

  @override
  Future<Progress?> getProgressById(int id) async {
    return await _localDataSource.getProgressById(id);
  }

  @override
  Future<List<Progress>> getUserProgress(int userId, {int? limit}) async {
    return await _localDataSource.getProgressByUserId(userId, limit: limit);
  }

  @override
  Future<Progress?> getLatestProgress(int userId) async {
    return await _localDataSource.getLatestProgress(userId);
  }

  @override
  Future<List<Progress>> getProgressByDateRange(int userId, DateTime start, DateTime end) async {
    return await _localDataSource.getProgressByDateRange(userId, start, end);
  }

  @override
  Future<Progress> updateProgress(Progress progress) async {
    await _localDataSource.updateProgress(progress);
    await _hiveDataSource.invalidateCache('progress');
    return progress;
  }

  @override
  Future<void> deleteProgress(int id) async {
    await _localDataSource.deleteProgress(id);
    await _hiveDataSource.invalidateCache('progress');
  }

  @override
  Future<List<Map<String, dynamic>>> getProgressChart(int userId, int days) async {
    final endDate = DateTime.now();
    final startDate = endDate.subtract(Duration(days: days));
    
    final progressList = await _localDataSource.getProgressByDateRange(userId, startDate, endDate);
    
    return progressList.map((progress) => {
      'date': progress.fecha.toIso8601String().split('T')[0],
      'weight': progress.peso,
      'bmi': progress.imc,
    }).toList();
  }

  @override
  Future<Map<String, dynamic>> getProgressSummary(int userId) async {
    final latestProgress = await _localDataSource.getLatestProgress(userId);
    final allProgress = await _localDataSource.getProgressByUserId(userId);
    
    if (latestProgress == null || allProgress.isEmpty) {
      return {
        'latest_weight': 0.0,
        'latest_bmi': 0.0,
        'weight_change': 0.0,
        'total_records': 0,
      };
    }
    
    final firstProgress = allProgress.last; // Oldest record
    final weightChange = latestProgress.peso - firstProgress.peso;
    
    return {
      'latest_weight': latestProgress.peso,
      'latest_bmi': latestProgress.imc,
      'weight_change': weightChange,
      'total_records': allProgress.length,
    };
  }

  @override
  Future<double> calculateBMI(double weight, double height) async {
    // BMI = weight (kg) / height (m)^2
    return weight / (height * height);
  }

  @override
  Future<Progress> createProgressFromCurrentData(int userId, double weight, Map<String, double> measurements) async {
    // Assume height is stored in measurements or use a default
    double height = measurements['height'] ?? 1.75; // Default height in meters
    double bmi = await calculateBMI(weight, height);
    
    final progress = Progress(
      userId: userId,
      fecha: DateTime.now(),
      peso: weight,
      imc: bmi,
      medidas: measurements,
    );
    
    return await createProgress(progress);
  }
}