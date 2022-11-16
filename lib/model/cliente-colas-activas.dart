class ClienteColasActivas {
  int idCola;
  String nombre;
  String fv;
  String ci;
  int idEstado;
  int idMunicipio;
  DateTime fechaRegistro;
  DateTime fechaModificacion;

  ClienteColasActivas(
      {required this.ci,
      required this.nombre,
      required this.idCola,
      required this.fv,
      required this.idEstado,
      required this.idMunicipio,
      required this.fechaModificacion,
      required this.fechaRegistro});

  Map<String, dynamic> toMap() {
    return {
      'idCola': idCola,
      'nombre': nombre,
      'fv': fv,
      'ci': ci,
      'idEstado': idEstado,
      'idMunicipio': idMunicipio,
      'fechaRegistro': fechaRegistro,
      'fechaModificacion': fechaModificacion
    };
  }

  void setFechaModificacion(DateTime fecha) {
    this.fechaModificacion = fecha;
  }

  void setIdEstado(int id) {
    this.idEstado = id;
  }
}
