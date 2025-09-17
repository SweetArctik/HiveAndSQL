import 'database_helper.dart';
import 'hive_helper.dart';

class AppInitializer {
  static Future<void> initialize() async {
    // Initialize Hive first
    await HiveHelper.instance.initHive();
    
    // Initialize SQLite database and create default user
    await DatabaseHelper.instance.ensureDefaultUser();
    
    print('App initialized successfully!');
  }
  
  static Future<void> dispose() async {
    await HiveHelper.instance.closeAll();
    await DatabaseHelper.instance.close();
  }
}