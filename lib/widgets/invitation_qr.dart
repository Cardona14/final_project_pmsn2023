import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
//import 'dart:ui';

class InvitationQR extends StatefulWidget {
  final String id;
  InvitationQR({super.key, required this.id});

  @override
  State<StatefulWidget> createState() => InvitationQRState(id: id);
}

class InvitationQRState extends State<InvitationQR> {
  final String id;
  InvitationQRState({required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.only(right: 20, left: 20, top: 50, bottom: 50),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              offset: Offset(0, 10),
              blurRadius: 35,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: QrImageView(
                data: id,
                version: QrVersions.auto,
                embeddedImage: const AssetImage("assets/InvitApp_qr2.png"),
                size: 300.0,
                backgroundColor: Colors.white,
              ),
            ),
            const SizedBox(
              height: 40.0,
            ),
            const Text(
              "Entrega este código al alfitrión de la fiesta para que puedas acceder a ella 📱🪅",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: "Poppins-Bold",
                  color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 20, 40, 0),
              child: FloatingActionButton(
                onPressed: () async {
                  Navigator.popAndPushNamed(context, '/dash');
                },
                shape: RoundedRectangleBorder(
                    side: const BorderSide(
                        color: Color.fromRGBO(156, 4, 95, 1), width: 3.0),
                    borderRadius: BorderRadius.circular(20.0)),
                backgroundColor: const Color.fromRGBO(156, 4, 95, 1),
                child: const Text(
                  "Regresa al inicio",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
