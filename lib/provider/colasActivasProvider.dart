import 'package:flutter/cupertino.dart';

import 'package:line_management/model/cliente-colas-activas.dart';

import '../model/colas-activas.dart';
import 'connectionProvider.dart';

class ColasActivasProvider with ChangeNotifier {
  List<ColaActiva> colas = [];
  int posColaActiva = 0;
  bool isSelected = false;
  String? fecha;
  bool creadaPorPrimeraVez = true;

  Future<void> insertAllColasActivas() async {
    if (ConnectionProvider.isConnected) {
      await ConnectionProvider.connection.insertAllColasActivas(colas);
    }
    notifyListeners();
  }

  Future<String> getFecha() async {
    String result = '';
    if (ConnectionProvider.isConnected) {
      final res = await ConnectionProvider.connection.getFecha();
      result = res;
    }
    return result;
  }

  void addClienteAColaActiva(ClienteColasActivas cliente) {
    colas[posColaActiva].clienteColas!.add(cliente);
    notifyListeners();
  }

  void removeColaDadoId(int id) {
    for (var element in colas) {
      if (element.id == id) {
        colas.remove(element);
      }
    }
  }

  void setPosColaActiva(int pos) {
    this.posColaActiva = pos;
    notifyListeners();
  }

  void setCreadaXPrimeraVez(bool creada) {
    this.creadaPorPrimeraVez = creada;
    notifyListeners();
  }

  int getSixDigitDate(String? fecha) {
    String sixDigitDate = fecha!.substring(3);
    sixDigitDate = sixDigitDate.replaceAll('-', '');
    sixDigitDate = sixDigitDate.trim();
    notifyListeners();
    return int.parse(sixDigitDate);
  }

  void setFecha(String? fecha) {
    this.fecha = fecha;
  }
}
