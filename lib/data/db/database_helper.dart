import 'package:restaurant_app_api/data/model/restaurant_list.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal() {
    _instance = this;
  }

  factory DatabaseHelper() => _instance ?? DatabaseHelper._internal();

  static const String _tblBookmark = 'bookmarks';

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      '$path/restaurantapp.db',
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $_tblBookmark (
            id TEXT PRIMARY KEY,
            name TEXT,
            description TEXT,
            pictureId TEXT,
            city TEXT,
            rating TEXT
          )
        ''');
      },
      version: 1,
    );

    return db;
  }

  Future<Database?> get database async {
    if (_database == null) {
      _database = await _initializeDb();
    }

    return _database;
  }

  Future<void> insertBookmark(Restaurant restaurant) async {
    final db = await database;
    await db!.insert(_tblBookmark, restaurant.toJson());
  }

  Future<List<Restaurant>> getBookmarks() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db!.query(_tblBookmark);

    return results.map((res) => Restaurant.fromJson(res)).toList();
  }

  Future<Map> getBookmarkById(String id) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db!.query(
      _tblBookmark,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return {};
    }
  }

  Future<void> removeBookmarks(String id) async {
    final db = await database;

    await db!.delete(
      _tblBookmark,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
