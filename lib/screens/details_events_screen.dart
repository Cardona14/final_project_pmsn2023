import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_pmsn2023/widgets/components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class DetailsEventScreen extends StatefulWidget {
  final String id;
  DetailsEventScreen({required this.id});
  //const DetailsEventScreen({super.key});

  @override
  State<DetailsEventScreen> createState() => DetailsEventScreenState(id: id);
}

class DetailsEventScreenState extends State<DetailsEventScreen> {
  final String id;
  DetailsEventScreenState({required this.id});

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    ScreenUtil.init(context, designSize: const Size(750, 1334));
    return FutureBuilder<DocumentSnapshot>(
      future: db.collection('events').doc(id).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Mientras espera, puedes mostrar un indicador de carga
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // En caso de error, puedes manejar el error aquí
          return Text('Error: ${snapshot.error}');
        } else {
          // Los datos han sido cargados con éxito, puedes trabajar con ellos aquí
          var data = snapshot.data!.data() as Map<String, dynamic>;

          var evento_name = data["name"];

          // Asegúrate de manejar el caso en que los datos sean nulos
          if (data == null || data.isEmpty) {
            return const Text('No hay datos disponibles');
          }

          return Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  Image.asset(
                    "assets/InvitApp.png",
                    width: ScreenUtil().setWidth(110),
                    height: ScreenUtil().setHeight(110),
                  ),
                  Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("InvitApp",
                          style: TextStyle(
                              fontFamily: "Poppins-Bold",
                              fontSize: ScreenUtil().setSp(46),
                              fontWeight: FontWeight.bold)))
                ],
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(left: 20, right: 20),
                /* decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0, 2),
                      blurRadius: 1,
                    ),
                  ],
                ), */
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(top: 50),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Te han invitado a $evento_name',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.black,
                                fontFamily: "Poppins-Bold",
                                fontSize: 17,
                              )),
                          const SizedBox(
                            height: 20,
                          ),
                          const Badge(
                            backgroundColor: Color.fromRGBO(0, 67, 186, 1),
                            largeSize: 20,
                            textStyle: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Text(data["ubication"],
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                color: Colors.black,
                                fontFamily: "Poppins-Bold",
                                fontSize: 13,
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          const Badge(
                            label: Text('Fecha'),
                            backgroundColor: Color.fromRGBO(0, 67, 186, 1),
                            largeSize: 20,
                            textStyle: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Text(data["date"],
                              style: const TextStyle(
                                color: Colors.black,
                                fontFamily: "Poppins-Bold",
                                fontSize: 13,
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          const Badge(
                            label: Text('Hora'),
                            backgroundColor: Color.fromRGBO(0, 67, 186, 1),
                            largeSize: 20,
                            textStyle: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Text(data["hour"],
                              style: const TextStyle(
                                color: Colors.black,
                                fontFamily: "Poppins-Bold",
                                fontSize: 13,
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          const Badge(
                            label: Text('Tipo de evento'),
                            backgroundColor: Color.fromRGBO(0, 67, 186, 1),
                            largeSize: 20,
                            textStyle: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Text(data["type"],
                              style: const TextStyle(
                                color: Colors.black,
                                fontFamily: "Poppins-Bold",
                                fontSize: 13,
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          const Badge(
                            label: Text('Detalles del evento'),
                            backgroundColor: Color.fromRGBO(0, 67, 186, 1),
                            largeSize: 20,
                            textStyle: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Text(data["description"],
                              style: const TextStyle(
                                color: Colors.black,
                                fontFamily: "Poppins-Bold",
                                fontSize: 13,
                              )),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 220,
                      margin: const EdgeInsets.only(top: 20, bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(color: Colors.black, width: 5),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0, 2),
                            blurRadius: 1,
                          ),
                        ],
                      ),
                      child: GoogleMap(
                        mapType: MapType.normal,
                        markers: {
                          Marker(
                            markerId: const MarkerId("marker1"),
                            position: LatLng(data['lat'], data['lot']),
                          ),
                        },
                        initialCameraPosition: CameraPosition(
                          target: LatLng(data['lat'], data['lot']),
                          zoom: 16,
                        ),
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                      ),
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FloatingActionButton.extended(
                            heroTag: 'confirm_invitation',
                            onPressed: () async {
                              User? user = FirebaseAuth.instance.currentUser;
                              await db.collection('invitations').add({
                                'user': user?.uid,
                                'pased': false,
                                'event': id,
                                'username': user?.displayName,
                              }).then((value) => {
                                    showAlert(
                                        context: context,
                                        title:
                                            'Se acepto la invitación correctamente',
                                        desc:
                                            'Ahora estas registrado en la fiesta',
                                        type: AlertType.success,
                                        onPressed: () {
                                          Navigator.popAndPushNamed(
                                              context, '/dash');
                                        }).show()
                                  });
                            },
                            label: const Text(
                              'Aceptar',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins-Bold',
                                  fontSize: 15),
                            ),
                            backgroundColor: Colors.green,
                            icon: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                          FloatingActionButton.extended(
                            heroTag: 'close_details',
                            onPressed: () {
                              Navigator.popAndPushNamed(context, '/dash');
                            },
                            //extendedPadding: EdgeInsets.all(10),
                            label: const Text(
                              'Rechazar',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins-Bold',
                                  fontSize: 15),
                            ),
                            backgroundColor: Colors.red,
                            icon: const Icon(
                              Icons.cancel,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}