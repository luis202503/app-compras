import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('compras.db');
    return _database!;
  }

  //codigo final para el proyecto, no borra la base de datos.
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  //para borrar base de datos
  /*Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    await deleteDatabase(path);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }*/

  /*Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE compra(
        id_compra INTEGER PRIMARY KEY AUTOINCREMENT,
        fecha TEXT NOT NULL DEFAULT CURRENT_DATE,
        
        descripcion_compra TEXT NOT NULL,
        //vendedor TEXT NOT NULL,
        vendedor TEXT NOT NULL CHECK(vendedor IN ('COMIDA','LIMPIEZA'))
        costo REAL NOT NULL,
        estado_pago TEXT NOT NULL CHECK(estado_pago IN ('PENDIENTE','PAGADO'))
      )
    ''');
  }*/

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE compra(
      id_compra INTEGER PRIMARY KEY AUTOINCREMENT,
      fecha TEXT NOT NULL DEFAULT CURRENT_DATE,
      descripcion_compra TEXT NOT NULL,
      vendedor TEXT NOT NULL CHECK(vendedor IN ('CAMIONETA ROJA','AUTO PLOMO')),
      costo REAL NOT NULL,
      estado_pago TEXT NOT NULL CHECK(estado_pago IN ('PENDIENTE','PAGADO'))
    )
  ''');
  }

  //insertar un trabajo
  Future<int> insertarCompra(Map<String, dynamic> compra) async {
    final db = await instance.database;

    return await db.insert('compra', compra);
  }

  //lista todos los trabajos
  Future<List<Map<String, dynamic>>> obtenerCompras() async {
    final db = await instance.database;

    return await db.query('compra', orderBy: 'fecha DESC, id_compra DESC');
  }

  //listar por pendientes
  Future<List<Map<String, dynamic>>> obtenerPendientes() async {
    final db = await database;

    return await db.query(
      'compra',
      where: 'estado_pago = ?',
      whereArgs: ['PENDIENTE'],
      orderBy: 'fecha DESC',
    );
  }

  //listar por pagados
  Future<List<Map<String, dynamic>>> obtenerPagados() async {
    final db = await database;

    return await db.query(
      'compra',
      where: 'estado_pago = ?',
      whereArgs: ['PAGADO'],
      orderBy: 'fecha DESC',
    );
  }

  /*//listar por placa
  Future<List<Map<String, dynamic>>> buscarPorPlaca(String placa) async {
    final db = await database;

    return await db.query(
      'compra',
      where: 'placa_moto LIKE ?',
      whereArgs: ['%$placa%'],
    );
  }*/

  Future<List<Map<String, dynamic>>> buscarPorIdCompra(int idCompra) async {
    final db = await database;

    return await db.query(
      'compra',
      where: 'id_compra = ?',
      whereArgs: [idCompra],
    );
  }

  // cambiar estado de pago
  Future actualizarEstadoPago(int idCompra, String nuevoEstado) async {
    final db = await database;

    await db.update(
      'compra',
      {'estado_pago': nuevoEstado},
      where: 'id_compra = ?',
      whereArgs: [idCompra],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
