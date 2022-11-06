import 'package:line_management/model/client.dart';

class Line {
  String idMun;
  String idTienda;
  DateTime date;
  List<String> nomProducts;
  List<Cliente> clients;

  Line(
      {required this.idMun,
      required this.nomProducts,
      required this.clients,
      required this.idTienda,
      required this.date});
}
