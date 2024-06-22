import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database? _database;

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
    String path = join(databasesPath, 'ControlPrenatalDB.db');

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute('''
      CREATE TABLE Usuarios (
        ID_Usuario INTEGER PRIMARY KEY AUTOINCREMENT,
        Nombre TEXT NOT NULL,
        Fecha_Nacimiento TEXT NOT NULL,
        Primer_Embarazo INTEGER NOT NULL,
        Numero_Embarazo INTEGER NOT NULL
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
        FOREIGN KEY (ID_Usuario) REFERENCES Usuarios (ID_Usuario)
      )
    ''');
    
    await db.execute('''
      CREATE TABLE Hospitales (
        ID_Hospital INTEGER PRIMARY KEY AUTOINCREMENT,
        Nombre_Hospital TEXT NOT NULL,
        Direccion TEXT,
        Telefono TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE Examenes_Laboratorio (
        ID_Examen INTEGER PRIMARY KEY AUTOINCREMENT,
        Nombre_Examen TEXT NOT NULL,
        Descripcion TEXT,
        Semana_Asignada INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE Archivos (
        ID_Archivo INTEGER PRIMARY KEY AUTOINCREMENT,
        ID_Usuario INTEGER NOT NULL,
        Semana INTEGER NOT NULL,
        Tipo_Archivo TEXT,
        Ruta_Archivo TEXT,
        FOREIGN KEY (ID_Usuario) REFERENCES Usuarios (ID_Usuario)
      )
    ''');

    await db.execute('''
      CREATE TABLE Usuarios_Hospitales (
        ID_Usuario INTEGER NOT NULL,
        ID_Hospital INTEGER NOT NULL,
        PRIMARY KEY (ID_Usuario, ID_Hospital),
        FOREIGN KEY (ID_Usuario) REFERENCES Usuarios (ID_Usuario),
        FOREIGN KEY (ID_Hospital) REFERENCES Hospitales (ID_Hospital)
      )
    ''');
  }

  // Métodos para CRUD en Usuarios
  Future<int> insertUsuario(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('Usuarios', row);
  }

  Future<List<Map<String, dynamic>>> queryAllUsuarios() async {
    Database db = await database;
    return await db.query('Usuarios');
  }

  Future<int> updateUsuario(Map<String, dynamic> row) async {
    Database db = await database;
    int id = row['ID_Usuario'];
    return await db.update('Usuarios', row, where: 'ID_Usuario = ?', whereArgs: [id]);
  }

  Future<int> deleteUsuario(int id) async {
    Database db = await database;
    return await db.delete('Usuarios', where: 'ID_Usuario = ?', whereArgs: [id]);
  }

  // Métodos para CRUD en Controles_Prenatales
  Future<int> insertControlPrenatal(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('Controles_Prenatales', row);
  }

  Future<List<Map<String, dynamic>>> queryAllControlesPrenatales() async {
    Database db = await database;
    return await db.query('Controles_Prenatales');
  }

  Future<int> updateControlPrenatal(Map<String, dynamic> row) async {
    Database db = await database;
    int id = row['ID_Control'];
    return await db.update('Controles_Prenatales', row, where: 'ID_Control = ?', whereArgs: [id]);
  }

  Future<int> deleteControlPrenatal(int id) async {
    Database db = await database;
    return await db.delete('Controles_Prenatales', where: 'ID_Control = ?', whereArgs: [id]);
  }
}
