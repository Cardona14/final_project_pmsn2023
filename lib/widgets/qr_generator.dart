import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
//import 'dart:ui';

class GenerateQR extends StatefulWidget {
  final String id;
  GenerateQR({super.key, required this.id});

  @override
  State<StatefulWidget> createState() => GenerateQRState(id: id);
}

class GenerateQRState extends State<GenerateQR> {
  final String id;
  GenerateQRState({required this.id});

  String qrData =
      "https://github.com/neon97"; // already generated qr code when the page opens

  @override
  Widget build(BuildContext context) {
    print(id);
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20.0),
        margin:
            const EdgeInsets.only(right: 50, left: 50, top: 150, bottom: 150),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0, 2),
              blurRadius: 15,
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
                embeddedImage: const AssetImage("assets/InvitApp_qr.png"),
                size: 200.0,
              ),
            ),
            const SizedBox(
              height: 40.0,
            ),
            const Text(
              "🥳🥳 Comparte este QR para invitar amigos a tu fiesta 🥳🥳",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.0,
                fontFamily: "Poppins-Bold",
              ),
            ),
            /*  TextField(
              controller: qrdataFeed,
              decoration: InputDecoration(
                hintText: "Input your link or data",
              ),
            ),
            */
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 20, 40, 0),
              child: FloatingActionButton(
                onPressed: () async {
                  /* if (qrdataFeed.text.isEmpty) {
                    //a little validation for the textfield
                    setState(() {
                      qrData = "";
                    });
                  } else {
                    setState(() {
                      qrData = qrdataFeed.text;
                    });
                  } */
                  Navigator.popAndPushNamed(context, '/dash');
                },
                shape: RoundedRectangleBorder(
                    side: const BorderSide(
                        color: Color.fromRGBO(0, 67, 186, 1), width: 3.0),
                    borderRadius: BorderRadius.circular(20.0)),
                backgroundColor: const Color.fromRGBO(0, 67, 186, 1),
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

  final qrdataFeed = TextEditingController();
}
