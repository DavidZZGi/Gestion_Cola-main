class ProductosColas {
  int idCola;
  int idProducto;
  bool isSelected = false;
  String? nombreProducto;
  ProductosColas({required this.idCola, required this.idProducto});

  Map<String, dynamic> toMap() {
    return {
      'idCola': idCola,
      'idProducto': idProducto,
    };
  }

  void setIdCola(int idCola) {
    this.idCola = idCola;
  }

  void setIdProducto(int idProducto) {
    this.idProducto = idProducto;
  }

  void setIsSelected(bool selected) {
    this.isSelected = selected;
  }

  void setnombreProducto(String nombProducto) {
    this.nombreProducto = nombProducto;
  }
}
