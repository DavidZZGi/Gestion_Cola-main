import 'package:flutter/cupertino.dart';

import 'package:line_management/model/cliente-colas-activas.dart';
import 'package:line_management/services/lineService.dart';

import '../model/colas-activas.dart';
import 'connectionProvider.dart';

class ColasActivasProvider with ChangeNotifier {
  List<ColaActiva> colas = [];
  int posColaActiva = 0;
  bool isSelected = false;
  String? fecha;
  bool creadaPorPrimeraVez = true;
  ColaActivaService colaService = ColaActivaService();

  Future<void> insertAllColasActivas() async {
    if (ConnectionProvider.isConnected) {
      await ConnectionProvider.connection.insertAllColasActivas(colas);
    }
    notifyListeners();
  }

  Future<void> insertColaActivaServer(ColaActiva cola) async {
    await colaService.createLine(cola);
  }

  Future<void> importarColasActivas() async {
    colas = await colaService.fetchAllColosActivas();
    notifyListeners();
  }

  Future<void> importarColasActivasLocal() async {
    colas = await ConnectionProvider.connection.getAllColasActivas();
    notifyListeners();
  }

  void addCola(ColaActiva cola) {
    colas.add(cola);
    notifyListeners();
  }

  void setnombTienda(int idCola, String nomTienda) {
    for (int i = 0; i < colas.length; i++) {
      if (colas.elementAt(i).id == idCola) {
        colas.elementAt(i).nombTienda = nomTienda;
        notifyListeners();
        break;
      }
    }
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
