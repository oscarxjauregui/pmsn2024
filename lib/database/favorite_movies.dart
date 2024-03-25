import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pmsn2024/model/popular_model.dart';
import 'package:sqflite_common/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';

class MovieBD {
  static const nameDB = 'MOVIESBD';
  static const versionBD = 1;

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database!;
    return _database = await _initDatabases();
  }

  Future<Database?> _initDatabases() async {
    Directory folder = await getApplicationDocumentsDirectory();
    String pathBD = join(folder.path, nameDB);

    return openDatabase(pathBD,
        version: versionBD.bitLength, onCreate: _createtable);
  }

  FutureOr<void> _createtable(Database db, int version) {
    String query = ''' CREATE TABLE tblMovies(
      idmovie INTEGER PRIMARY KEY,
      validar INTEGER
      ); ''';
    db.execute(query);
  }

  Future<int> INSERT(String tblName, Map<String, dynamic> data) async {
    var conexion = await database;
    return conexion!.insert(tblName, data);
    // print(data);
    // print(tblName);
    // return 1;
  }

  Future<int> DELETE(String tblName, int id) async {
    var conexion = await database;
    return conexion!.delete(tblName, where: 'idmovie = ?', whereArgs: [id]);
    // print(id);
    // return 1;
  }

  Future<List<PopularModel>> ListarPeliculas2() async {
    var conexion = await database;
    var result = await conexion!.query('tblMovies');
    return result.map((task) => PopularModel.fromMap(task)).toList();
  }

  Future<List<int>> ListarPeliculas() async {
    var conexion = await database;
    var result = await conexion!.query('tblMovies');
    return result.map((task) => task['idmovie'] as int).toList();
  }
}
