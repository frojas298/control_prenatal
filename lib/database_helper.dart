import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'prenatal_care.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Usuarios (
        ID_Usuario INTEGER PRIMARY KEY AUTOINCREMENT,
        Nombre TEXT NOT NULL,
        Fecha_Nacimiento TEXT NOT NULL,
        Primer_Embarazo INTEGER NOT NULL,
        Numero_Embarazo INTEGER,
        Password TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE Controles_Prenatales (
        ID_Control INTEGER PRIMARY KEY AUTOINCREMENT,
        ID_Usuario INTEGER NOT NULL,
        Semana INTEGER NOT NULL,
        Examenes_Clinicos TEXT,
        Visitas_Ginecologicas TEXT,
        IMC REAL,
        Talla REAL,
        FOREIGN KEY (ID_Usuario) REFERENCES Usuarios(ID_Usuario)
      )
    ''');
  }

  Future<void> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    await db.insert('Usuarios', user);
  }
  
  Future<void> insertControlPrenatal(Map<String, dynamic> control) async {
    final db = await database;
    await db.insert('Controles_Prenatales', control);
  }
  
  Future<List<Map<String, dynamic>>> queryAllControlesPrenatales() async {
    final db = await database;
    return await db.query('Controles_Prenatales');
  }

  Future<Map<String, dynamic>?> getUsuario(String nombre, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      'Usuarios',
      where: 'Nombre = ? AND Password = ?',
      whereArgs: [nombre, password],
    );
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }
}
