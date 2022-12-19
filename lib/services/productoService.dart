import 'dart:convert';

import 'package:http/http.dart ' as http;
import 'package:http/http.dart';

import 'package:line_management/model/Product.dart';
import 'package:line_management/model/productos-colas.dart';

class ProductoService {
  static const url = 'http://10.0.2.2:3002/productos';

  Future<List<ProductosColas>> fetchAllProduct() async {
    List<ProductosColas> products = [];
    Response response = await http.get(Uri.parse('$url'));

    if (response.statusCode == 200) {
      final resul = jsonDecode(response.body);
      print(resul);
      for (var item in resul) {
        ProductosColas product = ProductosColas(
          id_cola: int.parse(item['id_cola']),
          id_producto: item['id_producto'],
        );
        products.add(product);
      }

      return products;
    } else {
      throw Exception('No se pudo hacer el request');
    }
  }

  Future<http.Response> createProductoCola(ProductosColas product) {
    return http.post(
      Uri.parse('$url/create'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id_cola': product.id_cola.toString(),
        'id_producto': product.id_producto,
      }),
    );
  }
}
