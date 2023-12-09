import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_pmsn2023/firebase/firebase_service.dart';
import 'package:final_project_pmsn2023/widgets/components.dart';
import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class ListInvitationScreen extends StatelessWidget {
  //const ListInvitationScreen({super.key});
  final String idevent;
  ListInvitationScreen({required this.idevent});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getInvitations(idevent),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Mientras espera, puedes mostrar un indicador de carga
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // En caso de error, puedes manejar el error aquí
          return Text('Error: ${snapshot.error}');
        } else {
          // Los datos han sido cargados con éxito, puedes trabajar con ellos aquí
          List<dynamic>? data = snapshot.data as List<dynamic>?;

          // Asegúrate de manejar el caso en que los datos sean nulos
          if (data == null || data.isEmpty) {
            return Container(
                color: Colors.white,
                child: const Center(
                    child: Text(
                  'No hay datos disponibles',
                  style: TextStyle(
                    fontFamily: 'Poppins-Bold',
                    fontSize: 20,
                    color: Color.fromRGBO(0, 67, 186, 1),
                  ),
                )));
          }

          return Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  Image.asset(
                    "assets/InvitApp.png",
                    width: 50,
                    height: 50,
                  ),
                  Container(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text("Invitados",
                          style: TextStyle(
                              fontFamily: "Poppins-Bold",
                              fontSize: 25,
                              fontWeight: FontWeight.bold)))
                ],
              ),
            ),
            body: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(30),
              child: Column(
                children: data.map((elemento) {
                  return Card(
                    color: elemento['pased']
                        ? Colors.green
                        : const Color.fromRGBO(224, 244, 255, 1),
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: ListTile(
                      title: Text(
                        elemento['nombre'] ?? elemento['username'],
                        style: const TextStyle(
                            color: Colors.black, fontFamily: 'Poppins-Bold'),
                      ),
                      trailing: Checkbox(
                        value: elemento['pased'] ??
                            false, // Manejar el estado del checkbox según tus necesidades
                        onChanged: (bool? value) {
                          // Manejar el cambio de estado del checkbox
                        },
                        activeColor: Colors
                            .white, // Color del checkbox cuando está seleccionado
                        checkColor: const Color.fromRGBO(0, 67, 186,
                            1), // Color del tick dentro del checkbox
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              heroTag: 'boton aceptar invitacion',
              onPressed: () async {
                var res = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SimpleBarcodeScannerPage(),
                    ));

                if (res is String) {
                  {
                    try {
                      await FirebaseFirestore.instance
                          .collection('invitations')
                          .doc(res)
                          .update({
                        'pased': true,
                      });
                      // ignore: use_build_context_synchronously
                      signUpAlert(
                        context: context,
                        title: 'Usuario ingresado correctamente',
                        desc: 'Ahora el usuario ya puede entrar a la fiesta',
                        btnText: 'Ok',
                        onPressed: () {
                          Navigator.popAndPushNamed(context, '/dash');
                        },
                      ).show();
                    } catch (error) {
                      print('Error al actualizar el documento: $error');
                    }
                  }
                }
              },
              backgroundColor: const Color.fromRGBO(156, 4, 95, 1),
              label: const Icon(
                Icons.document_scanner_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
          );
        }
      },
    );
  }
}
