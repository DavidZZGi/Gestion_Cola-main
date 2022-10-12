import 'dart:convert';

import'package:http/http.dart 'as http;
import 'package:http/http.dart';

import 'package:line_management/model/Product.dart';
class ProductoService {
static const url='http://localhost:3002/productos';

Future<List<Product>>fetchAllProduct()async{
  List<Product>products=[];
 Response response =await http.get(Uri.parse('$url'));
 
if(response.statusCode==200){
 final resul= jsonDecode(response.body);
 print(resul);
     for (var item in resul) {
       Product product=Product(
        productName: item['nombre'],
        id: item['id'],
         idTipo: item['id_tipo']);
         products.add(product);
     }
   
  return products ;
}
else{
  throw Exception('No se pudo hacer el request');
}

}

}