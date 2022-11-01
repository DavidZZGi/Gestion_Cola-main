import 'package:flutter/material.dart';
import 'package:line_management/model/client.dart';
import 'package:line_management/provider/clientProvider.dart';
import 'package:line_management/provider/connectionProvider.dart';
import 'package:provider/provider.dart';

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
  late List<Cliente> clientes;
  late List<Cliente> clientesAdds;
  @override
  void initState() {
    super.initState();
    Provider.of<ConnectionProvider>(context, listen: false)
        .loadClientesFromDB();
  }

  @override
  Widget build(BuildContext context) {
    clientes = Provider.of<ConnectionProvider>(context).clientesDB;
    /*clientesAdds=Provider.of<ClienteProvider>(context).listacliente;
    for (var element in clientesAdds) {
      if (!clientes.contains(element)) clientes.add(element);
  */

    return ListView.builder(
        padding: EdgeInsets.all(6),
        itemCount: clientes.length,
        itemBuilder: (context, i) {
          final cliente = clientes[i];
          return Dismissible(
            background: Container(
              child: Center(
                  child: Text(
                'Eliminar',
                style: TextStyle(color: Colors.black, fontSize: 20),
              )),
              color: Colors.red,
            ),
            key: ValueKey<String>(cliente.nombre),
            onDismissed: (DismissDirection direction) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: Duration(seconds: 2),
                  content:
                      Text('${clientes[i].nombre} fue removido de la cola')));
              setState(() {
                Provider.of<ConnectionProvider>(context, listen: false)
                    .deleteCliente(cliente.carnetIdentidad);
                Provider.of<ClienteProvider>(context, listen: false)
                    .removeCliente(cliente);
                clientes.remove(cliente);
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
                title: Text(
                  '${clientes[i].nombre}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black45),
                ),
                subtitle: Text('${clientes[i].carnetIdentidad}'),
              ),
            ),
          );
        });
  }
}
