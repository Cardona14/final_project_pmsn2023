import 'package:final_project_pmsn2023/screens/details_events_screen.dart';
import 'package:final_project_pmsn2023/screens/new_invitation_screen.dart';
import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class HomeDash extends StatelessWidget {
  String qrString = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          dashBg,
          Container(
            child: Column(
              children: <Widget>[
                header,
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    child: GridView.count(
                      crossAxisSpacing: 30,
                      mainAxisSpacing: 16,
                      crossAxisCount: 2,
                      childAspectRatio: .90,
                      children: [
                        FloatingActionButton.extended(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const InvitationScreen()),
                            );
                          },
                          heroTag: 'new_event',
                          elevation: 10,
                          backgroundColor: Colors.white,
                          label: const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.event_available_rounded,
                                color: Colors.black,
                                size: 55,
                              ),
                              SizedBox(height: 4),
                              Text('Crear nuevo\nevento',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "Poppins-Bold",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ))
                            ],
                          ),
                        ),
                        FloatingActionButton.extended(
                          onPressed: () async {
                            var res = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const SimpleBarcodeScannerPage(),
                                ));

                            if (res is String) {
                              qrString = res;

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailsEventScreen(id: qrString),
                                ),
                              );
                            }
                          },
                          elevation: 10,
                          backgroundColor: Colors.white,
                          label: const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.qr_code_scanner_rounded,
                                color: Colors.black,
                                size: 55,
                              ),
                              SizedBox(height: 4),
                              Text('Escanear una\ninvitacion',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "Poppins-Bold",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  get dashBg => Column(
        children: <Widget>[
          Expanded(
            child: Container(color: const Color.fromRGBO(0, 67, 186, 1)),
            flex: 2,
          ),
          Expanded(
            child: Container(color: Colors.transparent),
            flex: 5,
          ),
        ],
      );

  get header => const ListTile(
        contentPadding: EdgeInsets.only(left: 20, right: 20, top: 20),
      );
}