import 'package:flutter/material.dart';
import 'package:line_management/provider/clientProvider.dart';
import 'package:line_management/provider/connectionProvider.dart';
import 'package:line_management/provider/lineProvider.dart';
import 'package:line_management/provider/munprovider.dart';
import 'package:line_management/provider/productProvider.dart';
import 'package:line_management/provider/shopProvider.dart';
import 'package:line_management/services/localConnectionServices.dart';
import 'package:line_management/view/loading.dart';
import 'package:provider/provider.dart';
import './upscreen_part.dart';
import './tapbar.dart';
import 'lineform.dart';
import 'loggin.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ClienteProvider()),
      ChangeNotifierProvider(create: (context) => MunicipioProvider()),
      ChangeNotifierProvider(create: (context) => ShopProvider()),
      ChangeNotifierProvider(create: (context) => ProductProvider()),
      ChangeNotifierProvider(create: (context) => ConnectionProvider()),
      ChangeNotifierProvider(create: (context) => LineProvider())
    ],
    child: MaterialApp(
      initialRoute: '/loading',
      routes: {
        '/loading': (context) => LoadingPage(),
        '/': (context) => const SignUpScreen(),
        '/cubacola': (context) => MyApp(),
        '/lineform': (context) => Lineform()
      },
      debugShowCheckedModeBanner: false,
    ),
  ));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final ConnectionServices conn;
/*
void test()async{
final directory=  await getApplicationDocumentsDirectory();
final path ='${directory.path}/db.sqlite';
print(path);
}
*/
  @override
  void initState() {
    super.initState();
    //Provider.of<ConnectionProvider>(context, listen: false).getConnection();

//Provider.of<ClienteProvider>(context,listen: false).inicializarClientesSinConexion();

Provider.of<ShopProvider>(context,listen: false).initShopList(Provider.of<ConnectionProvider>(context,listen: false).getAllShops());

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              'Sistema de Gestión de Colas',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(228, 255, 255, 255)),
            ),
          ),
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            Flexible(child: UpScreenPart()),
            Flexible(
              child: MyTapBar(),
              flex: 3,
            ),
          ],
        ));
  }
}
