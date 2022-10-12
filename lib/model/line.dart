import 'package:line_management/model/Product.dart';
import 'package:line_management/model/client.dart';

class Line {
int idLine;
int idMun;
int idTienda;
DateTime date;
  int idproducts;
  List<Cliente> clients;

  Line(
      {required this.idLine,
      required this.idMun,
      required this.idproducts,
      required this.clients,
      required this.idTienda,
      required this.date
      });


      
}
