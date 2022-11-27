import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
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
  int cantColasCreadas = 0;
  int idTienda = 0;
  List<String> nombresTienda = [];
  int nombTiendaPos = 0;

  int incNomTiendaPos() {
    nombTiendaPos++;

    notifyListeners();
    return nombTiendaPos;
  }

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
    nombresTienda.add(nomTienda);
    notifyListeners();
  }

  void setNomTiendaActiva(String value) {
    nomTienda = value;
    notifyListeners();
  }

  int getSixDigitDate() {
    String result = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String sixDigitDate = result.substring(2);
    sixDigitDate = sixDigitDate.replaceAll('-', '');
    sixDigitDate = sixDigitDate.trim();
    notifyListeners();
    return int.parse(sixDigitDate);
  }

  void updateCantColas() {
    cantColasCreadas++;
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
