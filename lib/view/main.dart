import 'package:flutter/material.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:line_management/provider/GestionadorProvider.dart';
import 'package:line_management/provider/clientProvider.dart';
import 'package:line_management/provider/clientesColasActivasProvider.dart';
import 'package:line_management/provider/colasActivasProvider.dart';
import 'package:line_management/provider/connectionProvider.dart';
import 'package:line_management/provider/lineProvider.dart';
import 'package:line_management/provider/munprovider.dart';
import 'package:line_management/provider/productProvider.dart';
import 'package:line_management/provider/productosColasProvider.dart';
import 'package:line_management/provider/shopProvider.dart';
import 'package:line_management/services/localConnectionServices.dart';
import 'package:line_management/view/createLineView.dart';
import 'package:line_management/view/loading.dart';
import 'package:line_management/view/shopSelector.dart';
import 'package:line_management/view/subCola.dart';
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
      ChangeNotifierProvider(create: (context) => LineProvider()),
      ChangeNotifierProvider(create: (context) => ColasActivasProvider()),
      ChangeNotifierProvider(create: (context) => ProductosColasProvider()),
      ChangeNotifierProvider(create: (context) => ClienteColaActivaProvider()),
      ChangeNotifierProvider(create: (context) => GestionadorProvider()),
    ],
    child: MaterialApp(
      supportedLocales: [
        Locale('de'),
        Locale('en'),
        Locale('es'),
        Locale('fr'),
        Locale('it'),
      ],
      localizationsDelegates: [
        FormBuilderLocalizations.delegate,
      ],
      initialRoute: '/loading',
      routes: {
        '/loading': (context) => LoadingPage(),
        '/': (context) => const SignUpScreen(),
        '/cubacola': (context) => MyApp(),
        '/lineform': (context) => Lineform(),
        '/shopselector': (context) => ShopSelector(),
        '/subcola': ((context) => SubCola()),
        '/createline': ((context) => CreateLineWidget()),
        '/productsearch': ((context) => ProductSearchBar())
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Image.asset(
              'images/C-Cuba-removebg-preview.png',
              width: 120,
              height: 150,
            ),
            Text(
              'Sistema Gestión de Cola',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(228, 255, 255, 255),
                fontSize: 18.0,
              ),
            ),
          ]),
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
