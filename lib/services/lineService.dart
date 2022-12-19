import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:line_management/model/colas-activas.dart';

import '../model/line.dart';

class ColaActivaService {
  static const String url = 'http://10.0.2.2:3006/cola';
  Future<http.Response> createLine(ColaActiva cola) async {
    return http.post(
      Uri.parse('$url/create'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': cola.id.toString(),
        'tienda': cola.tienda,
        'fecha': cola.fecha,
      }),
    );
  }

  Future<List<ColaActiva>> fetchAllColosActivas() async {
    List<ColaActiva> products = [];
    http.Response response = await http.get(Uri.parse('$url'));

    if (response.statusCode == 200) {
      final resul = jsonDecode(response.body);
      print(resul);
      for (var item in resul) {
        ColaActiva cola = ColaActiva(
          id: int.parse(item['id']),
          tienda: item['tienda'],
          fecha: item['fecha'],
        );
        products.add(cola);
      }

      return products;
    } else {
      throw Exception('No se pudo hacer el request');
    }
  }
}
