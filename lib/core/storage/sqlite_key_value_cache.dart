import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Cache key-value en SQLite para payloads que deben sobrevivir reinicios.
///
/// Frente a SharedPreferences, resulta mas adecuado para blobs de texto grandes
/// (por ejemplo respuestas de API serializadas).
class SqliteKeyValueCache {
  static const _dbName = 'products_cache.db';
  static const _tableName = 'cache_entries';

  Database? _database;

  Future<Database> get _db async {
    if (_database != null) {
      return _database!;
    }

    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, _dbName);

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // `updated_at` permite estrategias futuras de invalidacion/TTL.
        await db.execute('''
          CREATE TABLE $_tableName(
            key TEXT PRIMARY KEY,
            value TEXT NOT NULL,
            updated_at INTEGER NOT NULL
          )
        ''');
      },
    );

    return _database!;
  }

  Future<void> writeString(String key, String value) async {
    final db = await _db;
    // Semantica upsert para mantener una unica fila por clave.
    await db.insert(_tableName, {
      'key': key,
      'value': value,
      'updated_at': DateTime.now().millisecondsSinceEpoch,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<String?> readString(String key) async {
    final db = await _db;
    final rows = await db.query(
      _tableName,
      columns: ['value'],
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );

    if (rows.isEmpty) {
      return null;
    }

    return rows.first['value'] as String?;
  }

  Future<void> delete(String key) async {
    final db = await _db;
    await db.delete(_tableName, where: 'key = ?', whereArgs: [key]);
  }
}
