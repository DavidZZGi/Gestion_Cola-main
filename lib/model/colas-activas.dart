import 'cliente-colas-activas.dart';

class ColaActiva {
  int id;
  int tienda;
  String fecha;
  bool isSelected = true;
  int cantColasdeUnaTienda = 0;
  List<ClienteColasActivas>? clienteColas;
  String? nombTienda;

  ColaActiva({required this.id, required this.tienda, required this.fecha});

  Map<String, dynamic> toMap() {
    return {'id': id, 'tienda': tienda, 'fecha': fecha};
  }

  void setId(int id) {
    this.id = id;
  }

  void setIdTienda(int idTienda) {
    this.tienda = idTienda;
  }

  void setIsSelected(bool selected) {
    this.isSelected = selected;
  }

  void setcantColasdeUnaTienda(int cant) {
    this.cantColasdeUnaTienda = cant;
  }
}
