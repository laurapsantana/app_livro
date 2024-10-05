import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBLivros {
  static final DBLivros _instance = DBLivros._internal();
  static Database? _database;

  // Construtor de fábrica para retornar a instância
  factory DBLivros() {
    return _instance;
  }

  DBLivros._internal();

  // Getter para a instância do banco de dados
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  // Inicializa o banco de dados
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'books.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE books ("
              "id TEXT PRIMARY KEY, "
              "title TEXT, "
              "authors TEXT, "
              "description TEXT, "
              "thumbnail TEXT"
              ")",
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // Lida com a migração do banco de dados, se necessário
        if (oldVersion < newVersion) {
        }
      },
    );
  }

  // Insere o livro no banco de dados
  Future<void> insertBook(Map<String, dynamic> book) async {
    final db = await database;
    try {
      await db.insert(
        'books',
        book,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error inserting book: $e');
    }
  }

  // Recupera todos os livros do banco de dados
  Future<List<Map<String, dynamic>>> getBooks() async {
    final db = await database;
    return await db.query('books');
  }

  // Deleta um livro do banco de dados pelo seu ID
  Future<void> deleteBook(String id) async {
    final db = await database;
    await db.delete(
      'books',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Verifica se o livro existe no banco de dados
  Future<bool> bookExists(String id) async {
    final db = await database;
    final result = await db.query(
      'books',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty;
  }

  // Fecha o banco de dados
  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
  }
}
