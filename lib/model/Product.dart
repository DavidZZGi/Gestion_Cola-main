class Product {
  String productName;
  int id;
  int idTipo;
  bool isSelected = false;
  Product({required this.productName, required this.id, required this.idTipo});

//getters
  String getproductName() => this.productName;
  int getcant() => this.id;

//setters
  void setproductName(String value) {
    this.productName = value;
  }

  void setIsSelected(bool? value) {
    this.isSelected = value!;
  }
}
