import 'package:floor/floor.dart';
import 'package:tritek_lms/appTheme/appTheme.dart';
import 'package:tritek_lms/database/database.dart';

class AppDB {
  Future<AppDatabase> getDatabase() async {
    // create migration
    final migration4to5 = Migration(4, 5, (database) async {
      await database.execute('ALTER TABLE notes ADD COLUMN synced INTEGER');
    });

    return await $FloorAppDatabase
        .databaseBuilder(appDB)
        .addMigrations([migration4to5]).build();
  }
}
