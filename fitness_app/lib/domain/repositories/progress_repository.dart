import '../entities/entities.dart';

abstract class ProgressRepository {
  // Progress CRUD
  Future<Progress> createProgress(Progress progress);
  Future<Progress?> getProgressById(int id);
  Future<List<Progress>> getUserProgress(int userId, {int? limit});
  Future<Progress?> getLatestProgress(int userId);
  Future<List<Progress>> getProgressByDateRange(int userId, DateTime start, DateTime end);
  Future<Progress> updateProgress(Progress progress);
  Future<void> deleteProgress(int id);

  // Analytics
  Future<List<Map<String, dynamic>>> getProgressChart(int userId, int days);
  Future<Map<String, dynamic>> getProgressSummary(int userId);
  
  // Helper Methods
  Future<double> calculateBMI(double weight, double height);
  Future<Progress> createProgressFromCurrentData(int userId, double weight, Map<String, double> measurements);
}