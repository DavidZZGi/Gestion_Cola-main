import 'cliente-colas-activas.dart';

class ColaActiva {
  int id;
  int idTienda;
  DateTime fecha;
  bool isSelected = true;
  int cantColasdeUnaTienda = 0;
  List<ClienteColasActivas>? clienteColas;

  ColaActiva({required this.id, required this.idTienda, required this.fecha});

  Map<String, dynamic> toMap() {
    return {'id': id, 'idTienda': idTienda, 'fecha': fecha};
  }

  void setId(int id) {
    this.id = id;
  }

  void setIdTienda(int idTienda) {
    this.idTienda = idTienda;
  }

  void setIsSelected(bool selected) {
    this.isSelected = selected;
  }

  void setcantColasdeUnaTienda(int cant) {
    this.cantColasdeUnaTienda = cant;
  }
}
