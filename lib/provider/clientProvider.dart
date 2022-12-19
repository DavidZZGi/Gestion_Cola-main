import 'package:flutter/cupertino.dart';
import 'package:line_management/model/client.dart';
import 'package:line_management/model/cliente-colas-activas.dart';
import 'package:line_management/services/clientServices.dart';

class ClienteProvider with ChangeNotifier {
  ClienteService _clienteService = ClienteService();
  List<ClienteColasActivas> listacliente = [];
  late Cliente aux;

  ClienteProvider.init() {
    //loadClientes()
  }
/*
List<Cliente> inicializarClientesSinConexion(){
Cliente cliente1=Cliente(/*idCliente: 1,*/ carnetIdentidad: '98022108501', nombre: 'David', apellidos: 'Zequeira Zorrilla');
Cliente cliente2=Cliente(/*idCliente: 2,*/ carnetIdentidad: '98035408501', nombre: 'Liset', apellidos: 'Montano Hernandez');
Cliente cliente3=Cliente(/*idCliente: 3,*/ carnetIdentidad: '93221034401', nombre: 'Marcelo', apellidos: 'Zequeira Valdez');
Cliente cliente4=Cliente(/*idCliente: 4,*/ carnetIdentidad: '98022108501', nombre: 'Marlene', apellidos: 'Zorrilla Varona');
Cliente cliente5=Cliente(/*idCliente: 5,*/ carnetIdentidad: '98022108501', nombre: 'Marcel', apellidos: 'Zequeira Gomez');
listacliente.add(cliente1);
listacliente.add(cliente2);
listacliente.add(cliente3);
listacliente.add(cliente4);
listacliente.add(cliente5);
//notifyListeners();
return listacliente;
}
*/

  Future<List<ClienteColasActivas>> loadClientes() async {
    listacliente = await _clienteService.fetchAllClients();
    notifyListeners();
    return listacliente;
  }

  Future<Cliente> findCliente({int? id}) async {
    Cliente result = await _clienteService.fetchCliente(id);
    aux = Cliente(
      // idCliente: result.idCliente,
      carnetIdentidad: result.carnetIdentidad,
      nombre: result.nombre,
      apellidos: result.apellidos,
      idEstado: result.idEstado,
    );
    print(aux);
    notifyListeners();
    return aux;
  }

  void removeCliente(Cliente cliente) {
    listacliente.remove(cliente);
    notifyListeners();
  }

  Cliente stringToCliente(String? clienteS) {
    String client = clienteS!.trim();
    int posiscionNombre = client.indexOf('n:');
    int posicionAppelido = client.indexOf('a:');
    int posicionCI = client.indexOf('ci:');
    int posicionFV = client.indexOf('fv:');

    String nombreClient =
        client.substring(posiscionNombre + 2, posicionAppelido);
    String apellidosClient = client.substring(posicionAppelido + 2, posicionCI);
    String carnetIdnt = client.substring(posicionCI + 3, posicionFV);

    Cliente cliente = Cliente(
        /*idCliente: 1,*/ carnetIdentidad: carnetIdnt,
        nombre: nombreClient,
        apellidos: apellidosClient,
        idEstado: 1);
    //  listacliente.add(cliente);
//notifyListeners();
    return cliente;
  }

  ClienteProvider();
}
