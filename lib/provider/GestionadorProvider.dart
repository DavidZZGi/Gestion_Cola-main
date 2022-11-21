import 'package:flutter/cupertino.dart';
import 'package:line_management/model/ClienteValidator.dart';
import 'package:line_management/provider/colasActivasProvider.dart';
import 'package:line_management/provider/connectionProvider.dart';
import 'package:line_management/provider/lineProvider.dart';
import 'package:line_management/provider/productProvider.dart';
import 'package:line_management/provider/productosColasProvider.dart';

import '../model/cliente-cola-historico.dart';
import '../model/cliente-colas-activas.dart';

import '../model/productos-colas.dart';

class GestionadorProvider with ChangeNotifier {
  List<ClienteValidator> clienteValidator = [];
  List<ClienteColasHistorico> clienteColasHistoricas = [];
  List<ProductosColas> productosColasHistorica = [];
  ProductosColasProvider productosColasProvider = ProductosColasProvider();
  ColasActivasProvider colasActivasProvider = ColasActivasProvider();
  ProductProvider productProvider = ProductProvider();
  LineProvider lineProvider = LineProvider();

  ///Cargar datos de la bd historica
  Future<void> cargarAllValidatorData() async {
    if (ConnectionProvider.isConnected) {
      clienteValidator =
          await ConnectionProvider.connection.getAllValidatorData();
    }
  }

  String obtenerNombreTiendaYProductDeTiendaActia(int idCola) {
    List<ProductosColas> productos =
        productosColasProvider.develverProductosDadoIdCola(idCola);
    List<String> nombreProductos = [];
    for (var element in productos) {
      nombreProductos.add(productProvider.nomProductdadoId(element.idProducto));
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
}
