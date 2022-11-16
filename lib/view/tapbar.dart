import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:line_management/model/Product.dart';
import 'package:line_management/model/municipio.dart';
import 'package:line_management/model/productos-colas.dart';
import 'package:line_management/provider/GestionadorProvider.dart';
import 'package:line_management/provider/colasActivasProvider.dart';

import 'package:line_management/provider/lineProvider.dart';
import 'package:line_management/provider/munprovider.dart';
import 'package:line_management/provider/productProvider.dart';
import 'package:line_management/provider/productosColasProvider.dart';
import 'package:line_management/provider/shopProvider.dart';
import 'package:line_management/view/shopDropdown.dart';
import 'package:provider/provider.dart';
import '../model/shop.dart';
import '../provider/connectionProvider.dart';
import 'listviewcomponent.dart';
import 'mundropdown.dart';

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
  //late Future<List> shops;
  @override
  Widget build(BuildContext context) {
    bool creoCola = false;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Color.fromARGB(185, 58, 112, 128),
          //shadowColor: Colors.grey,
          title: Text('Colas Activas'),

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
              /* color: Colors.lightBlue[200],
              padding: EdgeInsets.all(12.0),
              child: ListView(
                padding: EdgeInsets.all(5),
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
                    height: 6,
                  ),
                  containerGradiente(DropdownMun(), 'Seleccionar municipio'),
                  SizedBox(
                    height: 6,
                  ),
                  containerGradiente(ShopDropdown(), 'Seleccionar tienda'),
                  SizedBox(
                    height: 6,
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
                                content:
                                    Text('Cola creada satisfactoriamente')));
                            creoCola = true;
                            Provider.of<LineProvider>(context, listen: false)
                                .setcolaCreada(creoCola);
                            Provider.of<LineProvider>(context, listen: false)
                                .clientes
                                .clear();
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
            */
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
                                  value.colas.remove(value.colas[index]);
                                });
                              },
                              child: Card(
                                color: Colors.lightBlue,
                                child: ListTile(
                                  leading:
                                      Icon(Icons.person_add_disabled_rounded),
                                  title: Text('${value.colas[index].fecha}'),
                                  subtitle: Text(
                                      '${Provider.of<LineProvider>(context, listen: false).nombresTienda[index + 1]}'),
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
            Home(),

            //Third tab item
            Column(children: [
              Flexible(
                child: Consumer<LineProvider>(
                  builder: (context, value, child) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          child: Icon(Icons.add),
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(60, 60),
                            shape: const CircleBorder(),
                          ),
                          onPressed: value.colaCreada
                              ? () {
                                  Navigator.of(context).pushNamed('/lineform');
                                }
                              : null),
                    );
                  },
                ),
              ),
              Flexible(child: MylistView()),
            ]),
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
    initializeDateFormatting();
  }
}

//Search Bar
class ProductSearchBar extends StatefulWidget {
  @override
  _ProductSearchBarState createState() => _ProductSearchBarState();
}

class _ProductSearchBarState extends State<ProductSearchBar> {
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 0, 180),
      child: Container(
        child: AnimSearchBar(
          helpText: 'Buscar',
          width: 400,
          textController: textController,
          onSuffixTap: () {
            setState(() {
              textController.clear();
            });
          },
        ),
      ),
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
                print(value.develverProductosDadoIdCola(idCola).length);
                return Card(
                  color: Colors.lightBlue[100],
                  elevation: 5.0,
                  child: Container(
                    margin: EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${Provider.of<ProductProvider>(context, listen: false).NomProductdadoId(value.productosCola[index].idProducto)}',
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
                                idCola: Provider.of<ColasActivasProvider>(
                                        context,
                                        listen: false)
                                    .colas[posColaActiva - 1]
                                    .id,
                                idProducto: idProd);
                            Provider.of<ProductosColasProvider>(context,
                                    listen: false)
                                .productosCola
                                .add(productoElegidos);

                            print(productoElegidos.idCola);
                            print(productoElegidos.idProducto);
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
