import 'package:flutter/cupertino.dart';
import 'package:line_management/model/ClienteValidator.dart';
import 'package:line_management/model/Product.dart';
import 'package:line_management/provider/colasActivasProvider.dart';
import 'package:line_management/provider/connectionProvider.dart';
import 'package:line_management/provider/lineProvider.dart';
import 'package:line_management/provider/productProvider.dart';
import 'package:line_management/provider/productosColasProvider.dart';
import 'package:line_management/services/productoService.dart';

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
  List<ClienteColasActivas> clientesRegistrados = [];
  ProductoService productoService = ProductoService();
  List<Product> products = [];
  ConnectionProvider connectionProvider = ConnectionProvider();

  ///Cargar datos de la bd historica
  Future<void> cargarAllValidatorData() async {
    if (ConnectionProvider.isConnected) {
      clienteValidator =
          await ConnectionProvider.connection.getAllValidatorData();
    }
  }

  String nomShopId(int id) {
    for (var item in products) {
      if (item.id == id) {
        return item.productName;
      }
    }
    return '';
  }

  Future<void> cargarValidatorDataHistorico() async {
    products = await connectionProvider.getAllProducts();
    String numProductos = '';
    if (ConnectionProvider.isConnected) {
      clientesRegistrados =
          await ConnectionProvider.connection.getAllClientesColasActivas();
      for (var element in clientesRegistrados) {
        productosColasHistorica = await ConnectionProvider.connection
            .getProductoDadoIdCola(element.id_cola);
      }
      for (var element in productosColasHistorica) {
        numProductos += nomShopId(element.id_producto) + '/';
      }

      for (var element in clientesRegistrados) {
        ClienteValidator clienteVali = ClienteValidator(
            ci: element.ci,
            idCola: element.id_cola,
            nombProducto: numProductos,
            idEstado: element.id_estado);
        clienteValidator.add(clienteVali);
      }
    }
  }

  String obtenerNombreTiendaYProductDeTiendaActia(int idCola) {
    List<ProductosColas> productos =
        productosColasProvider.develverProductosDadoIdCola(idCola);
    List<String> nombreProductos = [];
    for (var element in productos) {
      nombreProductos
          .add(productProvider.nomProductdadoId(element.id_producto));
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
