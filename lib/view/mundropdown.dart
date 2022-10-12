import 'package:flutter/material.dart';
import 'package:line_management/provider/lineProvider.dart';
import 'package:line_management/provider/munprovider.dart';
import 'package:provider/provider.dart';

class DropdownMun extends StatefulWidget {
  DropdownMun({Key? key}) : super(key: key);

  @override
  State<DropdownMun> createState() => _DropdownMunState();
}

class _DropdownMunState extends State<DropdownMun> {
  String _dropdownvalue = 'Playa';
  int id=0;
  @override
  Widget build(BuildContext context) {
    
   /* List<Municipio> municipios =
        Provider.of<MunicipioProvider>(context)
            .inicializarMunicipiosSinConexion();
         */
    return  DropdownButton(
          hint: Text('Municipios'),
          dropdownColor: Colors.blueAccent,
          onChanged: (String? newvalue){
                Provider.of<MunicipioProvider>(context,listen: false).munWasSelected();
             Provider.of<MunicipioProvider>(context,listen: false).idNomMun(newvalue!);
              Provider.of<LineProvider>(context,listen: false).setMunSelected(newvalue);
                 setState(() {
                
                  _dropdownvalue=newvalue;
                 
                 });
          },
          value: _dropdownvalue,
          isDense: true,
          isExpanded: true,
          iconSize: 42,
          iconEnabledColor: Colors.lightBlueAccent,
          items: <String>['Playa','Plaza de la Revolución','Centro Habana','La Habana Vieja','La Habana del Este','Guanabacoa','San Miguel del Padrón','Diez de Octubre'
          ,'Cerro','Marianao','La Lisa','Boyeros','Arroyo Naranjo','Cotorro'
          ].map((String value){
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text('$value',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                  );
          }
          ).toList()
          );
    
  }

 

  





}
