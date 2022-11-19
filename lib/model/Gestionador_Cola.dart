import 'package:line_management/model/cliente-colas-activas.dart';
import 'package:line_management/model/colas-activas.dart';
import 'package:line_management/model/productos-colas.dart';

class Gestionador {
  static List<ColaActiva> colas = [];
  static List<ProductosColas> productosCola = [];
  static List<ClienteColasActivas> clienteColas = [];

  static List<ProductosColas> develverProductosDadoIdCola(int idCola) {
    List<ProductosColas> productosDeUnaCola = [];
    for (var element in productosCola) {
      if (element.idCola == idCola) {
        productosDeUnaCola.add(element);
      }
    }
    return productosDeUnaCola;
  }

  static List<ClienteColasActivas> devolverClientesDadoIdCola(int idCola) {
    List<ClienteColasActivas> clienteDeUnaCola = [];
    for (var element in clienteColas) {
      if (element.idCola == idCola) {
        clienteDeUnaCola.add(element);
      }
    }
    return clienteDeUnaCola;
  }
}
