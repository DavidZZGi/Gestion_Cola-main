import 'package:flutter/cupertino.dart';
import 'package:line_management/model/Product.dart';
import 'package:line_management/services/productoService.dart';

class ProductProvider with ChangeNotifier {
  ProductoService _productService = ProductoService();
  List<Product> products = [];
  late int idProductSelected;
  bool agregado = false;

  void initProduct(Future<List<Product>> productInit) async {
    products = await productInit;
  }

  Future<List<Product>> getAllProducts() async {
    products = await _productService.fetchAllProduct();
    notifyListeners();
    return products;
  }

  int idNomProduct(String nameProduct) {
    for (var item in products) {
      if (item.productName == nameProduct) {
        idProductSelected = item.id;
      }
    }
    return idProductSelected;
  }

  String NomProductdadoId(int id) {
    String result = '';
    for (var item in products) {
      if (item.id == id) {
        result = item.productName;
      }
    }
    return result;
  }
}
