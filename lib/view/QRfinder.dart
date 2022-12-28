import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/ClienteValidator.dart';
import '../model/cliente-colas-activas.dart';
import '../model/estados.dart';
import '../provider/clientesColasActivasProvider.dart';

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
        // clientereal = clientesVerify!.elementAt(i);
        clientereal = ClienteValidator(
            ci: clientesVerify!.elementAt(i).ci,
            idCola: clientesVerify!.elementAt(i).id_cola,
            nombProducto: clientesVerify!.elementAt(i).nombProducto,
            idEstado: clientesVerify!.elementAt(i).idEstado);
        productos += '' + clientesVerify!.elementAt(i).nombProducto + '/';
      }
    }
    print(productos);
    int idTienda = int.parse(cliente!.id_cola.toString().substring(0, 3));
    print(idTienda);

    String fecha = '2' + cliente.id_cola.toString().substring(3, 8);
    String fechareal = fecha.substring(0, 2) +
        '/' +
        fecha.substring(2, 4) +
        '/' +
        fecha.substring(4, 6);
    return Scaffold(
      appBar: AppBar(
        title: Text('Cliente encontrado en l sistema'),
      ),
      body: Container(
        padding: EdgeInsets.all(12.0),
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
              Text(
                'Cliente encontrado en el sistema',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text('CI: ${cliente.ci}'),
              Text('Productos: $productos'),
              Text('Tienda: $nombTiemda'),
              Text('Fecha: $fechareal'),
              Text('Estado: ${Estados.getEstadoName(cliente.id_estado)}'),
              Row(
                children: [
                  ElevatedButton(
                      child: Text("Aceptar"),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => Colors.green)),
                      onPressed: () {
                        ClienteColasActivas clienteRech = ClienteColasActivas(
                            ci: clientereal!.ci,
                            nombre: cliente.nombre,
                            id_cola: cliente.id_cola,
                            fv: '',
                            id_estado: 2,
                            id_municipio: cliente.id_municipio,
                            fecha_modif: DateTime.now().toIso8601String(),
                            fecha_registro: cliente.fecha_registro);
                        Provider.of<ClienteColaActivaProvider>(context,
                                listen: false)
                            .addClienteColaActiva(
                                clienteRech, clienteRech.id_cola);
                        Navigator.of(context).pop();
                      }),
                  ElevatedButton(
                      child: Text("Rechazar"),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => Colors.red)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
