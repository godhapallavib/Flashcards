import 'package:flutter/foundation.dart';
import 'package:mp3/models/db_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper extends ChangeNotifier {
  Database? _database;
  final String titleTable = "title";
  final String flashTable = "flashcard";
  final String id = "fId";

  Future<void> initializeDatabase() async {
    _database ??= await openDatabase(
      join(await getDatabasesPath(), 'db1_project'),
      onCreate: (db, version) async {
        await db.execute(
            "CREATE TABLE $titleTable($id INTEGER PRIMARY KEY AUTOINCREMENT,title TEXT)");
        await db.execute(
            "CREATE TABLE $flashTable(id INTEGER PRIMARY KEY AUTOINCREMENT,question TEXT,answer TEXT,$id INTEGER,FOREIGN KEY ($id) REFERENCES $titleTable($id))");
      },
      version: 1,
    );
  }

  Future<int> addNewTitle(TitleModel title) async {
    await initializeDatabase();
    final Database db = _database!;
    return await db.insert(titleTable, title.toJson());
  }

  Future<int> addNewFlashcard(FlashcardData flashcard) async {
    await initializeDatabase();
    final Database db = _database!;
    final flashcardMap = flashcard.toJson();
    notifyListeners();
    return await db.insert(flashTable, flashcardMap);
  }

  Future<List<TitleModel>> fetchTitles() async {
    await initializeDatabase();
    final Database db = _database!;
    final List<Map<String, dynamic>> maps = await db.query(titleTable);
    return List.generate(maps.length, (i) {
      return TitleModel(fId: maps[i][id], title: maps[i]['title']);
    });
  }

  Future<List<FlashcardData>> fetchFlashcards(
      int flashId, String sortBy) async {
    await initializeDatabase();
    final Database db = _database!;
    final List<Map<String, dynamic>> maps = await db.query(
      flashTable,
      where: '$id = ?',
      whereArgs: [flashId],
      orderBy: sortBy,
    );
    return List.generate(maps.length, (i) {
      return FlashcardData(
        id: maps[i]['id'],
        question: maps[i]['question'],
        answer: maps[i]['answer'],
      );
    });
  }

  Future<int> alterTitle(TitleModel title) async {
    await initializeDatabase();
    final Database db = _database!;
    return await db.update(
      titleTable,
      title.toJson(),
      where: '$id = ?',
      whereArgs: [title.fId],
    );
  }

  Future<int> alterFlashCard(FlashcardData flashcard) async {
    await initializeDatabase();
    final Database db = _database!;
    return await db.update(
      flashTable,
      {
        "question": flashcard.question.toString(),
        "answer": flashcard.answer.toString(),
      },
      where: 'id = ?',
      whereArgs: [flashcard.id],
    );
  }

  Future<int> removeFlashCard(int id) async {
    await initializeDatabase();
    final Database db = _database!;
    return await db.delete(
      flashTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> removeTitle(int fid) async {
    await initializeDatabase();
    final Database db = _database!;
    return await db.delete(
      titleTable,
      where: '$id = ?',
      whereArgs: [fid],
    );
  }
}
