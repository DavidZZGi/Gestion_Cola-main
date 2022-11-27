class ClienteColasActivas {
  int id_cola;
  String nombre;
  String fv;
  String ci;
  int id_estado;
  int id_municipio;
  String fecha_registro;
  String fecha_modif;

  ClienteColasActivas(
      {required this.ci,
      required this.nombre,
      required this.id_cola,
      required this.fv,
      required this.id_estado,
      required this.id_municipio,
      required this.fecha_modif,
      required this.fecha_registro});

  Map<String, dynamic> toMap() {
    return {
      'id_cola': id_cola,
      'nombre': nombre,
      'fv': fv,
      'ci': ci,
      'id_estado': id_estado,
      'id_municipio': id_municipio,
      'fecha_registro': fecha_registro,
      'fecha_modif': fecha_modif
    };
  }

  void setFechaModificacion(String fecha) {
    this.fecha_modif = fecha;
  }

  void setIdEstado(int id) {
    this.id_estado = id;
  }

  void setIdCola(int id) {
    this.id_cola = id;
  }
}
