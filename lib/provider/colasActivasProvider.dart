import 'package:flutter/cupertino.dart';
import 'package:line_management/model/Product.dart';

import '../model/colas-activas.dart';
import 'connectionProvider.dart';

class ColasActivasProvider with ChangeNotifier {
  List<ColaAciva> colas = [];
  int posColaActiva = 0;

  Future<void> insertAllColasActivas() async {
    if (ConnectionProvider.isConnected) {
      await ConnectionProvider.connection.insertAllColasActivas(colas);
    }
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
  }
}
