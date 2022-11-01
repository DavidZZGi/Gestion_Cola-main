import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_management/provider/connectionProvider.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatefulWidget {
  LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    appLoading();
  }

  appLoading() async {
    await Future.delayed(Duration(milliseconds: 4000), () {
      Provider.of<ConnectionProvider>(context, listen: false).getConnection();
      Provider.of<ConnectionProvider>(context, listen: false).getAllProducts();
      Provider.of<ConnectionProvider>(context, listen: false)
          .getConnectionBDLimpia();

      print('success');
    });
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.lightBlue, Color.fromRGBO(14, 30, 50, 1.7)]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '¡Bienvenido!',
                style: TextStyle(fontSize: 35, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SpinKitFadingCube(
                color: Colors.white,
                size: 70.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
