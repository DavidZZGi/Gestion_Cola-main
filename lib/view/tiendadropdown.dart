import 'package:flutter/material.dart';
import 'package:line_management/model/shop.dart';
import 'package:line_management/provider/connectionProvider.dart';
import 'package:line_management/provider/munprovider.dart';
import 'package:line_management/provider/shopProvider.dart';
import 'package:provider/provider.dart';

class TiendaDropdown extends StatefulWidget {
  TiendaDropdown({Key? key}) : super(key: key);

  @override
  State<TiendaDropdown> createState() => _TiendaDropdownState();
}

class _TiendaDropdownState extends State<TiendaDropdown> {
  late int idMun;
  int defoult=2301;
  
 Shop ? slectedShop;
  List<Shop> shops = [];
  List<Shop> finalShops = [];
  String _dropdownvalue = 'Playa- Mercado 3ra y 8';

  @override
  void initState() {
    // TODO: implement initState
    //shops = Provider.of<ShopProvider>(context, listen: false).shops;
    shops = Provider.of<ConnectionProvider>(context, listen: false).shops;
    print(shops);
  }

  @override
  Widget build(BuildContext context) {
    //idMun = Provider.of<MunicipioProvider>(context).idActive;
  //  
       
            return DropdownButton<Shop>(
                dropdownColor: Colors.blueAccent,
                hint: Text('Tiendas'),
               // onChanged: dropdowncallback,
                //value: _dropdownvalue,
                isDense: true,
                isExpanded: true,
                iconSize: 42,
                iconEnabledColor: Colors.lightBlueAccent,
                items: 
               shops.map((Shop value) {
                  return DropdownMenuItem<Shop>(
                    value: value,
                    child: Text(
                      '${value.name}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    
                    ),
                  );
                }).toList(),
                onChanged: (value){
                  setState(() {
                    slectedShop=value!;
                  });
                },
                value:slectedShop ,
                
                );
          }

    void dropdowncallback(String? selected) {

    if (selected is String) {
      setState(() {
        Provider.of<ShopProvider>(context, listen: false).setshopSelected(true);
        //Provider.of<ShopProvider>(context,listen: false).idNomShop(selected);
        _dropdownvalue = selected;
      });
    }
  }
        
  }

  