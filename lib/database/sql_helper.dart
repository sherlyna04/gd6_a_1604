import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async{
    await database.execute("""
      CREATE TABLE employee(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      name TEXT,
      email TEXT
      )
    """);

    await database.execute("""
      CREATE TABLE store(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        alamat TEXT,
        tahun_dibuka TEXT
      )
    """);
  }

  static Future<sql.Database> db() async{
    return sql.openDatabase('employee_toko.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  static Future<int> addEmployee(String name, String email) async {
    final db = await SQLHelper.db();
    final data = {'name': name, 'email': email};
    return await db.insert('employee', data);
  }

  //read Employee
  static Future<List<Map<String, dynamic>>> getEmployee() async {
    final db = await SQLHelper.db();
    return db.query('employee');
  }

  static Future<int> editEmployee(int id, String name, String email) async {
    final db = await SQLHelper.db();
    final data = {'name': name, 'email': email};
    return await db.update('employee', data, where: "id = $id");
  }

//delete Employee
  static Future<int> deleteEmployee(int id) async {
    final db = await SQLHelper.db();
    return await db.delete('employee', where: "id = $id");
  }


  static Future<List<Map<String, dynamic>>> getToko() async {
    final db = await SQLHelper.db();
    return db.query('store');
  }

  static Future<int> addStore(String alamat, String tahunDibuka) async {
  final db = await SQLHelper.db();
  final data = {'alamat': alamat, 'tahun_dibuka': tahunDibuka}; // `tahun_dibuka` masih `int`
  return await db.insert('store', data);
  }

  static Future<int> editStore(int id, String alamat, String tahunDibuka) async {
    final db = await SQLHelper.db();
    final data = {'alamat': alamat, 'tahun_dibuka': tahunDibuka}; // `tahun_dibuka` masih `int`
    return await db.update('store', data, where: "id = $id");
  }

  static Future<int> deleteToko(int id) async {
    final db = await SQLHelper.db();
    return await db.delete('store', where: "id = $id");
  }
}