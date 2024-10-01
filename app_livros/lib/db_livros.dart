import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBLivros {
  static final DBLivros _instance = DBLivros._internal();
  static Database? _database;

  // Singleton pattern to ensure a single instance
  factory DBLivros() {
    return _instance;
  }

  DBLivros._internal();

  // Getter for the database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initializes the database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'books.db');
    return openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE books(id TEXT PRIMARY KEY, title TEXT, authors TEXT, description TEXT, thumbnail TEXT)",
        );
      },
      version: 1,
    );
  }

  // Inserts a book into the database
  Future<void> insertBook(Map<String, dynamic> book) async {
    final db = await database;
    await db.insert('books', book, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Retrieves all books from the database
  Future<List<Map<String, dynamic>>> getBooks() async {
    final db = await database;
    return await db.query('books');
  }

  // Deletes a book from the database by its ID
  Future<void> deleteBook(String id) async {
    final db = await database;
    await db.delete(
      'books',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
