import 'package:line_management/model/client.dart';

class Line {
  int id;
  String idMun;
  String idTienda;
  DateTime date;
  List<String> nomProducts;
  List<Cliente> clients;

  Line(
      {required this.id,
      required this.idMun,
      required this.nomProducts,
      required this.clients,
      required this.idTienda,
      required this.date});
}
