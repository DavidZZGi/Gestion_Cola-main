import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:line_management/model/client.dart';
import 'package:line_management/provider/clientProvider.dart';
import 'package:line_management/provider/connectionProvider.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class Lineform extends StatefulWidget {
  Lineform({Key? key}) : super(key: key);

  @override
  State<Lineform> createState() => _LineformState();
}

class _LineformState extends State<Lineform> {
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

  final formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
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
                        validator: FormBuilderValidators.compose([]),
                      ),
                    ),
                  ),
                  Expanded(
                    child: FormBuilderTextField(
                      name: 'Apellidos',
                      controller: _apellidotextController,
                      decoration: const InputDecoration(labelText: 'Apellidos'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: FormBuilderValidators.compose([]),
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
                          FormBuilderValidators.numeric(),
                          FormBuilderValidators.minLength(11),
                          FormBuilderValidators.maxLength(11),
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
                      /*   if (_nameTextController.value.text.isNotEmpty &&
                          _apellidotextController.value.text.isNotEmpty &&
                          _ciTextController.value.text.isNotEmpty) {
                        Provider.of<ClienteProvider>(context, listen: false)
                            .addCliente(Cliente(
                                carnetIdentidad: _ciTextController.text,
                                nombre: _nameTextController.text,
                                apellidos: _apellidotextController.text));
                        Provider.of<ConnectionProvider>(context, listen: false)
                            .createCliente(Cliente(
                                carnetIdentidad: _ciTextController.text,
                                nombre: _nameTextController.text,
                                apellidos: _apellidotextController.text));
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Cliente insertado en la cola')));
                        _nameTextController.clear();
                        _apellidotextController.clear();
                        _ciTextController.clear();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('No puede dejar campos vacios')));
                      }*/
                      if (formKey.currentState!.saveAndValidate()) {
                        /*  Provider.of<ClienteProvider>(context, listen: false)
                            .addCliente(Cliente(
                                carnetIdentidad: _ciTextController.text,
                                nombre: _nameTextController.text,
                                apellidos: _apellidotextController.text));*/
                        Provider.of<ConnectionProvider>(context, listen: false)
                            .insertClienteEnBDLimpa(Cliente(
                                carnetIdentidad: _ciTextController.text,
                                nombre: _nameTextController.text,
                                apellidos: _apellidotextController.text));
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Cliente insertado en la cola')));
                        _nameTextController.clear();
                        _apellidotextController.clear();
                        _ciTextController.clear();
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
}
//clase para acceder a la camara y poder escanear

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
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
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (result != null && info) {
      cliente = Provider.of<ClienteProvider>(context, listen: false)
          .stringToCliente(result!.code!.toLowerCase());
      Provider.of<ClienteProvider>(context, listen: false).addCliente(cliente);
      Provider.of<ConnectionProvider>(context, listen: false)
          .createCliente(cliente);
      print(cliente);
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
                        'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
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
}
