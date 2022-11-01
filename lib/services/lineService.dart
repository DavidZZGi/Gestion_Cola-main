import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../model/line.dart';

class LineService {
  static const String url = 'http://localhost:3003/line';

  DateTime fecha =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  Future<bool> createLine(Line line, String ci) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        http.post(
          Uri.parse('$url/create'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'id:producto': line.idproducts,
            'carnet_identidad': ci,
            'fecha': fecha,
            'id_municipio': line.idMun,
            'id_tienda': line.idTienda
          }),
        );
        return true;
      }
    } on SocketException catch (_) {
      print('No connection');
    }

    return false;
  }
}
