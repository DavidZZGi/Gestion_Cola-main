import 'package:flutter/material.dart';
import 'package:line_management/model/productos-colas.dart';
import 'package:line_management/provider/productosColasProvider.dart';
import 'package:provider/provider.dart';

import '../provider/colasActivasProvider.dart';
import '../provider/connectionProvider.dart';

class ProductSelected extends StatefulWidget {
  ProductSelected({Key? key}) : super(key: key);

  @override
  State<ProductSelected> createState() => _ProductSelectedState();
}

class _ProductSelectedState extends State<ProductSelected> {
  int? posCola;
  int? idColaActiva;
  @override
  void initState() {
    super.initState();
    Provider.of<ConnectionProvider>(context, listen: false).getAllProducts();
    posCola =
        Provider.of<ColasActivasProvider>(context, listen: false).posColaActiva;
    print(posCola);
    idColaActiva = Provider.of<ColasActivasProvider>(context, listen: false)
        .colas[posCola!]
        .id;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductosColasProvider>(
      builder: (context, value, child) {
        List<ProductosColas> productos =
            value.develverProductosDadoIdCola(idColaActiva!);
        return ListView.builder(
            padding: EdgeInsets.all(6),
            itemCount: productos.length,
            itemBuilder: (context, i) {
              return Dismissible(
                background: Container(
                  child: Center(
                      child: Text(
                    'Eliminar',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  )),
                  color: Colors.red,
                ),
                key: ValueKey<String>(productos[i].nombreProducto!),
                onDismissed: (DismissDirection direction) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text(
                          '${productos[i].nombreProducto!} fue removido de la cola')));
                  setState(() {
                    Provider.of<ProductosColasProvider>(context, listen: false)
                        .removeProductoCola(productos[i]);
                  });
                },
                child: Card(
                  elevation: 5.0,
                  color: Color.fromARGB(255, 49, 138, 179),
                  child: ListTile(
                    leading: Icon(
                      Icons.fastfood,
                      size: 30,
                      color: Colors.black,
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${productos[i].nombreProducto!}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black45,
                              fontSize: 18.0),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
      },
    );
  }
}
