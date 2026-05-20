import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/residuo.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _db;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB('ecoscan.db');
    return _db!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE residuos(
        id INTEGER PRIMARY KEY,
        nombre TEXT NOT NULL,
        categoria TEXT NOT NULL,
        contenedor TEXT NOT NULL,
        consejo TEXT
      )
    ''');
    
    await db.execute('''
      CREATE TABLE historial(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        residuo_id INTEGER,
        fecha INTEGER,
        FOREIGN KEY (residuo_id) REFERENCES residuos(id)
      )
    ''');

    final residuosIniciales = [
      Residuo(id: 1, nombre: 'botella plastico', categoria: 'plastico', contenedor: 'Amarillo', consejo: 'Enjuagar y aplastar'),
      Residuo(id: 2, nombre: 'lata aluminio', categoria: 'metal', contenedor: 'Amarillo', consejo: 'Enjuagar antes'),
      Residuo(id: 3, nombre: 'cascara platano', categoria: 'organico', contenedor: 'Marron', consejo: 'Ideal para compost'),
      Residuo(id: 4, nombre: 'pila boton', categoria: 'peligroso', contenedor: 'Punto limpio', consejo: 'NO tirar a basura comun'),
      Residuo(id: 5, nombre: 'frasco vidrio', categoria: 'vidrio', contenedor: 'Verde', consejo: 'Quitar tapas metalicas'),
      Residuo(id: 6, nombre: 'periodico', categoria: 'papel', contenedor: 'Azul', consejo: 'Doblar y atar'),
      Residuo(id: 7, nombre: 'caja carton', categoria: 'papel', contenedor: 'Azul', consejo: 'Desplegar y aplastar'),
      Residuo(id: 8, nombre: 'restos comida', categoria: 'organico', contenedor: 'Marron', consejo: 'Usar bolsa compostable'),
    ];
    
    for (var residuo in residuosIniciales) {
      await db.insert('residuos', residuo.toMap());
    }
  }

  Future<List<Residuo>> buscar(String query) async {
    final db = await database;
    final result = await db.query(
      'residuos',
      where: 'nombre LIKE ?',
      whereArgs: ['%$query%'],
    );
    return result.map((map) => Residuo.fromMap(map)).toList();
  }

  Future<void> guardarHistorial(int residuoId) async {
    final db = await database;
    await db.insert('historial', {
      'residuo_id': residuoId,
      'fecha': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<List<Map<String, dynamic>>> getHistorial() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT h.id, h.fecha, r.*
      FROM historial h
      JOIN residuos r ON h.residuo_id = r.id
      ORDER BY h.fecha DESC
    ''');
  }

  Future<int> getTotal() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as total FROM historial');
    return result.first['total'] as int;
  }

  Future<void> limpiarHistorial() async {
    final db = await database;
    await db.delete('historial');
  }
}