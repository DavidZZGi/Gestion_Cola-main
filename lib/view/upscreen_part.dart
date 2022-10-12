import 'package:flutter/material.dart';

// ignore: must_be_immutable
class UpScreenPart extends StatelessWidget {
  String estado = 'Sincronizado';
  DateTime time = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return OverflowBox(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.lightBlue, Color.fromRGBO(14, 30, 50, 1.7)])),
        width: double.infinity,
        height: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Flexible(
                      child: Text(
                        'Exportar Colas',
                        style: TextStyle(
                          color:Colors.white,
                          fontWeight: FontWeight.bold ),
                      ),
                    ),
                  ),
                       Flexible(
                         child: ElevatedButton(
                                     child: Icon(
                                       Icons.upload,
                                       color: Colors.white,
                                     ),
                                     onPressed: () {},
                                     style: ElevatedButton.styleFrom(
                                       fixedSize: const Size(60, 60),
                                       shape: const CircleBorder(),
                                     ),
                                   ),
                       ),
                ],
            ),
            
            Center(
              child: Text(
                'Cubacola',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                  color: Colors.white,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Flexible(
                     child: Text(
                       'Importar Colas',
                       style: TextStyle(
                            color:Colors.white,
                            fontWeight: FontWeight.bold )
                     ),
                   ),
                 ),

                 Flexible(
                   child: ElevatedButton(
                               child: Icon(
                                 Icons.download,
                                 color: Colors.white,
                               ),
                               onPressed: () {},
                               style: ElevatedButton.styleFrom(
                                 fixedSize: const Size(60, 60),
                                 shape: const CircleBorder(),
                               ),
                             ),
                 ),
              ],
            ),
            
          ],
        ),
      ),
    );
  }
}
