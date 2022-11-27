import 'package:flutter/material.dart';
import '../model/ClienteValidator.dart';
import '../model/estados.dart';

class QRFind extends StatelessWidget {
  final cliente;
  final clientesVerify;
  final nombTiemda;
  QRFind(
      {required this.cliente,
      required this.clientesVerify,
      required this.nombTiemda});

  @override
  Widget build(BuildContext context) {
    String productos = '';
    ClienteValidator? clientereal;
    for (int i = 0; i < clientesVerify!.length; i++) {
      if (cliente.ci == clientesVerify!.elementAt(i).ci &&
          cliente.id_cola == clientesVerify!.elementAt(i).id_cola) {
        clientereal = clientesVerify!.elementAt(i);
        productos += '' + clientesVerify!.elementAt(i).nombProducto + '/';
      }
    }
    print(productos);
    int idTienda = int.parse(clientereal!.idCola.toString().substring(0, 3));
    print(idTienda);

    String fecha = '2' + clientereal.idCola.toString().substring(3, 8);
    String fechareal = fecha.substring(0, 2) +
        '/' +
        fecha.substring(2, 4) +
        '/' +
        fecha.substring(4, 6);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(12.0),
        height: 100,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.lightBlue, Color.fromRGBO(14, 30, 50, 1.7)])),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Cliente encontrado en el sistema'),
              Text('CI: ${clientereal.ci}'),
              Text('Productos: $productos'),
              Text('Tienda: $nombTiemda'),
              Text('Fecha: $fechareal'),
              Text('Estado: ${Estados.getEstadoName(clientereal.idEstado)}')
            ],
          ),
        ),
      ),
    );
  }
}
