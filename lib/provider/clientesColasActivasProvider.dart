import 'package:flutter/cupertino.dart';
import 'package:line_management/model/cliente-colas-activas.dart';

import 'connectionProvider.dart';

class ClienteColaActivaProvider with ChangeNotifier {
  List<ClienteColasActivas> clienteColasActivas = [];

  Future<void> insertAllproductosCola() async {
    if (ConnectionProvider.isConnected) {
      await ConnectionProvider.connection
          .insertAllClienteColaActiva(clienteColasActivas);
    }
    notifyListeners();
  }

  List<ClienteColasActivas> develverProductosDadoIdCola(int idCola) {
    List<ClienteColasActivas> clientesColaActiva = [];
    for (var element in clienteColasActivas) {
      if (element.idCola == idCola) {
        clientesColaActiva.add(element);
      }
    }
    return clientesColaActiva;
  }
}
