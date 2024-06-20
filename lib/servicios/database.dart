import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart'; // Necesario para el uso de 'join'

// Inicia la preparación de la base de datos
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database? _database; // Cambia a null

  DatabaseHelper.internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDb();
    return _database!;
  }

  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db'); // Utiliza 'join' para manejar correctamente las rutas

    // Elimina la base de datos
    await deleteDatabase(path);

    // Abre la base de datos
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    // Crear la tabla
    await db.execute(
        'CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)');
  }
}
