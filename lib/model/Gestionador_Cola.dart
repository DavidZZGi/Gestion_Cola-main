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
      if (element.id_cola == idCola) {
        productosDeUnaCola.add(element);
      }
    }
    return productosDeUnaCola;
  }

  static List<ClienteColasActivas> devolverClientesDadoIdCola(int idCola) {
    List<ClienteColasActivas> clienteDeUnaCola = [];
    for (var element in clienteColas) {
      if (element.id_cola == idCola) {
        clienteDeUnaCola.add(element);
      }
    }
    return clienteDeUnaCola;
  }
}
