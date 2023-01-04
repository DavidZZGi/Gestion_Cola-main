import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:line_management/model/cliente-colas-activas.dart';
import 'package:line_management/model/colas-activas.dart';
import 'package:line_management/model/line.dart';
import 'package:line_management/model/productos-colas.dart';
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

  bool ActiveConnection = false;
  String T = "";
  Future<bool> checkUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      ActiveConnection = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 2), content: Text('No hay internet')));
      return false;
    }
    return false;
  }

  void insertarAllProductoServidor() async {
    for (var element
        in Provider.of<ProductosColasProvider>(context, listen: false)
            .productosCola) {
      await Provider.of<ProductosColasProvider>(context, listen: false)
          .insertarProductoColaEnServidor(element);
    }
  }

  void insertarAllColasServidor() async {
    for (var element
        in Provider.of<ColasActivasProvider>(context, listen: false).colas) {
      await Provider.of<ColasActivasProvider>(context, listen: false)
          .insertColaActivaServer(element);
    }
  }

  void insertarAllClientesServidor() async {
    for (var element
        in Provider.of<ClienteColaActivaProvider>(context, listen: false)
            .clienteColasActivas) {
      await Provider.of<ClienteColaActivaProvider>(context, listen: false)
          .createClienteColaServer(element);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool creoCola =
        Provider.of<LineProvider>(context, listen: false).colaCreada;

    Provider.of<ClienteColaActivaProvider>(context, listen: false)
        .clienteColasActivas
        .length;

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
                      'Exportar',
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
                      if (Provider.of<ProductosColasProvider>(context,
                                  listen: false)
                              .productosCola
                              .length >
                          0) {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    leading: Icon(Icons
                                        .signal_cellular_connected_no_internet_4_bar_outlined),
                                    title: Text(
                                        'Exportar base de dato sin conexion'),
                                    onTap: () async {
                                      await Provider.of<
                                                  ClienteColaActivaProvider>(
                                              context,
                                              listen: false)
                                          .insertAllClienteColaActiva();
                                      await Provider.of<
                                                  ClienteColaActivaProvider>(
                                              context,
                                              listen: false)
                                          .insertAllClienteColaActivaHistorico();
                                      await Provider.of<ColasActivasProvider>(
                                              context,
                                              listen: false)
                                          .insertAllColasActivas();
                                      await Provider.of<ProductosColasProvider>(
                                              context,
                                              listen: false)
                                          .insertAllproductosCola();
                                      await Provider.of<ProductosColasProvider>(
                                              context,
                                              listen: false)
                                          .insertAllproductosColaDelDia();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              duration: Duration(seconds: 2),
                                              content: Text(
                                                  'Colas exportadas localmente con exito')));
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.signal_wifi_4_bar),
                                    title:
                                        Text('Exportar base de dato a la nube'),
                                    onTap: () {
                                      insertarAllProductoServidor();
                                      insertarAllClientesServidor();
                                      insertarAllColasServidor();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              duration: Duration(seconds: 2),
                                              content: Text(
                                                  'Colas exportadas exitosamente')));
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            });

                        /*
                     
                          */
                      }
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
                    'Cola.cu',
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
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              fixedSize: const Size(85, 70),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(child: Text('Subcola')),
                                Flexible(child: Icon(Icons.add))
                              ],
                            ),
                            onPressed: value.colaCreada
                                ? () {
                                    setState(() {
                                      if ((!Provider.of<
                                                  ClienteColaActivaProvider>(
                                              context,
                                              listen: false)
                                          .clienteColasActivas
                                          .any((element) =>
                                              element.id_estado == 4))) {
                                        _showDialogSubColaSinCliente();
                                      } else if (Provider.of<
                                                      ClienteColaActivaProvider>(
                                                  context,
                                                  listen: false)
                                              .clienteColasActivas
                                              .any((element) =>
                                                  element.id_estado == 4) &&
                                          Provider.of<ClienteColaActivaProvider>(
                                                  context,
                                                  listen: false)
                                              .clienteColasActivas
                                              .any((element) =>
                                                  element.id_estado == 1)) {
                                        _showDialog(
                                            _buildAlertDialogCrearSubola());
                                      }
                                    });
                                  }
                                : null),
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
                    child: Text('Importar',
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
                            Icons.download,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      ListTile(
                                        leading: Icon(Icons
                                            .signal_cellular_connected_no_internet_4_bar_outlined),
                                        title: Text(
                                            'Importar base de dato sin conexion de almacenamiento'),
                                        onTap: () async {
                                          FilePickerResult? result =
                                              await FilePicker.platform
                                                  .pickFiles();
                                          if (result !=
                                              null) if (result.count == 1)
                                            Provider.of<ConnectionProvider>(
                                                    context,
                                                    listen: false)
                                                .updateBD(result.paths[0]);
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(Icons
                                            .signal_cellular_connected_no_internet_0_bar),
                                        title: Text(
                                            'Importar base de dato sin conexion de dia anterior'),
                                        onTap: () async {
                                          Provider.of<ColasActivasProvider>(
                                                  context,
                                                  listen: false)
                                              .importarColasActivasLocal();
                                          Provider.of<ColasActivasProvider>(
                                                  context,
                                                  listen: false)
                                              .setPosColaActiva(Provider.of<
                                                          ColasActivasProvider>(
                                                      context,
                                                      listen: false)
                                                  .colas
                                                  .length);
                                          Provider.of<ProductosColasProvider>(
                                                  context,
                                                  listen: false)
                                              .importarProductosColasLocal();
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.signal_wifi_4_bar),
                                        title: Text(
                                            'Importar base de dato de la nube'),
                                        onTap: () {
                                          Provider.of<ColasActivasProvider>(
                                                  context,
                                                  listen: false)
                                              .importarColasActivas();
                                          Provider.of<ClienteColaActivaProvider>(
                                                  context,
                                                  listen: false)
                                              .importarClientes();
                                          Provider.of<ProductosColasProvider>(
                                                  context,
                                                  listen: false)
                                              .importarProductosColas();
                                          Provider.of<ColasActivasProvider>(
                                                  context,
                                                  listen: false)
                                              .setPosColaActiva(Provider.of<
                                                          ColasActivasProvider>(
                                                      context,
                                                      listen: false)
                                                  .colas
                                                  .length);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  duration:
                                                      Duration(seconds: 2),
                                                  content: Text(
                                                      'Colas importadas exitosamente')));
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  );
                                });
                          },
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
  }

  void _showDialog(Widget widget) {
    showDialog(
        context: context,
        builder: (context) {
          return widget;
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

  Widget _buildAlertDialogCrearSubola() {
    return AlertDialog(
      title: Text('Esta seguro que desea crear una subcola'),
      actions: <Widget>[
        ElevatedButton(
            child: Text("Aceptar"),
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateColor.resolveWith((states) => Colors.blue)),
            onPressed: () {
              crearCola();
              if (crearListaClienteSubCola().isNotEmpty)
                _showDialog(_buildAlertDialog());
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
