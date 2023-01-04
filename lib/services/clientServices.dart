import 'package:line_management/model/client.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:line_management/model/cliente-colas-activas.dart';

class ClienteService {
  static const url = 'http://192.168.43.29:3000/cliente';
  Future<List<ClienteColasActivas>> fetchAllClients() async {
    List<ClienteColasActivas> result = [];
    http.Response response = await http.get(Uri.parse('$url'));
    if (response.statusCode == 200) {
      final resul = jsonDecode(response.body);
      for (var item in resul) {
        ClienteColasActivas aux = ClienteColasActivas(
            nombre: item['nombre'],
            ci: item['ci'],
            id_cola: int.parse(item['id_cola']),
            id_estado: item['id_estado'],
            fecha_modif: item['fecha_modif'],
            fecha_registro: item['fecha_registro'],
            fv: item['fv'],
            id_municipio: item['id_municipio']);
        result.add(aux);
      }
      return result;
    } else {
      throw Exception('No se pudo hacer el request');
    }
  }

  Future<http.Response> createUser(ClienteColasActivas cliente) {
    return http.post(
      Uri.parse('$url/create'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'nombre': cliente.nombre,
        'ci': cliente.ci,
        'id_cola': cliente.id_cola.toString(),
        'fv': cliente.fv,
        'fecha_registro': cliente.fecha_registro,
        'fecha_modif': cliente.fecha_modif,
        'id_estado': cliente.id_estado,
        'id_municipio': cliente.id_municipio
      }),
    );
  }

  Future<Cliente> fetchCliente(int? id) async {
    http.Response response = await http.get(Uri.parse('$url/$id'));
    if (response.statusCode == 200) {
      Cliente aux = Cliente.fromJson(json.decode(response.body));
      print(aux);
      return aux;
    } else
      throw Exception('No se pudo hacer el request');
  }
}
