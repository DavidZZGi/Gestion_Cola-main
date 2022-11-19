import 'package:flutter/cupertino.dart';
import 'package:line_management/model/Product.dart';
import 'package:line_management/model/municipio.dart';
import 'package:line_management/model/shop.dart';
import 'package:line_management/services/localConnectionServices.dart';

import '../model/client.dart';

class ConnectionProvider with ChangeNotifier {
  static ConnectionServices connection =
      ConnectionServices(); //(dbName: 'db.sqlite');
  List<Cliente> clientesDB = [];
  List<Product> products = [];
  List<Municipio> municipios = [];
  List<Shop> shops = [];
  List<Shop> shopMun = [];
  static bool isConnected = false;

  Future<void> getConnection() async {
    await connection.cargarBD();
    isConnected = true;
    notifyListeners();
  }

  Future<void> getConnectionBDLimpia() async {
    await connection.open();
    notifyListeners();
  }

/*
  Future<void> insertCliente(Cliente cliente) async {
    await connection.insertClient(cliente);
    notifyListeners();
  }

  Future<void> insertClienteEnBDLimpa(Cliente cliente) async {
    await connection.insertarClienteEnBDLimpia(cliente);
    notifyListeners();
  }

  Future<void> deleteCliente(String ci) async {
    await connection.deleteCliente(ci);
    notifyListeners();
  }

  Future<void> loadClientesFromDB() async {
    clientesDB = await connection.getClientes();

    notifyListeners();
  }
*/
  Future<List<Product>> getAllProducts() async {
    products = await connection.getAllProductos();
    notifyListeners();
    return products;
  }

  Future<List<Municipio>> getAllMunicipios() async {
    municipios = await connection.getAllMun();
    notifyListeners();
    return municipios;
  }

  Future<List<Shop>> getAllShops() async {
    shops = await connection.getAllShops();
    notifyListeners();
    return shops;
  }

  Future<List<Shop>> getAllShopFromMun(int idMun) async {
    shopMun = await connection.getTiendaDadoMun(idMun);
    notifyListeners();
    return shopMun;
  }

  int idNomShop(String nameShop) {
    for (var item in shops) {
      if (item.name == nameShop) {
        return item.id;
      }
    }
    return 0;
  }

  String nomShopId(int id) {
    for (var item in shops) {
      if (item.id == id) {
        return item.name;
      }
    }
    return '';
  }

  int idNomProduct(String nameProduct) {
    int id = 0;
    for (var item in products) {
      if (item.productName == nameProduct) {
        id = item.id;
      }
    }
    return id;
  }

  String nomProductdadoId(int id) {
    String result = '';
    for (var item in products) {
      if (item.id == id) {
        result = item.productName;
      }
    }
    return result;
  }
}
