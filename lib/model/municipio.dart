class Municipio {
  int idMunicipio;
  int idProvincia;
  String nombre;

  Municipio(
      {required this.idMunicipio,
      required this.nombre,
      required this.idProvincia});

  String getnombre() => this.nombre;

  void setNombre(String value) {
    this.nombre = value;
  }
}
