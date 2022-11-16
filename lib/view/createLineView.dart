import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_management/model/colas-activas.dart';
import 'package:line_management/provider/colasActivasProvider.dart';
import 'package:line_management/provider/munprovider.dart';
import 'package:line_management/view/shopDropdown.dart';
import 'package:provider/provider.dart';

import '../provider/connectionProvider.dart';
import '../provider/lineProvider.dart';
import '../provider/shopProvider.dart';
import 'mundropdown.dart';

class CreateLineWidget extends StatefulWidget {
  CreateLineWidget({Key? key}) : super(key: key);

  @override
  State<CreateLineWidget> createState() => _CreateLineWidgetState();
}

class _CreateLineWidgetState extends State<CreateLineWidget> {
  bool munSelected = false;
  bool creoCola = false;
  int construirIdCola(int cantDeColasCreadas) {
    String date = Provider.of<LineProvider>(context, listen: false)
        .getSixDigitDate()
        .toString();
    String codInit = '00';
    int idShop = Provider.of<ConnectionProvider>(context, listen: false)
        .idNomShop(Provider.of<LineProvider>(context, listen: false).nomTienda);
    String idStrShop = idShop.toString();
    String idCola = idStrShop + date + codInit;
    int result = int.parse(idCola);
    result += cantDeColasCreadas;
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Crear cola',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
      body: Center(
        child: Container(
          color: Colors.lightBlue[200],
          padding: EdgeInsets.all(12.0),
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: ListView(
              children: [
                createBox(
                    Text(
                      'La habana',
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                    Text(
                      'Provincia',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    )),
                SizedBox(
                  height: 10,
                ),
                containerGradiente(DropdownMun(), 'Seleccionar municipio'),
                SizedBox(
                  height: 10,
                ),
                containerGradiente(ShopDropdown(), 'Seleccionar tienda'),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: ElevatedButton(
                      style: ButtonStyle(),
                      onPressed: () {
                        bool selectShop =
                            Provider.of<ShopProvider>(context, listen: false)
                                .shopSelected;
                        munSelected = Provider.of<MunicipioProvider>(context,
                                listen: false)
                            .selectedValue;
                        if (munSelected && selectShop) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: Duration(seconds: 2),
                              content: Text('Cola creada satisfactoriamente')));
                          creoCola = true;
                          Provider.of<LineProvider>(context, listen: false)
                              .setcolaCreada(creoCola);
                          Provider.of<LineProvider>(context, listen: false)
                              .clientes
                              .clear();
                          //Creando el objeto Cola Activa
                          int idTienda = Provider.of<ConnectionProvider>(
                                  context,
                                  listen: false)
                              .idNomShop(Provider.of<LineProvider>(context,
                                      listen: false)
                                  .nomTienda);
                          int cantColasCreadas =
                              Provider.of<ColasActivasProvider>(context,
                                      listen: false)
                                  .colas
                                  .length;
                          ColaAciva cola = ColaAciva(
                              id: construirIdCola(cantColasCreadas),
                              idTienda: idTienda,
                              fecha: DateTime.now());
                          Provider.of<ColasActivasProvider>(context,
                                  listen: false)
                              .colas
                              .add(cola);
                          print(cola.id);
                          print(cola.idTienda);
                          print(cola.fecha);
                        } else if (!munSelected && selectShop) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: Duration(seconds: 2),
                              content:
                                  Text('Tiene que selecionar un municipio')));
                        } else if (munSelected && !selectShop) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: Duration(seconds: 2),
                              content:
                                  Text('Tiene que selecionar una tienda')));
                        } else if (!munSelected && !selectShop) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: Duration(seconds: 2),
                              content: Text(
                                  'Tiene que selecionar un municipio y una tienda')));
                        }
                      },
                      child: Text('Crear Cola')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget containerGradiente(Widget child, String text) {
    return Container(
      padding: EdgeInsets.all(12.0),
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Colors.lightBlue, Color.fromRGBO(14, 30, 50, 1.7)]),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          '$text',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        child
      ]),
    );
  }

  Widget createBox(name, subname) {
    return SizedBox(
        width: 300,
        height: 80,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.lightBlue, Color.fromRGBO(14, 30, 50, 1.7)]),
          ),
          child: ListTile(
            title: subname,
            subtitle: name,
          ),
        ));
  }
}
