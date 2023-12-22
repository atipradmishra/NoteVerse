import 'package:noteverse/database/table_creation.dart';
import 'package:noteverse/database/taskmodel.dart';
import 'package:sqflite/sqflite.dart';
import 'connections.dart';


class Taskcurdmap {
  ConnectionSQLiteService _connection = ConnectionSQLiteService.instance;

  Future<Database> _getDatabase() async {
    return await _connection.db;
  }

  Future<Task> add(Task x) async {
    try {
      Database db = await _getDatabase();
      int Id = await db.rawInsert(TaskTableCreate.addtask(x));
      x.TaskId = Id;
      return x;
    } catch (x) {
      throw Exception();
    }
  }

  Future<bool> update(Task x) async {
    try {
      Database db = await _getDatabase();
      int affectedlines = await db.rawUpdate(TaskTableCreate.updatetask(x));
      if (affectedlines > 0) {
        return true;
      }
      return false;
    } catch (error) {
      throw Exception();
    }
  }

  Future<List<Task>> selectall() async {
    try {
      Database db = await _getDatabase();
      List<Map> data = await db.rawQuery(TaskTableCreate.selectall());
      List<Task> s = Task.fromSQLiteList(data);
      return s;
    } catch (error) {
      throw Exception();
    }
  }

Future<void> deleteItem(int id) async {
  final db = await _getDatabase(); // Get a reference to the database.
  await db.delete(
    'Task',
    where: 'TaskId = ?',
    whereArgs: [id],
  );
}

}