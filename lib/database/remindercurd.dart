import 'package:noteverse/database/remindermodel.dart';
import 'package:noteverse/database/table_creation.dart';
import 'package:sqflite/sqflite.dart';
import 'connections.dart';


class Remindercurdmap {
  ConnectionSQLiteService _connection = ConnectionSQLiteService.instance;

  Future<Database> _getDatabase() async {
    return await _connection.db;
  }

  Future<Reminder> add(Reminder x) async {
    try {
      Database db = await _getDatabase();
      int Id = await db.rawInsert(ReminderTableCreate.add(x));
      x.ReminderId = Id;
      return x;
    } catch (x) {
      throw Exception();
    }
  }

  Future<bool> update(Reminder x) async {
    try {
      Database db = await _getDatabase();
      int affectedlines = await db.rawUpdate(ReminderTableCreate.update(x));
      if (affectedlines > 0) {
        return true;
      }
      return false;
    } catch (error) {
      throw Exception();
    }
  }

  Future<List<Reminder>> selectall() async {
    try {
      Database db = await _getDatabase();
      List<Map> data = await db.rawQuery(ReminderTableCreate.selectall());
      List<Reminder> s = Reminder.fromSQLiteList(data);
      return s;
    } catch (error) {
      throw Exception();
    }
  }

  Future<void> deleteItem(int id) async {
    final db = await _getDatabase(); // Get a reference to the database.
    await db.delete(
      'Reminder',
      where: 'ReminderId = ?',
      whereArgs: [id],
    );
  }

}