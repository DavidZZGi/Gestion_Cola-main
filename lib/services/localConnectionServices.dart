import 'dart:io';

import 'package:flutter/services.dart';
import 'package:line_management/model/Product.dart';
import 'package:line_management/model/client.dart';
import 'package:line_management/model/estados.dart';
import 'package:line_management/model/line.dart';
import 'package:line_management/model/municipio.dart';
import 'package:line_management/model/shop.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

import '../model/ClienteValidator.dart';
import '../model/cliente-cola-historico.dart';
import '../model/cliente-colas-activas.dart';
import '../model/colas-activas.dart';
import '../model/estados.dart';
import '../model/productos-colas.dart';

class ConnectionServices {
  Database? _db;
  Database? _dbcargada;
  final String dbName = 'CleanDB';

  //ConnectionServices({required this.dbName});

  Future<bool> open() async {
    WidgetsFlutterBinding.ensureInitialized();
    if (_db != null) {
      return true;
    }
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$dbName';
    print(path);
    try {
      _db = await openDatabase(path);

      await crearBD(_db!);
      insertarEstados(_db!);

      return true;
    } catch (e) {
      print('$e');
      return false;
    }
  }

  Future<void> cargarBD() async {
    var dbDir = await getDatabasesPath();
    var dbPath = join(dbDir, 'app.db');
    await deleteDatabase(dbPath);
    ByteData data = await rootBundle.load("assets/Real_Cola.db");
    List<int> bytes =
        data.buffer.asInt8List(data.offsetInBytes, data.lengthInBytes);
    await File(dbPath).writeAsBytes(bytes);
    _dbcargada = await openDatabase(dbPath);
  }

  Future<void> updateBDCargada(path) async {
    _dbcargada = await openDatabase(path);
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
    /*await db.execute(
        'CREATE TABLE IF NOT EXISTS "cliente" ("ci"	TEXT,"nombre"	TEXT,"apellidos"	TEXT,"idEstado"	INTEGER,"id_cliente"	INTEGER,PRIMARY KEY("id_cliente" AUTOINCREMENT))');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS "cola" ("id"	INTEGER,"id_producto"	TEXT,"carnet_identidad"	INTEGER,"fecha"	TEXT,"id_municipio"	INTEGER,"id_tienda"	INTEGER)');
        */
    await db.execute(
        'CREATE TABLE IF NOT EXISTS "municipio" ("id"	INTEGER,"nombre"	TEXT,"id_provincia"	INTEGER,PRIMARY KEY("id" AUTOINCREMENT));');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS "tienda" ("id"	INTEGER,"nombre"	TEXT,"id_municipio"	INTEGER,"activa"	TEXT,PRIMARY KEY("id" AUTOINCREMENT));');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS "producto" ("id"	INTEGER,"nombre"	TEXT,"id_tipo"	INTEGER,PRIMARY KEY("id" AUTOINCREMENT));');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS "estados_personas" ("id"	INTEGER,"nombre" TEXT);');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS "clientes_colas_activas" ("ci"	NVARCHAR(11) NOT NULL,"fv"	NVARCHAR(9),"nombre"	NVARCHAR(50) ,"id_municipio"	INTEGER NOT NULL DEFAULT 0,"fecha_registro"	DATETIME NOT NULL,"fecha_modif"	DATETIME,"id_estado"	INTEGER NOT NULL DEFAULT 1,"id_cola"	INTEGER NOT NULL,PRIMARY KEY("ci","id_cola"));');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS "productos_colas" ("id_cola" INTEGER NOT NULL,"id_producto" INTEGER NOT NULL,PRIMARY KEY("id_cola","id_producto"));');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS "colas_activas" ("id"	INTEGER NOT NULL UNIQUE,"tienda" INTEGER NOT NULL,"fecha"	DATETIME NOT NULL,PRIMARY KEY("id"));');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS "configuracion" ("fecha_nueva_cola"	DATE,"id_nueva_cola"	INTEGER,"subcola_actual"	INTEGER DEFAULT 0,"mensaje_inicial"	NVARCHAR(250),"CI_usuario"	NVARCHAR(11),"Nombre_usuario"	NVARCHAR(50),"telefono_usuario"	NVARCHAR(8),"id_tienda"	INTEGER);');
  }

  //CRUD Clientes-Colas-ACtivas
  Future<void> insertClienteColaActiva(ClienteColasActivas cliente) async {
    if (_db != null) {
      await _db!.insert('clientes_colas_activas', cliente.toMap());
    }
  }

  Future<void> insertAllClienteColaActiva(
      List<ClienteColasActivas> clientes) async {
    for (var element in clientes) {
      insertClienteColaActiva(element);
    }
  }

  //Get colas Historicas
  Future<List<ClienteColasHistorico>> getAllClientesColasHistoricas() async {
    if (_dbcargada != null) {
      final List<Map<String, dynamic>> colasActivas =
          await _dbcargada!.rawQuery('SELECT * FROM clientes_colas_historicas');
      return List.generate(colasActivas.length, (i) {
        print(colasActivas[i]);
        return ClienteColasHistorico(
            idCola: colasActivas[i]['id_cola'],
            ci: colasActivas[i]['ci'],
            idMensaje: colasActivas[i]['id_mensaje'],
            idEstado: colasActivas[i]['id_estado']);
      });
    } else
      return [];
  }

/*
  Future<List<ClienteColasActivas>> getAllClientesColasActivas() async {
    if (_db != null) {
      final List<Map<String, dynamic>> colasActivas =
          await _db!.query('clientes-colas-activas', distinct: true);
      return List.generate(colasActivas.length, (i) {
        print(colasActivas[i]);
        return ClienteColasActivas(
            id: colasActivas[i]['id'],
            fecha: colasActivas[i]['fecha'],
            idTienda: colasActivas[i]['idTienda']);
      });
    } else
      return [];
  }
*/
  //Crud Colas-Activas
  Future<void> insertColaActiva(ColaActiva cola) async {
    if (_db != null) {
      await _db!.insert('colas_activas', cola.toMap());
    }
  }

  Future<void> insertAllColasActivas(List<ColaActiva> colasActivas) async {
    for (var element in colasActivas) {
      insertColaActiva(element);
    }
  }

  Future<List<ColaActiva>> getAllColasActivas() async {
    if (_db != null) {
      final List<Map<String, dynamic>> colasActivas =
          await _db!.query('colas_activas', distinct: true);
      return List.generate(colasActivas.length, (i) {
        print(colasActivas[i]);
        return ColaActiva(
            id: colasActivas[i]['id'],
            fecha: colasActivas[i]['fecha'],
            tienda: colasActivas[i]['idTienda']);
      });
    } else
      return [];
  }

//Crud Producto-colas
  Future<void> insertProductosCola(ProductosColas producto) async {
    if (_db != null) {
      await _db!.insert('productos_colas', producto.toMap());
    }
  }

  Future<void> insertAllProductosCola(
      List<ProductosColas> productosColas) async {
    for (var element in productosColas) {
      insertProductosCola(element);
    }
  }

  Future<List<ProductosColas>> getAllProductosColas() async {
    if (_dbcargada != null) {
      final List<Map<String, dynamic>> productosCola =
          await _db!.query('productos_colas', distinct: true);
      return List.generate(productosCola.length, (i) {
        print(productosCola[i]);
        return ProductosColas(
          id_cola: productosCola[i]['idCola'],
          id_producto: productosCola[i]['idProducto'],
        );
      });
    } else
      return [];
  }

  ///Servicio para devolver datos cuando se encuentra un cliente
  Future<List<ClienteValidator>> getAllValidatorData() async {
    if (_dbcargada != null) {
      final List<
          Map<String,
              dynamic>> productosCola = await _dbcargada!.rawQuery(
          'SELECT DISTINCT clientes_colas_historicas.id_estado, clientes_colas_historicas.ci, clientes_colas_historicas.id_cola, productos.nombre FROM clientes_colas_historicas INNER JOIN productos_colas INNER JOIN productos WHERE clientes_colas_historicas.id_cola=productos_colas.id_cola AND productos.id=productos_colas.id_producto');
      return List.generate(productosCola.length, (i) {
        print(productosCola[i]);
        return ClienteValidator(
            idCola: productosCola[i]['id_cola'],
            nombProducto: productosCola[i]['nombre'],
            idEstado: productosCola[i]['id_estado'],
            ci: productosCola[i]['ci']);
      });
    } else
      return [];
  }

  ///
  Future<String> getFecha() async {
    String fecha = '';
    if (_dbcargada != null) {
      final res = await _dbcargada!
          .query('configuracion', columns: ['fecha_nueva_cola']);
      fecha = res[0]['fecha_nueva_cola'].toString();
    }
    return fecha;
  }

  Future<void> insertarEstados(Database db) async {
    for (var element in Estados.estados) {
      await db.insert('estados_personas', element.toMap());
    }
  }

  Future<void> insertClient(Cliente cliente) async {
    if (_dbcargada != null) {
      await _dbcargada!.transaction((trans) async {
        return await trans.execute(
            'INSERT INTO cliente(ci,nombre,apellidos) VALUES(?,?,?)',
            [cliente.carnetIdentidad, cliente.nombre, cliente.apellidos]);
      });
    }
  }

//Insertar cliente en bd limpia
  Future<void> insertarClienteEnBDLimpia(Cliente cliente) async {
    if (_db != null) {
      await _db!.insert('cliente', cliente.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      print(cliente.toMap());
    }
  }

  Future<void> insertLine(Line line) async {
    DateTime fecha = DateTime.now();
    List<int> idClientes =
        line.clients.map((e) => e.carnetIdentidad).toList() as List<int>;
    List<String> idProductos = line.nomProducts;
    if (_db != null) {
      for (var i = 0; i < idProductos.length; i++) {
        for (var k = 0; k < idClientes.length; i++) {
          await _db!.rawInsert(
              'INSERT INTO cola(id_producto,carnet_identidad,fecha,id_municipio,id_tienda) VALUES(?,?,?,?,?)',
              [
                line.nomProducts[i],
                idClientes[k],
                fecha.toString(),
                line.idMun,
                line.idTienda
              ]);
        }
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

      final List<Map<String, dynamic>> maps =
          await db.query('cola', distinct: true);

      return List.generate(maps.length, (i) {
        List<Cliente> clientes =
            getClientesDadoId(maps[i]['id_cliente']) as List<Cliente>;
        List<Product> productos =
            getProductoDadoId(maps[i]['id_producto']) as List<Product>;
        return Line(
          id: maps[i]['id'],
          clients: clientes,
          nomProducts: maps[i]['id_producto'],
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
            nombre: clientes[i]['nombre'],
            idEstado: clientes[i]['idEstado']);
      });
    } else
      return [];
  }

  Future<List<Cliente>> getClientes() async {
    if (_db != null) {
      final List<Map<String, dynamic>> clientes =
          await _db!.query('cliente', distinct: true);
      return List.generate(clientes.length, (i) {
        print(clientes[i]);
        return Cliente(
            // idCliente: clientes[i]['id_cliente'],
            apellidos: clientes[i]['apellidos'],
            carnetIdentidad: clientes[i]['ci'],
            nombre: clientes[i]['nombre'],
            idEstado: clientes[i]['idEstado']);
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
    if (_dbcargada != null) {
      final List<Map<String, dynamic>> shops = await _dbcargada!.query(
          'tiendas',
          where: 'id_municipio=?',
          whereArgs: [idMun],
          distinct: true);
      return List.generate(shops.length, (i) {
        return Shop(
            name: shops[i]['nombre'],
            id: shops[i]['id'],
            activa: shops[i]['activa'],
            idMunicipio: shops[i]['id_municipio']);
      });
    } else
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

  Future<void> deleteClienteDadoId(int id) async {
    if (_db != null) {
      Database database = _db!;
      database.delete(
        'cliente',
        where: 'id_cliente=?',
        whereArgs: [id],
      );
    }
  }

  Future<List<Product>> getAllProductos() async {
    if (_dbcargada != null) {
      final List<Map<String, dynamic>> maps =
          await _dbcargada!.query('productos');
      return List.generate(maps.length, (i) {
        return Product(
          id: maps[i]['id'],
          idTipo: maps[i]['id_tipo'],
          productName: maps[i]['nombre'],
        );
      });
    } else
      return [];
  }

  Future<List<Municipio>> getAllMun() async {
    if (_dbcargada != null) {
      final List<Map<String, dynamic>> maps =
          await _dbcargada!.query('municipios');
      return List.generate(maps.length, (i) {
        return Municipio(
            idMunicipio: maps[i]['id'],
            nombre: maps[i]['nombre'],
            idProvincia: maps[i]['id_provincia']);
      });
    } else
      return [];
  }

  Future<List<Shop>> getAllShops() async {
    if (_dbcargada != null) {
      final List<Map<String, dynamic>> maps =
          await _dbcargada!.query('tiendas', distinct: true);
      return List.generate(maps.length, (i) {
        return Shop(
          idMunicipio: maps[i]['id_municipio'],
          id: maps[i]['id'],
          name: maps[i]['nombre'],
          activa: maps[i]['activa'],
        );
      });
    } else
      return [];
  }
}
