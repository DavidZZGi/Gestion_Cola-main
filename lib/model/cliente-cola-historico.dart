class ClienteColasHistorico {
  int idCola;
  String ci;
  int idEstado;
  int idMensaje;

  ClienteColasHistorico(
      {required this.ci,
      required this.idCola,
      required this.idEstado,
      required this.idMensaje});

  Map<String, dynamic> toMap() {
    return {
      'idCola': idCola,
      'ci': ci,
      'idEstado': idEstado,
      'idMensaje': idMensaje,
    };
  }
}
