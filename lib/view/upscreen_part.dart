import 'package:flutter/material.dart';
import 'package:line_management/model/cliente-colas-activas.dart';
import 'package:line_management/model/colas-activas.dart';
import 'package:line_management/model/line.dart';
import 'package:line_management/provider/clientesColasActivasProvider.dart';
import 'package:line_management/provider/colasActivasProvider.dart';
import 'package:line_management/provider/connectionProvider.dart';
import 'package:line_management/provider/productosColasProvider.dart';
import 'package:line_management/provider/shopProvider.dart';
import 'package:provider/provider.dart';

import '../provider/lineProvider.dart';

// ignore: must_be_immutable
class UpScreenPart extends StatefulWidget {
  @override
  State<UpScreenPart> createState() => _UpScreenPartState();
}

class _UpScreenPartState extends State<UpScreenPart> {
  String estado = 'Sincronizado';
  DateTime time = DateTime.now();
  List<ClienteColasActivas>? listaCliente;
  List<ClienteColasActivas>? listaClienteSucola;
  int? posColaActiva;
  int? idCola;

  List<ClienteColasActivas> crearListaClienteSubCola() {
    posColaActiva =
        Provider.of<ColasActivasProvider>(context, listen: false).posColaActiva;
    idCola = Provider.of<ColasActivasProvider>(context, listen: false)
        .colas[posColaActiva!]
        .id;
    listaCliente =
        Provider.of<ClienteColaActivaProvider>(context, listen: false)
            .develverClientesDadoIdCola(idCola! - 1);
    if (listaCliente!.length > 0) {
      for (int i = 0; i < listaCliente!.length; i++) {
        if (listaCliente!.elementAt(i).id_estado == 4 &&
            listaCliente!.elementAt(i + 1).id_estado == 1) {
          int pos = i + 1;
          listaClienteSucola = listaCliente!.sublist(pos);
        }
      }
      if (listaClienteSucola != null) {
        for (var element in listaClienteSucola!) {
          Provider.of<ClienteColaActivaProvider>(context, listen: false)
              .removeClienteColaActiva(element);
          element.setIdCola(element.id_cola + 1);
          Provider.of<ClienteColaActivaProvider>(context, listen: false)
              .clienteColasActivas
              .add(element);
        }
      } else
        return [];
      return listaClienteSucola!;
    } else
      return [];
  }

  void crearCola() {
    int i = 1;
    posColaActiva =
        Provider.of<ColasActivasProvider>(context, listen: false).posColaActiva;
    idCola = Provider.of<ColasActivasProvider>(context, listen: false)
        .colas[posColaActiva!]
        .id;
    int idTienda = Provider.of<ColasActivasProvider>(context, listen: false)
        .colas[posColaActiva!]
        .tienda;
    ColaActiva subcola = ColaActiva(
        id: idCola! + i,
        tienda: idTienda,
        fecha: DateTime.now().toIso8601String());
    subcola.nombTienda =
        Provider.of<ColasActivasProvider>(context, listen: false)
            .colas[posColaActiva!]
            .nombTienda;
    Provider.of<ColasActivasProvider>(context, listen: false).addCola(subcola);
    int cantColasCreadas =
        Provider.of<ColasActivasProvider>(context, listen: false).colas.length;
    Provider.of<ColasActivasProvider>(context, listen: false)
        .setPosColaActiva(cantColasCreadas - 1);
    if (cantColasCreadas > 0) {
      setState(() {
        Provider.of<ColasActivasProvider>(context, listen: false)
            .colas[posColaActiva!]
            .setIsSelected(false);
        subcola.isSelected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool creoCola =
        Provider.of<LineProvider>(context, listen: false).colaCreada;
    return OverflowBox(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.lightBlue, Color.fromRGBO(14, 30, 50, 1.7)])),
        width: double.infinity,
        height: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Flexible(
                    child: Text(
                      'Exportar Colas',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Flexible(
                  child: ElevatedButton(
                    child: Icon(
                      Icons.upload,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      await Provider.of<ClienteColaActivaProvider>(context,
                              listen: false)
                          .insertAllClienteColaActiva();
                      await Provider.of<ColasActivasProvider>(context,
                              listen: false)
                          .insertAllColasActivas();
                      await Provider.of<ProductosColasProvider>(context,
                              listen: false)
                          .insertAllproductosCola();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          duration: Duration(seconds: 2),
                          content: Text('Colas exportadas exitosamente')));
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(60, 60),
                      shape: const CircleBorder(),
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Cubacola',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                      color: Colors.white,
                    ),
                  ),
                  Consumer<LineProvider>(
                    builder: (context, value, child) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            child: Text('Cambiar Estados'),
                            onPressed: value.colaCreada ? () {} : null),
                      );
                    },
                    /*child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: ElevatedButton(
                        child: Text('Insertar clientes'),
                        onPressed: creoCola
                            ? () {
                                Provider.of<LineProvider>(context, listen: false)
                                    .setcolaCreada(creoCola);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    duration: Duration(seconds: 2),
                                    content: Text(
                                        'Recuerde agregar productos a la cola')));
                                Navigator.of(context).pushNamed('/lineform');
                              }
                            : null,
                      ),
                    ),*/
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Flexible(
                    child: Text('Crear subcola',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                Consumer<LineProvider>(
                  builder: (context, value, child) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Flexible(
                        child: ElevatedButton(
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          onPressed: value.colaCreada
                              ? () {
                                  setState(() {
                                    if (Provider.of<ClienteColaActivaProvider>(
                                                context,
                                                listen: false)
                                            .clienteColasActivas
                                            .length >
                                        0) {
                                      crearCola();
                                      if (crearListaClienteSubCola().isNotEmpty)
                                        _showDialog();
                                      else
                                        _showDialogSubColaSinCliente();
                                    } else {
                                      _showDialogSubColaSinCliente();
                                    }
                                  });
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(60, 60),
                            shape: const CircleBorder(),
                          ),
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertDialog() {
    if (listaClienteSucola!.length > 0) {
      return AlertDialog(
        title: Text('Iniciar Subcola'),
        content: Text(
            "¿Desea iniciar la subcola a partir de este cliente:${listaClienteSucola![0].nombre} )"),
        actions: <Widget>[
          ElevatedButton(
              child: Text("Aceptar"),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateColor.resolveWith((states) => Colors.blue)),
              onPressed: () {
                _showDialogSubColaProducto();
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
    } else
      return AlertSubcolaSinCliente(context: context);
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return _buildAlertDialog();
        });
  }

  void _showDialogSubColaSinCliente() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertSubcolaSinCliente(
            context: context,
          );
        });
  }

  void _showDialogSubColaProducto() {
    showDialog(
        context: context,
        builder: (context) {
          return _buildAlertDialogSelectProduct();
        });
  }

  Widget _buildAlertDialogSelectProduct() {
    return AlertDialog(
      title: Text('Seleccione los nuevos productos'),
      content: Text(
          "¿Seleccione los nuevos productos que variaron con respecto a la cola que estaba gestionando)"),
      actions: <Widget>[
        ElevatedButton(
            child: Text("Aceptar"),
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateColor.resolveWith((states) => Colors.blue)),
            onPressed: () {
              Navigator.of(context).pushNamed('/cubacola');
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
}

class AlertSubcolaSinCliente extends StatelessWidget {
  const AlertSubcolaSinCliente({
    Key? key,
    required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('No hay clientes que hayan comprado'),
      content: Text(
          "La cola que gestiona actualmente no tiene clientes que hayan comprado por lo que no tiene sentido crear subcola)"),
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
}
