import 'package:flutter/cupertino.dart';
import 'package:line_management/model/cliente-colas-activas.dart';
import 'package:line_management/services/clientServices.dart';

import 'connectionProvider.dart';

class ClienteColaActivaProvider with ChangeNotifier {
  List<ClienteColasActivas> clienteColasActivas = [];
  List<ClienteColasActivas> clienteColasActivasDeUnaColaAux = [];
  ClienteService clienteService = ClienteService();

  Future<void> insertAllClienteColaActiva() async {
    if (ConnectionProvider.isConnected) {
      await ConnectionProvider.connection
          .insertAllClienteColaActiva(clienteColasActivas);
    }
    notifyListeners();
  }

  List<ClienteColasActivas> develverClientesDadoIdCola(int? idCola) {
    List<ClienteColasActivas> list = [];
    for (int i = 0; i < clienteColasActivas.length; i++) {
      if (clienteColasActivas.elementAt(i).id_cola == idCola) {
        list.add(clienteColasActivas.elementAt(i));
      }
    }
    return list;
  }

  void develverClientesDadoIdColaSubList(int? idCola) {
    for (int i = 0; i < clienteColasActivas.length; i++) {
      if (clienteColasActivas.elementAt(i).id_cola == idCola) {
        clienteColasActivasDeUnaColaAux.add(clienteColasActivas.elementAt(i));
      }
    }
  }

  bool addClienteColaActiva(ClienteColasActivas cliente, int idCola) {
    if (clienteColasActivas.any(
        (element) => element.ci == cliente.ci && element.id_cola == idCola)) {
      return false;
    } else
      clienteColasActivas.add(cliente);
    notifyListeners();
    return true;
  }

  bool clienteRepitido(ClienteColasActivas cliente) {
    if (clienteColasActivas.any((element) =>
        element.ci == cliente.ci && element.id_cola == cliente.id_cola)) {
      return true;
    } else
      return false;
  }

  void addclienteColasActivasDeUnaColaAux(ClienteColasActivas cliente) {
    clienteColasActivasDeUnaColaAux.add(cliente);
    notifyListeners();
  }

  void removeClienteColaActiva(ClienteColasActivas cliente) {
    clienteColasActivas.remove(cliente);
    notifyListeners();
  }

  void removeTodosClienteColaActiva(int idCola) {
    clienteColasActivas.removeWhere((element) => element.id_cola == idCola);
    notifyListeners();
  }

  List<String> getQRCode(String? clienteS) {
    List<String> datos = [];
    String client = clienteS!.trim();
    int posiscionNombre = client.indexOf('n:');
    int posicionAppelido = client.indexOf('a:');
    int posicionCI = client.indexOf('ci:');
    int posicionFV = client.indexOf('fv:');

    String nombreapellidosClient =
        client.substring(posiscionNombre + 2, posicionAppelido) +
            client.substring(posicionAppelido + 2, posicionCI);
    //String apellidosClient = client.substring(posicionAppelido + 2, posicionCI);
    String carnetIdnt = client.substring(posicionCI + 3, posicionFV);
    String fv = client.substring(posicionFV + 3, client.length);
    datos.add(nombreapellidosClient);
    datos.add(carnetIdnt);
    datos.add(fv);
    return datos;
  }

  Future<void> createClienteColaServer(ClienteColasActivas cliente) async {
    await clienteService.createUser(cliente);
  }

  Future<void> importarClientes() async {
    clienteColasActivas = await clienteService.fetchAllClients();
    notifyListeners();
  }
}
