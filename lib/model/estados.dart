class Estados {
  int id;
  String nombre;

  Estados({required this.id, required this.nombre});

  static List<Estados> estados = [
    Estados(id: 1, nombre: 'Registrado'),
    Estados(id: 2, nombre: 'Compro'),
    Estados(id: 3, nombre: 'Rechazado'),
    Estados(id: 4, nombre: 'Abandono')
  ];

  Map<String, dynamic> toMap() {
    return {
      // 'idCliente': idCliente,
      'id': id,
      'nombre': nombre,
    };
  }

  static String getEstadoName(int id) {
    for (var element in estados) {
      if (element.id == id) return element.nombre;
    }
    return '';
  }

  int getIdEstado() => this.id;
  String getNombreEstado() => this.nombre;
}
