class ProductosColas {
  int id_cola;
  int id_producto;
  bool isSelected = false;
  String? nombreProducto;
  ProductosColas({required this.id_cola, required this.id_producto});

  Map<String, dynamic> toMap() {
    return {
      'id_cola': id_cola,
      'id_producto': id_producto,
    };
  }

  void setIdCola(int idCola) {
    this.id_cola = idCola;
  }

  void setIdProducto(int idProducto) {
    this.id_producto = idProducto;
  }

  void setIsSelected(bool selected) {
    this.isSelected = selected;
  }

  void setnombreProducto(String nombProducto) {
    this.nombreProducto = nombProducto;
  }
}
