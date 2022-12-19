import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:line_management/model/Product.dart';
import 'package:line_management/model/municipio.dart';
import 'package:line_management/model/productos-colas.dart';

import 'package:line_management/provider/clientesColasActivasProvider.dart';
import 'package:line_management/provider/colasActivasProvider.dart';

import 'package:line_management/provider/lineProvider.dart';
import 'package:line_management/provider/munprovider.dart';
import 'package:line_management/provider/productProvider.dart';
import 'package:line_management/provider/productosColasProvider.dart';

import 'package:line_management/view/productsSelected.dart';

import 'package:provider/provider.dart';
import '../model/shop.dart';
import '../provider/connectionProvider.dart';
import 'listviewcomponent.dart';

class MyTapBar extends StatefulWidget {
  const MyTapBar({Key? key}) : super(key: key);

  @override
  _MyTapBarState createState() => _MyTapBarState();
}

class _MyTapBarState extends State<MyTapBar> {
  bool munSelected = false;
  bool tiendaSelected = false;
  late Future<List<Municipio>> municipios;
  late Future<List<Shop>> shops;
  late Future<String> fecha;
  late int posActiva;
  bool creoCola = false;
  //late Future<List> shops;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Color.fromARGB(185, 58, 112, 128),
          //shadowColor: Colors.grey,
          title: FutureBuilder<String>(
            future: fecha,
            builder: (context, snapshot) {
              Provider.of<ColasActivasProvider>(context, listen: false)
                  .setFecha(snapshot.data);
              return Text('${snapshot.data}');
            },
          ),

          bottom: TabBar(
            indicatorWeight: 8.0,
            indicatorColor: Colors.grey[850],
            tabs: <Widget>[
              Tab(
                text: 'Crear Cola',
                icon: Icon(Icons.add_box_outlined),
              ),
              Tab(
                text: 'Productos',
                icon: Icon(Icons.fastfood),
              ),
              Tab(
                text: 'Clientes',
                icon: Icon(Icons.person),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            //First tap item
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/createline');
                      },
                      child: Icon(Icons.add),
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(60, 60),
                        shape: const CircleBorder(),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Consumer<ColasActivasProvider>(
                      builder: (context, value, child) {
                        return ListView.builder(
                          itemCount: value.colas.length,
                          itemBuilder: (context, index) {
                            return Dismissible(
                              background: Container(
                                child: Center(
                                    child: Text(
                                  'Eliminar',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                )),
                                color: Colors.red,
                              ),
                              key: ValueKey<int>(value.colas[index].id),
                              onDismissed: (DismissDirection direction) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    duration: Duration(seconds: 2),
                                    content: Text(
                                        'La cola ${value.colas[index].id} fue eliminada')));
                                setState(() {
                                  Provider.of<ProductosColasProvider>(context,
                                          listen: false)
                                      .removeTodosProductoColaByIdCola(
                                          value.colas[index].id);
                                  Provider.of<ClienteColaActivaProvider>(
                                          context,
                                          listen: false)
                                      .removeTodosClienteColaActiva(
                                          value.colas[index].id);
                                  value.colas.remove(value.colas[index]);
                                  value.setPosColaActiva(
                                      value.posColaActiva - 1);
                                });
                              },
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    Provider.of<ClienteColaActivaProvider>(
                                            context,
                                            listen: false)
                                        .develverClientesDadoIdColaSubList(
                                            value.colas[index].id);

                                    int posColaActiva =
                                        Provider.of<ColasActivasProvider>(
                                                context,
                                                listen: false)
                                            .colas
                                            .length;

                                    for (int i = 0;
                                        i <
                                            Provider.of<ColasActivasProvider>(
                                                    context,
                                                    listen: false)
                                                .colas
                                                .length;
                                        i++) {
                                      if (Provider.of<ColasActivasProvider>(
                                                  context,
                                                  listen: false)
                                              .colas
                                              .elementAt(i)
                                              .isSelected ==
                                          true) {
                                        Provider.of<ColasActivasProvider>(
                                                context,
                                                listen: false)
                                            .colas
                                            .elementAt(i)
                                            .setIsSelected(false);
                                      }
                                    }

                                    value.colas[index].setIsSelected(true);
                                    Provider.of<ColasActivasProvider>(context,
                                            listen: false)
                                        .setPosColaActiva(index);
                                  });
                                },
                                child: Card(
                                  color: Colors.lightBlue,
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.person_add_disabled_rounded,
                                      color: value.colas[index].isSelected
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                                    title: Text('${value.colas[index].id}'),
                                    subtitle: Text(
                                        '${value.colas[index].nombTienda}'),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            //Second Tab item

            Consumer<ColasActivasProvider>(
              builder: (context, value, child) {
                if (value.colas.length > 0) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: ProductSelected()),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            child: Icon(Icons.add),
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(60, 60),
                              shape: const CircleBorder(),
                            ),
                            onPressed: value.colas.length > 0
                                ? () {
                                    Navigator.of(context)
                                        .pushNamed('/productsearch');
                                  }
                                : null),
                      ),
                    ],
                  );
                } else
                  return Container();
              },
            ),

            //Third tab item
            Consumer<ColasActivasProvider>(
              builder: (context, value, child) {
                if (value.colas.length > 0) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: MylistView()),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                child: Icon(Icons.add),
                                style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(60, 60),
                                  shape: const CircleBorder(),
                                ),
                                onPressed: value.colas.length > 0
                                    ? () {
                                        Navigator.of(context)
                                            .pushNamed('/lineform');
                                      }
                                    : null),
                          ),
                          Consumer<ClienteColaActivaProvider>(
                            builder: (context, value, child) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                    child: Icon(Icons.shopping_cart),
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: const Size(60, 60),
                                      shape: const CircleBorder(),
                                    ),
                                    onPressed: value
                                                .clienteColasActivas.length >
                                            0
                                        ? () {
                                            bool encontro = false;
                                            for (int i = 0;
                                                i <
                                                        value
                                                            .clienteColasActivas
                                                            .length &&
                                                    !encontro;
                                                i++) {
                                              if (value.clienteColasActivas
                                                      .elementAt(i)
                                                      .id_cola ==
                                                  Provider.of<ColasActivasProvider>(
                                                          context,
                                                          listen: false)
                                                      .colas[Provider.of<
                                                                  ColasActivasProvider>(
                                                              context,
                                                              listen: false)
                                                          .posColaActiva]
                                                      .id) {
                                                if (value.clienteColasActivas
                                                        .elementAt(i)
                                                        .id_estado ==
                                                    1) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          duration: Duration(
                                                              seconds: 2),
                                                          content: Text(
                                                              '${value.clienteColasActivas[i].nombre} acaba de comprar')));
                                                  setState(() {
                                                    value.clienteColasActivas
                                                        .elementAt(i)
                                                        .setIdEstado(4);
                                                    encontro = true;
                                                  });
                                                }
                                              }
                                            }
                                          }
                                        : null),
                              );
                            },
                          )
                        ],
                      ),
                    ],
                  );
                } else
                  return Container();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget shopsListView() {
    return FutureBuilder<List>(
        future: shops,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, i) {
                  return getCard(snapshot.data![i]);
                });
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          return CircularProgressIndicator();
        });
  }

  Widget getCard(index) {
    var id = index['id'];
    var nombre = index['nombre'];
    var idMun = index['id_municipio'];
    var activa = index['activa'];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ListTile(
          title: Row(
            children: [
              Container(
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(60 / 2)),
              ),
              SizedBox(width: 20.0),
              Column(
                children: [
                  Text(
                    id.toString(),
                    style: TextStyle(fontSize: 30),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(nombre.toString()),
                  SizedBox(
                    height: 10,
                  ),
                  Text(idMun.toString()),
                  SizedBox(
                    height: 10,
                  ),
                  Text(activa.toString()),
                ],
              )
            ],
          ),
        ),
      ),
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

  Widget containerNormal(Widget child) {
    return Container(
      padding: EdgeInsets.all(12.0),
      height: 70,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Colors.lightBlue, Color.fromRGBO(1, 35, 50, 1.2)]),
      ),
      child: child,
    );
  }

  @override
  void initState() {
    super.initState();
    municipios = Provider.of<ConnectionProvider>(context, listen: false)
        .getAllMunicipios();

    Provider.of<MunicipioProvider>(context, listen: false)
        .initMunicipios(municipios);
    shops =
        Provider.of<ConnectionProvider>(context, listen: false).getAllShops();

    fecha =
        Provider.of<ColasActivasProvider>(context, listen: false).getFecha();
    posActiva =
        Provider.of<ColasActivasProvider>(context, listen: false).posColaActiva;
  }
}

//Search Bar
class ProductSearchBar extends StatefulWidget {
  @override
  _ProductSearchBarState createState() => _ProductSearchBarState();
}

class _ProductSearchBarState extends State<ProductSearchBar> {
  late Future<List<Product>> products;
  List<Product> listAux = [];
  List<String> nombPred = [];
  int? posColaActiva;
  int? idColaActiva;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    products = Provider.of<ConnectionProvider>(context, listen: false)
        .getAllProducts();
    listAux = Provider.of<ConnectionProvider>(context, listen: false).products;
  }
/*
  bool actualizarEstadosSeleccionados(int idCola, int index, int idPro) {
    for (int i = 0;
        i < Provider.of<ProductosColasProvider>(context).productosCola.length;
        i++) {
      if (Provider.of<ProductosColasProvider>(context)
                  .productosCola[i]
                  .idCola ==
              idCola &&
          Provider.of<ProductosColasProvider>(context)
                  .productosCola[i]
                  .idProducto ==
              idPro) {
        return true;
      }
    }
    return false;
  }

  void initListaNombre() {
    nombPred = listAux.map((e) => e.productName).toList();
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seleccione los productos'),
      ),
      body: FutureBuilder<List>(
          future: products,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length, //nombPred.length
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(5),
                    child: Container(
                      height: 70,
                      color: Colors.blue,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Icon(
                              Icons.fastfood,
                              size: 30,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            '${snapshot.data![index].productName}',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Flexible(
                            child: CheckboxListTile(
                              value: snapshot.data![index].isSelected,
                              onChanged: (bool? newvalue) {
                                setState(() {
                                  snapshot.data![index].setIsSelected(newvalue);

                                  ///Setear en producto si esta seleccionado
                                  if (newvalue == true) {
                                    Provider.of<ConnectionProvider>(context,
                                            listen: false)
                                        .products[index]
                                        .setIsSelected(newvalue);
                                    print(newvalue);

                                    ///Setear en producto cola
                                    int posColaActiva =
                                        Provider.of<ColasActivasProvider>(
                                                context,
                                                listen: false)
                                            .posColaActiva;

                                    int idCola =
                                        Provider.of<ColasActivasProvider>(
                                                context,
                                                listen: false)
                                            .colas[posColaActiva]
                                            .id;
                                    ProductosColas productoElegidos =
                                        ProductosColas(
                                            id_cola: idCola,
                                            id_producto:
                                                snapshot.data![index].id);
                                    productoElegidos.setnombreProducto(
                                        snapshot.data![index].productName);
                                    Provider.of<ProductosColasProvider>(context,
                                            listen: false)
                                        .addProductoCola(
                                            productoElegidos, idCola);
                                  } else {
                                    Provider.of<ProductosColasProvider>(context,
                                            listen: false)
                                        .removeProductoColaByName(
                                            snapshot.data![index].productName);
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );

                  /* ListTile(
                    leading: Icon(
                      Icons.fastfood,
                      size: 30,
                      color: Colors.black,
                    ),
                    title: Text(
                      '${snapshot.data![index].productName}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: CheckboxListTile(
                        value: snapshot.data![index].isSelected,
                        onChanged: (bool? newvalue) {
                          setState(() {
                            snapshot.data![index].setIsSelected(newvalue);

                            ///Setear en producto si esta seleccionado
                            if (newvalue == true) {
                              Provider.of<ConnectionProvider>(context,
                                      listen: false)
                                  .products[index]
                                  .setIsSelected(newvalue);
                              print(newvalue);

                              ///Setear en producto cola
                              int posColaActiva =
                                  Provider.of<ColasActivasProvider>(context,
                                          listen: false)
                                      .posColaActiva;

                              int idCola = Provider.of<ColasActivasProvider>(
                                      context,
                                      listen: false)
                                  .colas[posColaActiva]
                                  .id;
                              ProductosColas productoElegidos = ProductosColas(
                                  idCola: idCola,
                                  idProducto: snapshot.data![index].id);
                              productoElegidos.setnombreProducto(
                                  snapshot.data![index].productName);
                              Provider.of<ProductosColasProvider>(context,
                                      listen: false)
                                  .addProductoCola(productoElegidos, idCola);
                            } else {
                              Provider.of<ProductosColasProvider>(context,
                                      listen: false)
                                  .removeProductoColaByName(
                                      snapshot.data![index].productName);
                            }
                          });
                        }),
                  );*/
                },
              );
            } else
              return CircularProgressIndicator();
          }),
    );
  }
}

class Home extends StatefulWidget {
  //`createState()` will create the mutable state for this widget at
  //a given location in the tree.
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _searchview = TextEditingController();
  late Future<List<Product>> products;
  late Future<List<ProductosColas>> productsDeUnaCola;
  bool _firstSearch = true;
  String _query = "";
  //late Future<List<Product>> products;
  List<String> _nebulae = [];
  List<String> _filterList = [];

  @override
  void initState() {
    super.initState();
    products = Provider.of<ConnectionProvider>(context, listen: false)
        .getAllProducts();
    Provider.of<ProductProvider>(context, listen: false).initProduct(products);
  }

  _HomeState() {
    //Register a closure to be called when the object changes.
    _searchview.addListener(() {
      if (_searchview.text.isEmpty) {
        //Notify the framework that the internal state of this object has changed.
        setState(() {
          _firstSearch = true;
          _query = "";
        });
      } else {
        setState(() {
          _firstSearch = false;
          _query = _searchview.text;
        });
      }
    });
  }

//Build our Home widget
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      child: Column(
        children: <Widget>[
          _createSearchView(),
          _firstSearch ? _performSearch() : _createListView(0),
        ],
      ),
    );
  }

  //Create a SearchView
  Widget _createSearchView() {
    return Container(
      decoration: BoxDecoration(border: Border.all(width: 1.0)),
      child: TextField(
        controller: _searchview,
        decoration: InputDecoration(
          hintText: "Agrege los productos de la cola",
          hintStyle: TextStyle(color: Color.fromARGB(255, 90, 90, 90)),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _createListView(int idCola) {
    return Consumer<ProductosColasProvider>(
      builder: (context, value, child) {
        return Flexible(
          child: ListView.builder(
              itemCount: value
                  .develverProductosDadoIdCola(idCola)
                  .length, //products.length,

              itemBuilder: (BuildContext context, int index) {
                return Card(
                  color: Colors.lightBlue[100],
                  elevation: 5.0,
                  child: Container(
                    margin: EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${Provider.of<ProductProvider>(context, listen: false).nomProductdadoId(value.productosCola[index].id_producto)}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        /* ElevatedButton(
                            onPressed: () {
                              bool cola = Provider.of<LineProvider>(context,
                                      listen: false)
                                  .colaCreada;

                              if (cola) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    duration: Duration(seconds: 2),
                                    content: Text(
                                        '${Provider.of<ProductProvider>(context,listen:false).NomProductdadoId(value.productosCola[index].idProducto)} agregado')));

                              } else
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    duration: Duration(seconds: 2),
                                    content: Text(
                                        'No puede agregar un producto sin haber creado la cola')));
                            },
                            child: Text('Agregar',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                )))*/
                      ],
                    ),
                  ),
                );
              }),
        );
      },
    );
  }

  /*else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();*/

  //Perform actual search
  Widget _performSearch() {
    List<Product> nombreProductos =
        Provider.of<ProductProvider>(context).products;

    _filterList = [];
    for (int i = 0; i < nombreProductos.length; i++) {
      var item = nombreProductos[i].productName;
      if (item.toLowerCase().contains(_query.toLowerCase())) {
        _filterList.add(item);
      }
    }
    return _createFilteredListView();
  }

  //Create the Filtered ListView
  Widget _createFilteredListView() {
    return Flexible(
      child: ListView.builder(
          itemCount: _filterList.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              color: Colors.lightBlue[100],
              elevation: 5.0,
              child: Container(
                margin: EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${_filterList[index]}",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                    ElevatedButton(
                        onPressed: () {
                          bool cola =
                              Provider.of<LineProvider>(context, listen: false)
                                  .colaCreada;

                          if (cola) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                duration: Duration(seconds: 2),
                                content:
                                    Text('${_filterList[index]} agregado')));

                            Provider.of<LineProvider>(context, listen: false)
                                .addProducto(_filterList[index]);
                            //Escoger posicion de la cola activa para saber su id
                            int posColaActiva =
                                Provider.of<ColasActivasProvider>(context,
                                        listen: false)
                                    .colas
                                    .length;
                            int idProd = Provider.of<ProductProvider>(context,
                                    listen: false)
                                .idNomProduct('${_filterList[index]}');

                            ProductosColas productoElegidos = ProductosColas(
                                id_cola: Provider.of<ColasActivasProvider>(
                                        context,
                                        listen: false)
                                    .colas[posColaActiva - 1]
                                    .id,
                                id_producto: idProd);
                            Provider.of<ProductosColasProvider>(context,
                                    listen: false)
                                .productosCola
                                .add(productoElegidos);

                            print(productoElegidos.id_cola);
                            print(productoElegidos.id_producto);
                          } else
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                duration: Duration(seconds: 2),
                                content: Text(
                                    'No puede agregar un producto sin haber creado la cola')));
                        },
                        child: Text('Agregar',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            )))
                  ],
                ),
              ),
            );
          }),
    );
  }
}
