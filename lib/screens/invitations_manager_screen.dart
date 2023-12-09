import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_pmsn2023/firebase/firebase_service.dart';
import 'package:final_project_pmsn2023/screens/list_invitated_screen.dart';
import 'package:final_project_pmsn2023/widgets/components.dart';
import 'package:final_project_pmsn2023/widgets/invitation_qr.dart';
import 'package:final_project_pmsn2023/widgets/qr_generator.dart';
import 'package:flutter/material.dart';

class InvitationsScreen extends StatelessWidget {
  const InvitationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  const TabBar(
                    indicatorSize: TabBarIndicatorSize.label,
                    labelColor: Color.fromRGBO(0, 67, 186, 1),
                    unselectedLabelColor: Colors.grey,
                    tabs: _tabs_menu,
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: Container(
            child: TabBarView(
              children: _tabs
                  .map(
                    (e) => Center(
                      child:
                          e.child, // Aquí accedemos a la propiedad child de Tab
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

const _tabs_menu = [
  Tab(
    icon: Icon(Icons.home_rounded),
    text: 'Mis eventos',
  ),
  Tab(
    icon: Icon(Icons.shopping_bag_rounded),
    text: 'Mis invitaciones',
  ),
];

List<Tab> _tabs = [
  Tab(
    child: MisEventos(),
  ),
  Tab(
    child: MisInvitaciones(),
  ),
];

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return _tabBar;
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class MisEventos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getEvento(),
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
            return const Text('No hay datos disponibles');
          }

          return Column(
            children: data.map((elemento) {
              return Card(
                color: const Color.fromRGBO(0, 67, 186, 1),
                elevation: 5,
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: ListTile(
                  title: Text(elemento['name'],
                      style: const TextStyle(color: Colors.white)),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BotonCuadrado(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  GenerateQR(id: elemento['id']),
                            ),
                          );
                        },
                        icono: Icons.qr_code_scanner_rounded,
                        colos: const Color.fromRGBO(5, 51, 130, 1),
                      ),
                      BotonCuadrado(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ListInvitationScreen(idevent: elemento['id']),
                            ),
                          );
                        },
                        icono: Icons.list,
                        colos: const Color.fromRGBO(5, 51, 130, 1),
                      ),
                      /*  BotonCuadrado(
                        onPressed: () {
                          print(elemento['id']);
                        },
                        icono: Icons.edit,
                      ), */
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }
}

class MisInvitaciones extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getMyInvitation(),
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
            return const Text('No hay datos disponibles');
          }

          return Column(
            children: data.map((elemento) {
              return Card(
                color: const Color.fromRGBO(212, 6, 130, 1),
                elevation: 5,
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: ListTile(
                  title: Text(elemento['nameevent'],
                      style: const TextStyle(color: Colors.white)),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BotonCuadrado(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  InvitationQR(id: elemento['id']),
                            ),
                          );
                        },
                        icono: Icons.qr_code_2,
                        colos: const Color.fromRGBO(156, 4, 95, 1),
                      ),
                      BotonCuadrado(
                        onPressed: () {
                          signUpAlert(
                            context: context,
                            onPressed: () async {
                              print('xd');
                              try {
                                // Referencia al documento que deseas eliminar
                                DocumentReference documentReference = FirebaseFirestore.instance.collection('invitations').doc(elemento['id']);

                                // Elimina el documento
                                await documentReference.delete();

                                print('Registro eliminado correctamente');
                              } catch (e) {
                                print('Error al eliminar el registro: $e');
                              }

                              // ignore: use_build_context_synchronously
                              Navigator.popAndPushNamed(context, '/dash');
                            },
                            title: '¿Abandonar evento?',
                            desc: '¿Estas seguro de querer salirte de el evento?',
                            btnText: 'Aceptar',
                          ).show();
                        },
                        icono: Icons.delete_forever_rounded,
                        colos: const Color.fromRGBO(156, 4, 95, 1),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }
}

class BotonCuadrado extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icono;
  final Color colos;

  BotonCuadrado({required this.onPressed, required this.icono, required this.colos});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Center(
          child: Icon(icono, color: colos),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: InvitationsScreen(),
  ));
}