import 'package:flutter/cupertino.dart';
import 'package:line_management/model/Product.dart';
import 'package:line_management/model/municipio.dart';
import 'package:line_management/model/shop.dart';
import 'package:line_management/services/localConnectionServices.dart';

import '../model/client.dart';

class ConnectionProvider with ChangeNotifier{
ConnectionServices connection =ConnectionServices();//(dbName: 'db.sqlite');
List<Cliente>clientesDB=[];
List<Product>products=[];
List<Municipio>municipios=[];
List<Shop>shops=[];
List<Shop>shopMun=[];


Future<void>getConnection()async{
await connection.cargarBD();
notifyListeners();
}
Future<void>createCliente(Cliente cliente)async{
await connection.insertarCliente(cliente);
notifyListeners();
  
}
Future<void>insertCliente(Cliente cliente)async{
await connection.insertClient(cliente);
notifyListeners();
  
}

Future<void>deleteCliente(String ci)async{
  await connection.deleteCliente(ci);
  notifyListeners();
}

Future<void>loadClientesFromDB()async{

clientesDB=await connection.getClientes();

notifyListeners();

}


Future<List<Product>>getAllProducts()async{
  products =await connection.getAllProductos();
  notifyListeners();
  return products;
}

Future<List<Municipio>>getAllMunicipios()async{
municipios=await connection.getAllMun();
notifyListeners();
return municipios;
}
Future<List<Shop>>getAllShops()async{
shops=await connection.getAllShops();
notifyListeners();
return shops;
}

Future<List<Shop>>getAllShopFromMun(int idMun)async{

shopMun=await connection.getTiendaDadoMun(idMun);
notifyListeners();
return shopMun;
}

}