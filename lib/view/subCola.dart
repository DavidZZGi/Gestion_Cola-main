import 'package:flutter/material.dart';
import 'package:line_management/provider/lineProvider.dart';
import 'package:provider/provider.dart';

import '../model/client.dart';
import '../model/estados.dart';

class SubCola extends StatefulWidget {
  SubCola({Key? key}) : super(key: key);

  @override
  State<SubCola> createState() => _SubColaState();
}

class _SubColaState extends State<SubCola> {
  @override
  Widget build(BuildContext context) {
    List<Cliente> clientes =
        Provider.of<LineProvider>(context, listen: false).clientes;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Escoja el cliente que empieza la subcola'),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.lightBlue, Color.fromRGBO(14, 30, 50, 1.7)]),
        ),
        child: ListView.builder(
          itemCount: clientes.length,
          itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Color.fromARGB(109, 90, 88, 88),
                child: ListTile(
                  leading: Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.black,
                  ),
                  title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${clientes[i].nombre}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black45,
                              fontSize: 18.0),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(children: [
                            ElevatedButton(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(5, 5, 5, 0),
                                      child: Text('Estado'),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: Text(
                                          '${Estados.getEstadoName(clientes[i].idEstado)}'),
                                    ),
                                  ],
                                ),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateColor
                                        .resolveWith((states) =>
                                            Color.fromARGB(255, 67, 65, 65))),
                                onPressed: (() {})),
                            ElevatedButton(
                                onPressed: () {
                                  return _showDialog();
                                },
                                child: Text(
                                  'A partir de aqui',
                                )),
                          ]),
                        ),
                      ]),
                  subtitle: Text('${clientes[i].carnetIdentidad}'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAlertDialog() {
    return AlertDialog(
      title: Text('Iniciar Subcola'),
      content: Text("¿Desea iniciar la subcola a partir de este cliente :)"),
      actions: <Widget>[
        ElevatedButton(
            child: Text("Aceptar"),
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateColor.resolveWith((states) => Colors.blue)),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        ElevatedButton(
            child: Text("Cancelar"),
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateColor.resolveWith((states) => Colors.red)),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ],
    );
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return _buildAlertDialog();
        });
  }
}
