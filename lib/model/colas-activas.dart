class ColaAciva {
  int id;
  int idTienda;
  DateTime fecha;

  ColaAciva({required this.id, required this.idTienda, required this.fecha});

  Map<String, dynamic> toMap() {
    return {'id': id, 'idTienda': idTienda, 'fecha': fecha};
  }

  void setId(int id) {
    this.id = id;
  }

  void setIdTienda(int idTienda) {
    this.idTienda = idTienda;
  }
}
