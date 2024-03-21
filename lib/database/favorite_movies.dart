import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:pmsn2024/model/popular_model.dart';
import 'package:sqflite_common/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';

class FavoriteMoviesDatabase {
  static final nameDB = 'FAVORITEDB';
  static final versionDB = 2;

  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database!;
    return _database = await _initDatabase();
  }

  Future<Database?> _initDatabase() async {
    Directory folder = await getApplicationDocumentsDirectory();
    String pathDB = join(folder.path, nameDB);
    return openDatabase(pathDB, version: versionDB, onCreate: _createTables);
  }

Future<void> _createTables(Database db, int version) async{
    await db.execute('''CREATE TABLE tblFavoritas(
        id INTEGER,
        backdropPath TEXT,
        originalLanguage TEXT,
        originalTitle TEXT,
        overview TEXT,
        popularity REAL,
        posterPath TEXT,
        releaseDate TEXT,
        title TEXT,
        voteAverage REAL,
        voteCount INTEGER,
        isFavorite INTEGER
      );''');
  }

  Future<int> insertFavoriteMovie(PopularModel movie) async {
    var conexion = await database;
    return conexion!.insert('tblFavoritas', movie.toMap());
  }

  Future<int> updateFavoriteMovie(PopularModel movie) async {
    var conexion = await database;
    return conexion!.update(
      'tblFavoritas',
      movie.toMap(),
      where: 'id = ?',
      whereArgs: [movie.id],
    );
  }

  Future<int> deleteFavoriteMovie(int id) async {
    var conexion = await database;
    return conexion!.delete(
      'tblFavoritas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteallFavoriteMovie() async {
    var conexion = await database;
    return conexion!.delete('tblFavoritas');
  }



  Future<List<PopularModel>> getFavoriteMovies() async {
    var conexion = await database;
    var result = await conexion!.query('tblFavoritas', where: 'isFavorite = 1');
    return result.map((movie) => PopularModel.fromMap(movie)).toList();
  }
}
