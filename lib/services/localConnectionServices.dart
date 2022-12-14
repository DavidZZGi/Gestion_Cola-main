

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:line_management/model/Product.dart';
import 'package:line_management/model/client.dart';
import 'package:line_management/model/line.dart';
import 'package:line_management/model/municipio.dart';
import 'package:line_management/model/shop.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
class ConnectionServices {
  Database? _db;
  Database ? _dbcargada;
 // final String dbName;

  //ConnectionServices({required this.dbName});
/*
  Future<bool> open() async {
    WidgetsFlutterBinding.ensureInitialized();
    if (_db != null) {
      return true;
    }
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$dbName';
    try {
      _db = await openDatabase(path);

      await crearBD(_db!);

      return true;
    } catch (e) {
      print('$e');
      return false;
    }
  }
*/

Future<void>cargarBD()async{
var dbDir=await getDatabasesPath();
var dbPath=join(dbDir,'app.db');
await deleteDatabase(dbPath);
ByteData data =await rootBundle.load("assets/ColaSqlite.db");
List<int>bytes=data.buffer.asInt8List(data.offsetInBytes,data.lengthInBytes);
await File(dbPath).writeAsBytes(bytes);
_dbcargada=await openDatabase(dbPath);

}

/*
static Future<Database> getConennection()async{
WidgetsFlutterBinding.ensureInitialized();
// Open the database and store the reference.
final database = openDatabase(
  
  join(await getDatabasesPath(), 'ColaSqlite.db'),
  version: 1,
  onCreate: (db, version) {
    return crearBD(db);
           
   
  },
 
);
return database;
}
*/
  Future<void> crearBD(Database db) async {
    await db.execute(
        'CREATE TABLE IF NOT EXISTS "cliente" ("ci"	TEXT,"nombre"	TEXT,"apellidos"	TEXT,"id_cliente"	INTEGER,PRIMARY KEY("id_cliente" AUTOINCREMENT))');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS "cola" ("id"	INTEGER,"id_producto"	TEXT,"carnet_identidad"	INTEGER,"fecha"	TEXT,"id_municipio"	INTEGER,"id_tienda"	INTEGER,PRIMARY KEY("id" AUTOINCREMENT))');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS "municipio" ("id"	INTEGER,"nombre"	TEXT,"id_provincia"	INTEGER,"poblacion"	INTEGER,"nombre_corto"	TEXT,PRIMARY KEY("id" AUTOINCREMENT));');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS "tienda" ("id"	INTEGER,"nombre"	TEXT,"id_municipio"	INTEGER,"activa"	TEXT,PRIMARY KEY("id" AUTOINCREMENT));');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS "producto" ("id"	INTEGER,"nombre"	TEXT,"id_tipo"	INTEGER,PRIMARY KEY("id" AUTOINCREMENT));');
  }

  Future<int> insertClient(Cliente cliente) async {
   
    if (_dbcargada != null) {
      var res = await _dbcargada!.rawInsert(
          "INSERT Into cliente (ci,nombre,apellidos)"
          " VALUES (${cliente.carnetIdentidad},${cliente.nombre},${cliente.apellidos})");
      return res;
    } else
      return 0;
  }

  Future<void> insertarCliente(Cliente cliente) async {
   
    if (_dbcargada != null) {
      await _dbcargada!.insert('cliente', cliente.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
      print('insertado');
    }
  }

  Future<void> insertLine(Line line) async {
    DateTime fecha = DateTime.now();
    List<int> idClientes =
        line.clients.map((e) => e.carnetIdentidad).toList() as List<int>;
    //List<int> idProductos = line.products.map((e) => e.id).toList();
    if (_dbcargada != null) {
      Database database = _dbcargada!;
      for (var i = 0; i < idClientes.length; i++) {
        
          await database.rawInsert(
              'INSERT INTO cola(id_producto,carnet_identidad,fecha,id_municipio,id_tienda) VALUES(${line.idproducts},${idClientes[i]},${fecha.toString()},${line.idMun},${line.idTienda}) ');
        
      }
    }
  }

  Future<void> deleteLine(int id) async {
    if (_db != null) {
      Database database = _db!;
      database.delete(
        'cola',
        where: 'id=?',
        whereArgs: [id],
      );
    }
  }

  Future<List<Line>> getLines() async {
    // Get a reference to the database.
    if (_db != null) {
      final db = _db!;

      // Query the table for all The Dogs.
      final List<Map<String, dynamic>> maps =
          await db.query('cola', distinct: true);

      // Convert the List<Map<String, dynamic> into a List<Dog>.
      return List.generate(maps.length, (i) {
        List<Cliente> clientes =
            getClientesDadoId(maps[i]['id_cliente']) as List<Cliente>;
        List<Product> productos =
            getProductoDadoId(maps[i]['id_producto']) as List<Product>;
        return Line(
          clients: clientes,
          idproducts: maps[i]['id_producto'],
          idLine: maps[i]['id'],
          idMun: maps[i]['id_municipio'],
          idTienda: maps[i]['id_tienda'],
          date: maps[i]['fecha'],
        );
      });
    } else {
      return [];
    }
  }

  Future<List<Cliente>> getClientesDadoId(String ci) async {
    if (_db != null) {
      final db = _db!;
      final List<Map<String, dynamic>> clientes = await db.query('cliente',
          where: 'carnet_identidad=?', whereArgs: [ci], distinct: true);
      return List.generate(clientes.length, (i) {
        return Cliente(
            // idCliente: clientes[i]['id_cliente'],
            apellidos: clientes[i]['apellidos'],
            carnetIdentidad: clientes[i]['ci'],
            nombre: clientes[i]['nombre']);
      });
    } else
      return [];
  }

  Future<List<Cliente>> getClientes() async {
    if (_dbcargada != null) {
      final db = _dbcargada!;
      final List<Map<String, dynamic>> clientes =
          await _dbcargada!.query('cliente', distinct: true);
      return List.generate(clientes.length, (i) {
        print(clientes[i]);
        return Cliente(
            // idCliente: clientes[i]['id_cliente'],
            apellidos: clientes[i]['apellidos'],
            carnetIdentidad: clientes[i]['ci'],
            nombre: clientes[i]['nombre']);
      });
    } else
      return [];
  }

  Future<List<Product>> getProductoDadoId(int id) async {
    final db = _db!;
    final List<Map<String, dynamic>> productos = await db.query('producto',
        where: 'id=?', whereArgs: [id], distinct: true);
    return List.generate(productos.length, (i) {
      return Product(
          productName: productos[i]['nombre'],
          id: productos[i]['id'],
          idTipo: productos[i]['id_tipo']);
    });
  }

  Future<List<Shop>> getTiendaDadoMun(int idMun) async {
   if(_dbcargada!=null){
    
    final List<Map<String, dynamic>> shops = await _dbcargada!.query('tienda',
        where: 'id_municipio=?', whereArgs: [idMun], distinct: true);
    return List.generate(shops.length, (i) {
      return Shop(
          name: shops[i]['nombre'],
          id: shops[i]['id'],
          activa: shops[i]['activa'],
          idMunicipio: shops[i]['id_municipio']);
    });
    }
    
    else
    return [];
  }

  Future<void> deleteCliente(String ci) async {
    if (_db != null) {
      Database database = _db!;
      database.delete(
        'cliente',
        where: 'ci=?',
        whereArgs: [ci],
      );
    }
  }

Future<List<Product>>getAllProductos()async{
  if(_dbcargada!=null){
    final List<Map<String, dynamic>> maps = await _dbcargada!.query('producto');
    return List.generate(maps.length, (i) {
    return Product(
      id: maps[i]['id'],
      idTipo: maps[i]['id_tipo'],
      productName: maps[i]['nombre'],
    );
  });
  }
  else 
  return [];
}

Future<List<Municipio>>getAllMun()async{
  if(_dbcargada!=null){
    final List<Map<String, dynamic>> maps = await _dbcargada!.query('municipio');
    return List.generate(maps.length, (i) {
    return Municipio(
      idMunicipio: maps[i]['id'],
      nombre: maps[i]['nombre'],
      nombreCorto: maps[i]['nombre_corto'],
       poblacion: maps[i]['poblacion'],
       idProvincia: maps[i]['id_provincia']


    );
  });
  }
  else 
  return [];
}

Future<List<Shop>>getAllShops()async{
  if(_dbcargada!=null){
    final List<Map<String, dynamic>> maps = await _dbcargada!.query('tienda',distinct: true);
    return List.generate(maps.length, (i) {
    return Shop(
      idMunicipio: maps[i]['id_municipio'],
      id: maps[i]['id'],
      name: maps[i]['nombre'],
       activa: maps[i]['activa'],
      


    );
  });
  }
  else 
  return [];
}




}


