// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:concentric_transition/concentric_transition.dart';
import 'package:final_project_pmsn2023/widgets/components.dart';
import 'package:final_project_pmsn2023/widgets/onboard_card_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? accountName = 'Nombre del Usuario';
  String? accountEmail = 'Correo Electrónico';
  String? profilePhotoUrl;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    //print(user?.uid);

    if (user != null) {
      if (user.providerData
          .any((userInfo) => userInfo.providerId == 'password')) {
        try {
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

          if (userDoc.exists) {
            setState(() {
              accountName = '${userDoc['name']} ${userDoc['lastName']}';
              accountEmail = user.email;
              profilePhotoUrl = userDoc['photoURL'];
            });
          }
        } catch (e) {
          showAlert(
              context: context,
              title: 'Error de autenticación',
              desc: '$e',
              type: AlertType.error,
              onPressed: () {
                Navigator.pop(context);
              }).show();
        }
      } else {
        setState(() {
          accountName = user.displayName ?? 'Nombre del Usuario';
          accountEmail = user.email ?? 'Correo Electrónico';
          profilePhotoUrl = user.photoURL ?? 'email@example.com';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              flex: 2, child: _TopPortion(profilePhotoUrl: profilePhotoUrl)),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    accountName ?? 'Nombre del Usuario',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    accountEmail ?? 'Correo Electrónico',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingActionButton.extended(
                        heroTag: 'onboarding',
                        elevation: 0,
                        label: const Text("Onboarding"),
                        icon: const Icon(Icons.article_rounded),
                        onPressed: () {
                          //pendiente
                          onBoarding();
                        },
                      ),
                      const SizedBox(width: 16.0),
                      FloatingActionButton.extended(
                        heroTag: 'cerrar sesión',
                        elevation: 0,
                        backgroundColor: Colors.red,
                        label: const Text("Cerrar sesión"),
                        icon: const Icon(Icons.logout_rounded),
                        onPressed: () async {
                          try {
                            await FirebaseAuth.instance.signOut();
                            showAlert(
                                context: context,
                                type: AlertType.none,
                                title: 'Sesión finalizada',
                                desc: 'Vuelve pronto',
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, '/home');
                                }).show();
                          } catch (e) {
                            showAlert(
                                context: context,
                                type: AlertType.error,
                                title: 'Algo salió mal',
                                desc: 'Intenta cerrar sesión más tarde',
                                onPressed: () {
                                  Navigator.pop(context);
                                }).show();
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const _ProfileInfoRow()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  const _ProfileInfoRow({Key? key}) : super(key: key);

  final List<ProfileInfoItem> _items = const [
    ProfileInfoItem("Posts", 900),
    ProfileInfoItem("Followers", 120),
    ProfileInfoItem("Following", 200),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      constraints: const BoxConstraints(maxWidth: 400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _items
            .map((item) => Expanded(
                    child: Row(
                  children: [
                    if (_items.indexOf(item) != 0) const VerticalDivider(),
                    Expanded(child: _singleItem(context, item)),
                  ],
                )))
            .toList(),
      ),
    );
  }

  Widget _singleItem(BuildContext context, ProfileInfoItem item) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              item.value.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Text(
            item.title,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      );
}

class ProfileInfoItem {
  final String title;
  final int value;
  const ProfileInfoItem(this.title, this.value);
}

class _TopPortion extends StatefulWidget {
  final String? profilePhotoUrl;
  const _TopPortion({Key? key, this.profilePhotoUrl}) : super(key: key);

  @override
  State<_TopPortion> createState() => _TopPortionState();
}

class _TopPortionState extends State<_TopPortion> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 50),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Color(0xff0043ba), Color(0xff006df1)]),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              )),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: (widget.profilePhotoUrl != null &&
                              widget.profilePhotoUrl!.isNotEmpty)
                          ? NetworkImage(widget.profilePhotoUrl!)
                          : const AssetImage('assets/avatar.png')
                              as ImageProvider,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                          color: Colors.green, shape: BoxShape.circle),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class onBoarding extends StatelessWidget {
  onBoarding({super.key});

  final data = [
    CardOnBoardData(
        title: "Invitation Management App",
        subtitle: "Ahora eres parte de la comunidad lince",
        image: const AssetImage('assets/logo_lince.webp'),
        backgroundColor: Colors.white,
        titleColor: const Color.fromARGB(255, 17, 117, 51),
        subtitleColor: Colors.black,
        background: LottieBuilder.asset('assets/bg.json')),
    CardOnBoardData(
        title: "Problematica",
        subtitle: "AEISC es la asociación estudiantil de tu carrera",
        image: const AssetImage('assets/aeisc.png'),
        backgroundColor: const Color.fromARGB(255, 17, 117, 51),
        titleColor: Colors.white,
        subtitleColor: Colors.black,
        background: LottieBuilder.asset('assets/circuito2.json')),
    CardOnBoardData(
        title: "Objetivo General",
        subtitle:
            "En estos espacios disfrutarás de tu vida universitaria y aprenderás junto a tus compañeros",
        image: const AssetImage('assets/campus2.jpg'),
        backgroundColor: Colors.white,
        titleColor: const Color.fromARGB(255, 27, 57, 106),
        subtitleColor: Colors.black,
        background: LottieBuilder.asset('assets/circuito1.json')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ConcentricPageView(
      colors: data.map((e) => e.backgroundColor).toList(),
      itemCount: data.length,
      itemBuilder: (int index) {
        return CardOnBoard(data: data[index]);
      },
      onFinish: () {
        Navigator.pushNamed(context, '/dash');
      },
    ));
  }
}