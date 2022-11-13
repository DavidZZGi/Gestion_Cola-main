import 'package:flutter/material.dart';
import 'package:line_management/model/line.dart';
import 'package:line_management/provider/connectionProvider.dart';
import 'package:line_management/provider/shopProvider.dart';
import 'package:provider/provider.dart';

import '../provider/lineProvider.dart';

// ignore: must_be_immutable
class UpScreenPart extends StatelessWidget {
  String estado = 'Sincronizado';
  DateTime time = DateTime.now();

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
                    onPressed: () {
                      int construirIdCola(int cantDeColasCreadas) {
                        String date =
                            Provider.of<LineProvider>(context, listen: false)
                                .getSixDigitDate()
                                .toString();
                        String codInit = '00';
                        int idShop = Provider.of<ConnectionProvider>(context,
                                listen: false)
                            .idNomShop(Provider.of<LineProvider>(context,
                                    listen: false)
                                .nomTienda);
                        String idStrShop = idShop.toString();
                        String idCola = idStrShop + date + codInit;
                        int result = int.parse(idCola);
                        result += cantDeColasCreadas;
                        cantDeColasCreadas++;
                        return result;
                      }

                      Line exportableLine = Line(
                          id: construirIdCola(
                              Provider.of<LineProvider>(context, listen: false)
                                  .cantColasCreadas),
                          idMun:
                              Provider.of<LineProvider>(context, listen: false)
                                  .munSelected,
                          nomProducts:
                              Provider.of<LineProvider>(context, listen: false)
                                  .productos,
                          clients:
                              Provider.of<LineProvider>(context, listen: false)
                                  .clientes,
                          idTienda:
                              Provider.of<LineProvider>(context, listen: false)
                                  .nomTienda,
                          date: DateTime.now());
                      print(exportableLine.clients);
                      print(exportableLine.idMun);
                      print(exportableLine.nomProducts);
                      print(exportableLine.idTienda);
                      print(exportableLine.id);
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
                            child: Text('Insertar clientes'),
                            onPressed: value.colaCreada
                                ? () {
                                    Navigator.of(context)
                                        .pushNamed('/lineform');
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
                  padding: const EdgeInsets.all(8.0),
                  child: Flexible(
                    child: Text('Crear subcola',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                Flexible(
                  child: ElevatedButton(
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/subcola');
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(60, 60),
                      shape: const CircleBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
