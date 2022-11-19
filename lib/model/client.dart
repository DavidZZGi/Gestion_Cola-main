class Cliente {
  // int idCliente;
  String nombre;
  String apellidos;
  String carnetIdentidad;
  int idEstado;

  Cliente(
      { //required this.idCliente,
      required this.idEstado,
      required this.carnetIdentidad,
      required this.nombre,
      required this.apellidos});

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
        carnetIdentidad: json['carnetIdentidad'],
        nombre: json['nombre'],
        //  idCliente: json['idCliente'],
        apellidos: json['apellidos'],
        idEstado: json['idEstado']);
  }

  Map<String, dynamic> toMap() {
    return {
      // 'idCliente': idCliente,
      'nombre': nombre,
      'apellidos': apellidos,
      'ci': carnetIdentidad,
      'idEstado': idEstado,
    };
  }

  @override
  String toString() {
    return 'Cliente{ nombre: $nombre, apellidos: $apellidos, carnetIdentidad: $carnetIdentidad}';
  }

  void setEstado(int idEstado) {
    this.idEstado = idEstado;
  }
}
