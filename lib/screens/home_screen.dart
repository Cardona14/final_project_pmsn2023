// ignore_for_file: use_build_context_synchronously

import 'package:final_project_pmsn2023/widgets/components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:github_sign_in/github_sign_in.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 15.0, left: 15, bottom: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const TopScreenImage(screenImageName: 'InvitApp.png'),
                      const ScreenTitle(title: 'Hola'),
                      const Text(
                        'Bienvenido a InvitApp, aquí podrás gestionar los accesos a tus eventos',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Hero(
                        tag: 'login_btn',
                        child: CustomButton(
                          buttonText: 'Ingresa',
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Hero(
                        tag: 'signup_btn',
                        child: CustomButton(
                          buttonText: 'Registrate',
                          isOutlined: true,
                          onPressed: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                        ),
                      ),
                      const SizedBox(height: 25),
                      const Text(
                        'Registrate usando',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.transparent,
                              child: Image.asset('assets/icons/facebook.png'),
                            ),
                            onPressed: () async {
                              try {
                                // Iniciar sesión con Facebook
                                final LoginResult loginResult = await FacebookAuth.instance.login(permissions: ['email','public_profile',]);
                                // Verificar si la autenticación fue exitosa
                                if (loginResult.status == LoginStatus.success) {
                                  // Crear una credencial de Facebook usando el token de acceso
                                  final OAuthCredential credential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
                                  // Iniciar sesión con Firebase usando la credencial de Facebook
                                  final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
                                  if (userCredential.user != null) {
                                    Navigator.pushReplacementNamed(context, '/dash');
                                  }
                                }
                              } on FirebaseAuthException catch (e) {
                                print('el error es: $e');
                                if (e.code == 'invalid-credential') {
                                  signUpAlert(
                                    context: context,
                                    onPressed: () {
                                      Navigator.popAndPushNamed(context, '/home');
                                    },
                                    title: 'Error de autenticación',
                                    desc: 'Las credenciales no son válidas',
                                    btnText: 'Prueba Ahora',
                                  ).show();
                                } else {
                                  showAlert(
                                    context: context,
                                    title: 'Error de autenticación',
                                    desc: '$e',
                                    type: AlertType.error,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    }).show();
                                }
                              }
                            },
                          ),
                          IconButton(
                            icon: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.transparent,
                              child: Image.asset('assets/icons/google.png'),
                            ),
                            onPressed: () async{
                              try {
                                final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
                                final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      
                                final credentials = GoogleAuthProvider.credential(
                                  accessToken: googleAuth?.accessToken,
                                  idToken: googleAuth?.idToken,
                                );
                                await FirebaseAuth.instance.signInWithCredential(credentials);
                                
                                final currentUser = FirebaseAuth.instance.currentUser;
                                if (currentUser != null) {
                                  Navigator.pushReplacementNamed(context, '/dash');
                                } else {
                                  showAlert(
                                      context: context,
                                      title: 'Error de autenticación',
                                      desc: 'Ocurrió un error al acceder con Google',
                                      type: AlertType.error,
                                      onPressed: () {
                                        Navigator.pop(context);
                                      }).show();
                                }
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'invalid-credential') {
                                  signUpAlert(
                                    context: context,
                                    onPressed: () {
                                      Navigator.popAndPushNamed(context, '/home');
                                    },
                                    title: 'Error de autenticación',
                                    desc: 'Las credenciales no son válidas',
                                    btnText: 'Prueba Ahora',
                                  ).show();
                                } else {
                                  showAlert(
                                    context: context,
                                    title: 'Error de autenticación',
                                    desc: 'Ocurrió un error al acceder con Google',
                                    type: AlertType.error,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    }).show();
                                }
                              }
                            },
                          ),
                          IconButton(
                            icon: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.transparent,
                              child: Image.asset('assets/icons/github.png'),
                            ),
                            onPressed: () async{
                              try {
                                final GitHubSignIn gitHubSignIn = GitHubSignIn(
                                  clientId: '6ed50ba1e41c4a801cee',
                                  clientSecret: '46ece594f169b99e0001db9d9101221e3b5f34e4',
                                  redirectUrl: 'https://pmsn2023-b50de.firebaseapp.com/__/auth/handler',
                                );

                                // Iniciar sesión con GitHub
                                final result = await gitHubSignIn.signIn(context);
                                // Obtener credenciales de acceso de GitHub
                                if (result != null && result.status == GitHubSignInResultStatus.ok) {
                                  // Obtener credenciales de acceso de GitHub
                                  final GitHubSignInResult gitHubSignInResult = result;
                                  final AuthCredential credentials = GithubAuthProvider.credential(gitHubSignInResult.token!);

                                  // Iniciar sesión con Firebase usando la credencial de GitHub
                                  final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credentials);
                                  if (userCredential.user != null) {
                                    Navigator.popAndPushNamed(context, '/dash');
                                  }
                                }
                              } on FirebaseAuthException catch (e) {
                                print('el error es: $e');
                                if (e.code == 'invalid-credential') {
                                  signUpAlert(
                                    context: context,
                                    onPressed: () {
                                      Navigator.popAndPushNamed(context, '/home');
                                    },
                                    title: 'Error de autenticación',
                                    desc: 'Las credenciales no son válidas',
                                    btnText: 'Prueba Ahora',
                                  ).show();
                                } else {
                                  showAlert(
                                    context: context,
                                    title: 'Error de autenticación',
                                    desc: '$e',
                                    type: AlertType.error,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    }).show();
                                }
                              }
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}