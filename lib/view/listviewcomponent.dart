import 'package:flutter/material.dart';
import 'package:line_management/model/client.dart';
import 'package:line_management/provider/clientProvider.dart';
import 'package:line_management/provider/colasActivasProvider.dart';
import 'package:line_management/provider/connectionProvider.dart';
import 'package:provider/provider.dart';

import '../model/cliente-colas-activas.dart';
import '../model/estados.dart';
import '../provider/clientesColasActivasProvider.dart';
import '../provider/lineProvider.dart';

class MylistView extends StatefulWidget {
  @override
  State<MylistView> createState() => _MylistViewState();
}

class _MylistViewState extends State<MylistView> {
  /*List<String> clientes = [
    'juan',
    'pedro',
    'adrian',
    'pepe',
    'alain',
    'jesus',
    'marcelo'
  ];
 //late List<Cliente> clientes;
 */
  int? posCola;
  int? idColaActiva;

  late List<Cliente> clientesAdds;
  List<ClienteColasActivas>? clientesCola;
  @override
  void initState() {
    super.initState();
    posCola =
        Provider.of<ColasActivasProvider>(context, listen: false).posColaActiva;
    print(posCola);
    idColaActiva = Provider.of<ColasActivasProvider>(context, listen: false)
        .colas[posCola!]
        .id;
    print(idColaActiva);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ClienteColaActivaProvider>(
      builder: (context, value, child) {
        return ListView.builder(
            padding: EdgeInsets.all(6),
            itemCount: value.develverClientesDadoIdCola(idColaActiva).length,
            itemBuilder: (context, i) {
              List<ClienteColasActivas> clientes =
                  value.develverClientesDadoIdCola(idColaActiva);
              return Dismissible(
                background: Container(
                  child: Center(
                      child: Text(
                    'Eliminar',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  )),
                  color: Colors.red,
                ),
                key: ValueKey<String>(clientes[i].nombre),
                onDismissed: (DismissDirection direction) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text(
                          '${clientes[i].nombre} fue removido de la cola')));
                  setState(() {
                    Provider.of<ClienteColaActivaProvider>(context,
                            listen: false)
                        .removeClienteColaActiva(clientes[i]);
                  });
                },
                child: Card(
                  color: Colors.transparent,
                  child: ListTile(
                    leading: Icon(
                      Icons.person,
                      size: 30,
                      color: Colors.black,
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            '${i + 1}.  ${clientes[i].nombre}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black45,
                                fontSize: 18.0),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith(
                                    (states) =>
                                        Color.fromARGB(255, 67, 65, 65))),
                            onPressed: (() {
                              /*
                              setState(() {
                                int idnewEstado = 1;
                                if (clientes[i].id_estado == 4) {
                                  clientes[i].id_estado = 0;
                                  idnewEstado = clientes[i].id_estado;
                                }
                                clientes[i].id_estado++;
                                idnewEstado = clientes[i].id_estado;
                                int pos = Provider.of<
                                            ClienteColaActivaProvider>(context,
                                        listen: false)
                                    .clienteColasActivas
                                    .indexWhere((element) =>
                                        Provider.of<ClienteColaActivaProvider>(
                                                context,
                                                listen: false)
                                            .clienteColasActivas
                                            .contains(clientes[i]));
                                Provider.of<ClienteColaActivaProvider>(context,
                                        listen: false)
                                    .clienteColasActivas[pos]
                                    .setIdEstado(idnewEstado);
                                print(Provider.of<ClienteColaActivaProvider>(
                                        context,
                                        listen: false)
                                    .clienteColasActivas[pos]
                                    .id_estado);
                              });*/
                            }),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Flexible(
                                    child: Text(
                                        '${Estados.getEstadoName(clientes[i].id_estado)}'),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    subtitle: Text('${clientes[i].id_cola}'),
                  ),
                ),
              );
            });
      },
    );
  }
}
