import 'package:flutter/cupertino.dart';
import 'package:line_management/services/productoService.dart';
import 'package:line_management/services/shopServices.dart';

import '../model/productos-colas.dart';
import 'connectionProvider.dart';

class ProductosColasProvider with ChangeNotifier {
  List<ProductosColas> productosCola = [];
  ProductoService productService = ProductoService();

  Future<void> insertAllproductosCola() async {
    if (ConnectionProvider.isConnected) {
      await ConnectionProvider.connection.insertAllProductosCola(productosCola);
    }
    notifyListeners();
  }

  List<ProductosColas> develverProductosDadoIdCola(int idCola) {
    List<ProductosColas> productosDeUnaCola = [];
    for (var element in productosCola) {
      if (element.id_cola == idCola) {
        productosDeUnaCola.add(element);
      }
    }
    return productosDeUnaCola;
  }

  void setIsSelected(bool isSeleted, int pos) {
    productosCola[pos].setIsSelected(isSeleted);
    notifyListeners();
  }

  void removeProductoCola(ProductosColas product) {
    productosCola.remove(product);
    notifyListeners();
  }

  void removeProductoColaByName(String product) {
    productosCola.removeWhere((element) => element.nombreProducto == product);
    notifyListeners();
  }

  void removeTodosProductoColaByIdCola(int idCola) {
    productosCola.removeWhere((element) => element.id_cola == idCola);
    notifyListeners();
  }

  void addProductoCola(ProductosColas product, int idColaActiva) {
    if (productosCola.any((element) =>
        element.id_producto == product.id_producto &&
        element.id_cola == idColaActiva)) {
    } else
      productosCola.add(product);
    notifyListeners();
  }

  Future<void> insertarProductoColaEnServidor(
      ProductosColas productoCola) async {
    await productService.createProductoCola(productoCola);
  }

  Future<void> importarProductosColas() async {
    productosCola = await productService.fetchAllProduct();
    notifyListeners();
  }
}
