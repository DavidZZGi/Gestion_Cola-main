import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:line_management/provider/lineProvider.dart';
import 'package:line_management/provider/shopProvider.dart';

import '../model/productos-colas.dart';
import 'connectionProvider.dart';

class ProductosColasProvider with ChangeNotifier {
  List<ProductosColas> productosCola = [];

  Future<void> insertAllproductosCola() async {
    if (ConnectionProvider.isConnected) {
      await ConnectionProvider.connection.insertAllProductosCola(productosCola);
    }
    notifyListeners();
  }

  List<ProductosColas> develverProductosDadoIdCola(int idCola) {
    List<ProductosColas> productosDeUnaCola = [];
    for (var element in productosCola) {
      if (element.idCola == idCola) {
        productosDeUnaCola.add(element);
      }
    }
    return productosDeUnaCola;
  }
}
