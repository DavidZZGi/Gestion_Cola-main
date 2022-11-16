import 'package:flutter/cupertino.dart';
import 'package:line_management/provider/colasActivasProvider.dart';
import 'package:line_management/provider/connectionProvider.dart';
import 'package:line_management/provider/lineProvider.dart';
import 'package:line_management/provider/productProvider.dart';
import 'package:line_management/provider/productosColasProvider.dart';
import 'package:line_management/provider/shopProvider.dart';

import '../model/cliente-colas-activas.dart';
import '../model/colas-activas.dart';
import '../model/productos-colas.dart';

class GestionadorProvider with ChangeNotifier {
  List<ClienteColasActivas> clienteColas = [];
  ProductosColasProvider productosColasProvider = ProductosColasProvider();
  ColasActivasProvider colasActivasProvider = ColasActivasProvider();
  ProductProvider productProvider = ProductProvider();
  LineProvider lineProvider = LineProvider();

  String obtenerNombreTiendaYProductDeTiendaActia(int idCola) {
    List<ProductosColas> productos =
        productosColasProvider.develverProductosDadoIdCola(idCola);
    List<String> nombreProductos = [];
    for (var element in productos) {
      nombreProductos.add(productProvider.NomProductdadoId(element.idProducto));
    }

    String nombTienda = lineProvider.nomTienda;
    String result = nombTienda + '' + nombreProductos.toString();
    return result;
  }

  Future<void> getAllProductosCola() async {
    if (ConnectionProvider.isConnected) {
      await ConnectionProvider.connection.getAllProductosColas();
    }
  }

  Future<void> getAllColasActivas() async {
    if (ConnectionProvider.isConnected) {
      await ConnectionProvider.connection.getAllColasActivas();
    }
  }

  Future<void> getAllClientesColaActivas() async {
    if (ConnectionProvider.isConnected) {
      await ConnectionProvider.connection.getAllClientesColasActivas();
    }
  }

  Future<void> insertAllClienteColasActivas() async {
    if (ConnectionProvider.isConnected) {
      await ConnectionProvider.connection
          .insertAllClienteColaActiva(clienteColas);
    }
    notifyListeners();
  }

  List<ClienteColasActivas> devolverClientesDadoIdCola(int idCola) {
    List<ClienteColasActivas> clienteDeUnaCola = [];
    for (var element in clienteColas) {
      if (element.idCola == idCola) {
        clienteDeUnaCola.add(element);
      }
    }
    notifyListeners();
    return clienteDeUnaCola;
  }
}
