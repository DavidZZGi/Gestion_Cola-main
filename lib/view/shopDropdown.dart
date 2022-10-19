import 'package:flutter/material.dart';
import 'package:line_management/model/shop.dart';
import 'package:line_management/provider/connectionProvider.dart';
import 'package:line_management/provider/munprovider.dart';
import 'package:provider/provider.dart';

import '../provider/shopProvider.dart';

class ShopDropdown extends StatefulWidget {
  ShopDropdown({Key? key}) : super(key: key);

  @override
  State<ShopDropdown> createState() => _ShopDropdownState();
}

class _ShopDropdownState extends State<ShopDropdown> {
  //
  String dropDownValue = 'Playa- Mercado 3ra y 8';
  late Future<List<Shop>> shops;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int shopPos = 0;
    int munSelected = Provider.of<MunicipioProvider>(context).idActive;
    shops = Provider.of<ConnectionProvider>(context, listen: false)
        .getAllShopFromMun(munSelected);
    return FutureBuilder(
      future: shops,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? Container(
                child: DropdownButton<String>(
                  dropdownColor: Colors.blueAccent,
                  isDense: true,
                  isExpanded: true,
                  iconSize: 42,
                  iconEnabledColor: Colors.lightBlueAccent,
                  items: snapshot.data.map<DropdownMenuItem<String>>((item) {
                    return DropdownMenuItem<String>(
                      value: item.name,
                      child: Text(
                        item.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      //Buscar el valor de shopPos en el snapshop (Es lo que me falta)
                      dropDownValue = value!;
                      Provider.of<ShopProvider>(context, listen: false)
                          .setshopSelected(true);
                      // Provider.of<ShopProvider>(context,listen: false).idNomShop(value);
                    });
                  },
                  value: snapshot.data[shopPos].name,
                ),
              )
            : Container(
                child: Center(
                  child: Text('Loading...'),
                ),
              );
      },
    );
  }
}
