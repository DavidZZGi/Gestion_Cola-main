import 'dart:math';
import 'dart:ui';

import 'package:flappy_search_bar_ns/flappy_search_bar_ns.dart';
import 'package:flappy_search_bar_ns/scaled_tile.dart';
import 'package:flappy_search_bar_ns/search_bar_style.dart';
import 'package:flutter/material.dart';
import 'package:line_management/model/shop.dart';
import 'package:line_management/provider/connectionProvider.dart';
import 'package:line_management/provider/lineProvider.dart';
import 'package:line_management/provider/shopProvider.dart';
import 'package:provider/provider.dart';

import '../model/ShopSearcher.dart';

class ShopSelector extends StatefulWidget {
  const ShopSelector({Key? key}) : super(key: key);

  @override
  State<ShopSelector> createState() => _ShopSelectorState();
}

class _ShopSelectorState extends State<ShopSelector> {
  final SearchBarController<Shop> _searchBarController = SearchBarController();
  bool isReplay = false;

  Future<List<Shop>> search(String? search) async {
    final shops = Provider.of<ConnectionProvider>(context, listen: false).shops;
    List<Shop> findedShop = shops
        .where((element) => element.name
            .toLowerCase()
            .contains('${search.toString().toLowerCase()}'))
        .toList();

    return List.generate(findedShop.length, (int index) {
      print(findedShop[index].name);
      return Shop(
          name: findedShop[index].name,
          idMunicipio: findedShop[index].idMunicipio,
          activa: findedShop[index].activa,
          id: findedShop[index].id);
    });
  }

  @override
  void initState() {
    Provider.of<ConnectionProvider>(context, listen: false).getAllShops();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.lightBlue, Color.fromRGBO(1, 35, 50, 1.2)]),
        ),
        child: SafeArea(
          child: SearchBar<Shop>(
            searchBarStyle: SearchBarStyle(
                backgroundColor: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            hintText: 'Escribe el nombre de la tienda',
            hintStyle: TextStyle(color: Colors.black),
            minimumChars: 1,
            searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
            headerPadding: EdgeInsets.symmetric(horizontal: 10),
            listPadding: EdgeInsets.symmetric(horizontal: 10),
            onSearch: search,
            searchBarController: _searchBarController,
            onError: (error) => Text('ERROR: ${error.toString()}'),
            placeHolder: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Busque la tienda que desea gestionar",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            cancellationWidget: Text("Cancelar",
                style: TextStyle(color: Colors.black, fontSize: 18)),
            emptyWidget: Text("Vacio",
                style: TextStyle(color: Colors.black, fontSize: 18)),
            indexedScaledTileBuilder: (int index) =>
                ScaledTile.count(1, index.isEven ? 2 : 1),
            header: Row(
              children: <Widget>[
                TextButton(
                  child: Text(
                    "Ordenar",
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  onPressed: () {
                    _searchBarController.sortList((Shop a, Shop b) {
                      return a.name.compareTo(b.name);
                    });
                  },
                ),
                TextButton(
                  child: Text("Desordenar",
                      style: TextStyle(color: Colors.black, fontSize: 18)),
                  onPressed: () {
                    _searchBarController.removeSort();
                  },
                ),
                TextButton(
                  child: Text("Repetir",
                      style: TextStyle(color: Colors.black, fontSize: 18)),
                  onPressed: () {
                    isReplay = !isReplay;
                    _searchBarController.replayLastSearch();
                  },
                ),
              ],
            ),
            onCancelled: () {
              print("Canceledo");
            },
            //  mainAxisSpacing: 10,
            //  crossAxisSpacing: 10,
            //   crossAxisCount: 2,
            onItemFound: (Shop? post, int index) {
              return ListTile(
                title: Text(post!.name,
                    style: TextStyle(color: Colors.black, fontSize: 18)),
                isThreeLine: true,
                subtitle: Text(post.id.toString(),
                    style: TextStyle(color: Colors.black, fontSize: 15)),
                onTap: () {
                  Provider.of<LineProvider>(context, listen: false)
                      .setNomTienda(post.name);
                  Navigator.of(context).pushReplacementNamed('/cubacola');
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
