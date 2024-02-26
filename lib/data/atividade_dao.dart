import 'package:sqflite/sqflite.dart';
import 'package:atividade_rotas/components/atividades.dart';
import 'package:path/path.dart';

class AtividadeDao {

  static const String tableSql = 'CREATE TABLE $_tableName ($_id INTEGER PRIMARY KEY AUTOINCREMENT, $_name TEXT)';

  static const String _tableName = 'atividadeTable';
  static const String _id = 'id';
  static const String _name = 'name';

  static Future<Database> getDatabase() async {
    final String path = join(await getDatabasesPath(), 'atividade.db');
    return openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(tableSql);
      },
      version: 1,
    );
  }

  Future<int> save(Atividade atividade) async {
    final Database database = await getDatabase();
    return await database.insert(_tableName, toMap(atividade));
  }

  Map<String, dynamic> toMap(Atividade atividade) {
    return {
      //oque estava dando erro
      //_id: atividade.id
      _name: atividade.name,
    };
  }

  Future<List<Atividade>> findAll() async {
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> result = await database.query(_tableName);
    return toList(result);
  }

  List<Atividade> toList(List<Map<String, dynamic>> result) {
    return result.map((map) => Atividade(map[_id], map[_name])).toList();
  }

  Future<List<Atividade>> find(int idDaAtividade) async {
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> result = await database.query(
      _tableName,
      where: '$_id = ?',
      whereArgs: [idDaAtividade],
    );
    return toList(result);
  }

  Future<int> delete(int idDaAtividade) async {
    final Database database = await getDatabase();
    return await database.delete(
      _tableName,
      where: '$_id = ?',
      whereArgs: [idDaAtividade],
    );
  }

  Future<int> update(Atividade atividade) async {
    final Database database = await getDatabase();
    return await database.update(
      _tableName,
      toMap(atividade),
      where: '$_id = ?',
      whereArgs: [atividade.id],
    );
  }

  Future<int> updateName(int id, String newName) async {
    final Database database = await getDatabase();
    return await database.update(
      _tableName,
      {_name: newName},
      where: '$_id = ?',
      whereArgs: [id],
    );
  }
}