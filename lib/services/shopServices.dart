import 'dart:convert';

import 'package:http/http.dart';
import 'package:line_management/model/shop.dart';
import 'package:http/http.dart' as http;

class ShopService {
  static String url = 'http://localhost:3001/tiendas';
  Future<List<Shop>> loadAllShops() async {
    List<Shop> shops = [];
    Response response = await http.get(Uri.parse('$url'));
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      for (var item in result) {
        Shop shop = Shop(
            name: item['nombre'],
            id: item['id'],
            activa: item['activa'],
            idMunicipio: item['id_municipio']);
        shops.add(shop);
      }
      return shops;
    } else {
      throw Exception('No se pudo hacer el request');
    }
  }

  Future<List<Shop>> allShopsGivenAMun() async {
    List<Shop> shops = [];
    Response response =
        await http.get(Uri.parse('http://localhost:3001/tiendas/todas/2301'));
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      for (var item in result) {
        Shop shop = Shop(
            name: item['nombre'],
            id: item['id'],
            activa: item['activa'],
            idMunicipio: item['id_municipio']);
        shops.add(shop);
      }
      return shops;
    } else
      throw Exception('No se pudo hacer el request');
  }
}
