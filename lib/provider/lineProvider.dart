import 'package:flutter/cupertino.dart';
import 'package:line_management/model/client.dart';
import 'package:line_management/model/line.dart';

class LineProvider with ChangeNotifier {
//ConnectionServices _connectionServices=ConnectionServices();

  String munSelected = '';
  List<Cliente> clientes = [];
  late Line line;
  bool colaCreada = false;
  List<String> productos = [];
  String nomTienda = '';

  void addProducto(String nomProducto) {
    if (!productos.contains(nomProducto)) {
      productos.add(nomProducto);
      notifyListeners();
    } else {
      print('Producto  repetido');
    }
  }

  void setMunSelected(String mun) {
    munSelected = mun;
    notifyListeners();
  }

  void setcolaCreada(bool creada) {
    colaCreada = creada;
    notifyListeners();
  }

  void setNomTienda(String value) {
    nomTienda = value;
    notifyListeners();
  }

/*
Future<void>addLine(Line line)async{
await _connectionServices.insertLine(line);
notifyListeners();
}

Future<List<Line>>getAllLines()async{
lines=await _connectionServices.getLines();
notifyListeners();
return lines;
}
 */

}
