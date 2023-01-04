import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:line_management/model/client.dart';
import 'package:line_management/model/cliente-colas-activas.dart';
import 'package:line_management/model/estados.dart';
import 'package:line_management/model/shop.dart';
import 'package:line_management/provider/GestionadorProvider.dart';
import 'package:line_management/provider/clientProvider.dart';
import 'package:line_management/provider/clientesColasActivasProvider.dart';
import 'package:line_management/provider/connectionProvider.dart';
import 'package:line_management/provider/lineProvider.dart';
import 'package:line_management/view/QRfinder.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../model/ClienteValidator.dart';
import '../provider/colasActivasProvider.dart';
import '../provider/munprovider.dart';

class Lineform extends StatefulWidget {
  Lineform({Key? key}) : super(key: key);

  @override
  State<Lineform> createState() => _LineformState();
}

class _LineformState extends State<Lineform> {
  List<ClienteValidator>? clientesVerify;
  final _nameTextController = TextEditingController();
  final _apellidotextController = TextEditingController();
  final _ciTextController = TextEditingController();

  @override
  void dispose() {
    _nameTextController.dispose();
    _apellidotextController.dispose();
    _ciTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Provider.of<GestionadorProvider>(context, listen: false)
        .cargarAllValidatorData();
    Provider.of<GestionadorProvider>(context, listen: false)
        .cargarValidatorDataHistorico();
    clientesVerify = Provider.of<GestionadorProvider>(context, listen: false)
        .clienteValidator;
    Provider.of<ConnectionProvider>(context, listen: false).getAllShops();
  }

  final formKey = GlobalKey<FormBuilderState>();
  bool validarCI(String? value) {
    if ((int.parse(value!.substring(0, 1)) > 4 ||
        int.parse(value.substring(0, 1)) == 0)) {
      if (int.parse(value.substring(2, 3)) == 0 ||
          int.parse(value.substring(2, 3)) == 1) {
        if (int.parse(value.substring(2, 3)) == 1) {
          if (int.parse(value.substring(3, 4)) == 1 ||
              int.parse(value.substring(3, 4)) == 2) {
            if ((int.parse(value.substring(4, 5)) == 0) ||
                int.parse(value.substring(4, 5)) == 1 ||
                int.parse(value.substring(4, 5)) == 2 ||
                int.parse(value.substring(4, 5)) == 3) {
              if (int.parse(value.substring(4, 5)) == 3) {
                if (int.parse(value.substring(5, 6)) == 0 ||
                    int.parse(value.substring(5, 6)) == 1) {
                  return true;
                }
              } else
                return true;
            } else
              return false;
          } else
            return false;
        } else
          return false;
      } else
        return false;
    } else
      return false;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    String ci;
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar Clientes'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: FormBuilder(
          key: formKey,
          child: ListView(
            children: [
              Center(
                child: Text(
                  'Registrar Clientes Manual',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w700,
                      fontSize: 16),
                ),
              ),
              Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FormBuilderTextField(
                        name: 'Nombre',
                        controller: _nameTextController,
                        decoration: const InputDecoration(labelText: 'Nombre'),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: 'No puede dejar campo vacio')
                        ]),
                      ),
                    ),
                  ),
                  Expanded(
                    child: FormBuilderTextField(
                      name: 'Apellidos',
                      controller: _apellidotextController,
                      decoration: const InputDecoration(labelText: 'Apellidos'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: 'No puede dejar campo vacio')
                      ]),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FormBuilderTextField(
                        name: 'Carnet de Identidad',
                        controller: _ciTextController,
                        decoration: const InputDecoration(
                            labelText: 'Carnet de Identidad'),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.numeric(
                              errorText:
                                  'El carnet de identidad debe tener valor numerico '),
                          FormBuilderValidators.minLength(11,
                              errorText:
                                  'El carnet de identidad debe tener 11 cifras'),
                          FormBuilderValidators.maxLength(11,
                              errorText:
                                  'El carnet de identidad debe tener 11 cifras'),
                        ]),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.saveAndValidate()) {
                        setState(() {
                          //ACTUALIZAR POSICION DE COLA ACTIVA
                          int posactiva = Provider.of<ColasActivasProvider>(
                                  context,
                                  listen: false)
                              .posColaActiva;
                          //OBTENER CANT DE COLAS ACTIVAS
                          int cantColasCreadas =
                              Provider.of<ColasActivasProvider>(context,
                                      listen: false)
                                  .colas
                                  .length;
                          //CREAR CLIENTE
                          int idCola = Provider.of<ColasActivasProvider>(
                                  context,
                                  listen: false)
                              .colas[posactiva]
                              .id;
                          ClienteColasActivas cliente = ClienteColasActivas(
                              ci: _ciTextController.text,
                              fv: '',
                              fecha_registro: DateTime.now().toIso8601String(),
                              fecha_modif: DateTime.now().toIso8601String(),
                              id_estado: Estados.estados[0].id,
                              id_cola: idCola,
                              nombre: _nameTextController.text +
                                  _apellidotextController.text,
                              id_municipio: Provider.of<MunicipioProvider>(
                                      context,
                                      listen: false)
                                  .idActive);

                          //ANADIR A LA LISTA
                          if (!Provider.of<GestionadorProvider>(context,
                                  listen: false)
                              .clienteValidator
                              .any((element) => element.ci == cliente.ci)) {
                            if (Provider.of<ClienteColaActivaProvider>(context,
                                    listen: false)
                                .addClienteColaActiva(cliente, idCola)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      duration: Duration(seconds: 2),
                                      content: Text(
                                          'Cliente registrado en la cola')));
                              _nameTextController.clear();
                              _apellidotextController.clear();
                              _ciTextController.clear();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      duration: Duration(seconds: 2),
                                      content: Text(
                                          'Cliente registrado recientemente')));
                              _nameTextController.clear();
                              _apellidotextController.clear();
                              _ciTextController.clear();
                            }
                          } else {
                            _showDialog(cliente);
                          }
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            duration: Duration(seconds: 2),
                            content: Text(
                                'Campos: nombres o apellidos, estan vacios,o CI incorrecto')));
                      }
                    },
                    child: Text('Enviar')),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(
                  thickness: 4,
                  height: 2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Center(
                  child: Text('Registrar Clientes Escaneando Código QR',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w700,
                          fontSize: 16)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const QRViewExample(),
                    ));
                  },
                  child: Text('Escanear'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlertDialog(ClienteColasActivas cliente) {
    String productos = '';
    ClienteValidator? clientereal;
    for (int i = 0;
        i <
            Provider.of<GestionadorProvider>(context, listen: false)
                .clienteValidator
                .length;
        i++) {
      if (cliente.ci ==
          Provider.of<GestionadorProvider>(context, listen: false)
              .clienteValidator
              .elementAt(i)
              .ci) {
        clientereal = Provider.of<GestionadorProvider>(context, listen: false)
            .clienteValidator
            .elementAt(i);
        productos += '' +
            Provider.of<GestionadorProvider>(context, listen: false)
                .clienteValidator
                .elementAt(i)
                .nombProducto +
            '/';
      }
    }
    print(productos);
    int idTienda = int.parse(clientereal!.idCola.toString().substring(0, 3));
    print(idTienda);
    String nombTiemda = Provider.of<ConnectionProvider>(context, listen: false)
        .nomShopId(idTienda);
    String fecha = '2' + clientereal.idCola.toString().substring(3, 8);
    String fechareal = fecha.substring(0, 2) +
        '/' +
        fecha.substring(2, 4) +
        '/' +
        fecha.substring(4, 6);

    return AlertDialog(
      title: Text('Cliente Encontrado en el Sistema'),
      content: Center(
        child: Column(
          children: [
            Text('CI: ${clientereal.ci}'),
            Text('Productos: $productos'),
            Text('Tienda: $nombTiemda'),
            Text('Fecha: $fechareal'),
            Text('Estado: ${Estados.getEstadoName(clientereal.idEstado)}')
          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
            child: Text("Aceptar"),
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateColor.resolveWith((states) => Colors.blue)),
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
              Provider.of<ClienteColaActivaProvider>(context, listen: false)
                  .addClienteColaActiva(clienteRech, clienteRech.id_cola);
              Navigator.of(context).pop();
            }),
        ElevatedButton(
            child: Text("Rechazar"),
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateColor.resolveWith((states) => Colors.red)),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ],
    );
  }

  void _showDialog(ClienteColasActivas cliente) {
    showDialog(
        context: context,
        builder: (context) {
          return _buildAlertDialog(cliente);
        });
  }
}

//clase para acceder a la camara y poder escanear

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  List<ClienteValidator>? clientesVerify;
  late Cliente cliente;
  bool info = true;
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void initState() {
    super.initState();
    Provider.of<GestionadorProvider>(context, listen: false)
        .cargarAllValidatorData();
    clientesVerify = Provider.of<GestionadorProvider>(context, listen: false)
        .clienteValidator;
  }

  void _showDialog(ClienteColasActivas cliente) {
    showDialog(
        context: context,
        builder: (context) {
          return _buildAlertDialog(cliente);
        });
  }

  @override
  Widget build(BuildContext context) {
    ClienteColasActivas? cliente;
    if (result != null && info) {
      //ACTUALIZAR POSICION DE COLA ACTIVA

      int posactiva = Provider.of<ColasActivasProvider>(context, listen: false)
          .posColaActiva;
      List<String> datos =
          Provider.of<ClienteColaActivaProvider>(context, listen: false)
              .getQRCode(result!.code!.toLowerCase());
      int idCola = Provider.of<ColasActivasProvider>(context, listen: false)
          .colas[posactiva]
          .id;
      cliente = ClienteColasActivas(
          ci: datos[1],
          fv: datos[2],
          fecha_registro: DateTime.now().toIso8601String(),
          fecha_modif: DateTime.now().toIso8601String(),
          id_estado: Estados.estados[0].id,
          id_cola: idCola,
          nombre: datos[0],
          id_municipio:
              Provider.of<MunicipioProvider>(context, listen: false).idActive);
      if (!clientesVerify!
          .any((element) => int.parse(element.ci) == int.parse(cliente!.ci))) {
        Future.delayed(Duration.zero, () {
          Provider.of<ClienteColaActivaProvider>(context, listen: false)
              .addClienteColaActiva(cliente!, idCola);
        });
      } else {
        Future.delayed(Duration.zero, () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => QRFind(
                        cliente: cliente,
                        clientesVerify: clientesVerify,
                        nombTiemda:
                            Provider.of<LineProvider>(context, listen: false)
                                .nomTienda,
                      )));
        });
      }

      info = false;
    }
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Text(
                        'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code} ')
                  else
                    const Text('Escanea Código'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.toggleFlash();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getFlashStatus(),
                              builder: (context, snapshot) {
                                return Text('Flash: ${snapshot.data}');
                              },
                            )),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.flipCamera();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getCameraInfo(),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  return Text(
                                      'Camera facing ${describeEnum(snapshot.data!)}');
                                } else {
                                  return const Text('loading');
                                }
                              },
                            )),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.pauseCamera();
                          },
                          child: const Text('Pausa la cámara',
                              style: TextStyle(fontSize: 20)),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.resumeCamera();
                          },
                          child: const Text('Continuar',
                              style: TextStyle(fontSize: 20)),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Widget _buildAlertDialog(ClienteColasActivas cliente) {
    String productos = '';
    ClienteValidator? clientereal;
    for (int i = 0; i < clientesVerify!.length; i++) {
      if (cliente.ci == clientesVerify!.elementAt(i).ci &&
          cliente.id_cola == clientesVerify!.elementAt(i).idCola) {
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

    return AlertDialog(
      title: Text('Cliente Encontrado en el Sistema'),
      content: Center(
        child: Column(
          children: [
            Text('CI: ${clientereal.ci}'),
            Text('Productos: $productos'),
            Text('Tienda: $idTienda'),
            Text('Fecha: $fechareal'),
            Text('Estado: ${Estados.getEstadoName(clientereal.idEstado)}')
          ],
        ),
      ),
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
            child: Text("Rechazar"),
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
