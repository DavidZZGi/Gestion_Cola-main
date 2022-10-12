import 'package:flutter/material.dart';
import 'package:line_management/model/municipio.dart';
import 'package:line_management/services/municipioService.dart';

class MunicipioProvider with ChangeNotifier {
  List<Municipio> municipios = [];
  MunicipioService munipioService = MunicipioService();
  bool selectedValue = false;
  int idActive = 2301;

  bool munWasSelected() {
    selectedValue = true;
    notifyListeners();
    return selectedValue;
  }

  int idNomMun(String name) {
    for (var item in municipios) {
      if (item.nombre == name) {
        idActive = item.idMunicipio;
      }
    }
    return idActive;
  }

void initMunicipios(Future<List<Municipio>>muns)async{
  municipios= await muns;
}



  MunicipioProvider();
}
