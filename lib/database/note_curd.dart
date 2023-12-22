import 'package:noteverse/database/table_creation.dart';
import 'package:sqflite/sqflite.dart';
import 'connections.dart';
import 'notemodel.dart';


class Notecurdmap {
  ConnectionSQLiteService _connection = ConnectionSQLiteService.instance;

  Future<Database> _getDatabase() async {
    return await _connection.db;
  }

  Future<Note> add(Note x) async {
    try {
      Database db = await _getDatabase();
      int NoteId = await db.rawInsert(NoteTableCreate.addnote(x));
      x.NoteId= NoteId;
      return x;
    } catch (x) {
      throw Exception();
    }
  }

  Future<List<Note>> selectall() async {
    try {
      Database db = await _getDatabase();
      List<Map> data = await db.rawQuery(NoteTableCreate.selectallnotes());
      List<Note> s = Note.fromSQLiteList(data);
      return s;
    } catch (error) {
      throw Exception();
    }
  }

  Future<bool> update(Note x) async {
    try {
      Database db = await _getDatabase();
      int affectedlines = await db.rawUpdate(NoteTableCreate.updatenot(x));
      if (affectedlines > 0) {
        return true;
      }
      return false;
    } catch (error) {
      throw Exception();
    }
  }
  Future<bool> selectnotebyid(Note x) async {
    try {
      Database db = await _getDatabase();
      int affectedlines = await db.rawUpdate(NoteTableCreate.updatenot(x));
      if (affectedlines > 0) {
        return true;
      }
      return false;
    } catch (error) {
      throw Exception();
    }
  }
  Future<void> deleteItem(int id) async {
    final db = await _getDatabase(); // Get a reference to the database.
    await db.delete(
      'Note',
      where: 'NoteId = ?',
      whereArgs: [id],
    );
  }
}