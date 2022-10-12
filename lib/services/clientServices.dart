
import 'package:line_management/model/client.dart';
import 'package:http/http.dart'as http;
import'dart:convert';

class ClienteService{
  static const url='http://localhost:3000/users';
  Future <List<Cliente>>fetchAllClients()async{
List<Cliente> result=[];
http.Response response = await http.get(Uri.parse('$url'));
if(response.statusCode==200){
 final resul= jsonDecode(response.body);
     for (var item in resul) {
       Cliente aux=Cliente(/*idCliente: item['idCliente'],*/
        nombre: item['nombre'],
         carnetIdentidad: item['carnetIdentidad'],
         apellidos: item['apellidos'],
       
   
          );
         result.add(aux);
     }
  return result ;
}
else{
  throw Exception('No se pudo hacer el request');
}
}

Future<http.Response> createUser(Cliente user) {
  return http.post(
    Uri.parse('$url/create'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      //'idCliente': user.idCliente,
      'nombre':user.nombre,
      'carnetIdentidad':user.carnetIdentidad,
      'apellidos':user.apellidos,
    
    }),
  );
}

Future<Cliente>fetchCliente (int ? id)async{
http.Response response= await http.get(Uri.parse('$url/$id'));
if(response.statusCode==200){
 Cliente aux= Cliente.fromJson(json.decode(response.body));
 print(aux);
 return aux;
}else throw Exception('No se pudo hacer el request');
}








}