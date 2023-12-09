// ignore_for_file: use_build_context_synchronously

import 'package:final_project_pmsn2023/contants.dart';
import 'package:final_project_pmsn2023/widgets/components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  late String _email;
  late String _password;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popAndPushNamed(context, '/home');
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LoadingOverlay(
          isLoading: _saving,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const TopScreenImage(screenImageName: 'welcome.png'),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const ScreenTitle(title: 'Login'),
                        CustomTextField(
                          textField: TextField(
                              onChanged: (value) {
                                _email = value;
                              },
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              decoration: kTextInputDecoration.copyWith(hintText: 'Correo electrónico')),
                        ),
                        CustomTextField(
                          textField: TextField(
                            obscureText: true,
                            onChanged: (value) {
                              _password = value;
                            },
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                            decoration: kTextInputDecoration.copyWith(hintText: 'Contraseña'),
                          ),
                        ),
                        CustomBottomScreen(
                          textButton: 'Login',
                          heroTag: 'login_btn',
                          question: 'Olvidaste tu contraseña?',
                          buttonPressed: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            setState(() {
                              _saving = true;
                            });
                            try {
                              await _auth.signInWithEmailAndPassword(email: _email, password: _password);
                              if (context.mounted && _auth.currentUser!.emailVerified) {
                                setState(() {
                                  _saving = false;
                                  Navigator.popAndPushNamed(context, '/login');
                                });
                                Navigator.pushNamed(context, '/dash');
                              } else if (!_auth.currentUser!.emailVerified){
                                signUpAlert(
                                  context: context,
                                  onPressed: () {
                                    setState(() {
                                      _saving = false;
                                    });
                                    Navigator.popAndPushNamed(context, '/login');
                                  },
                                  title: 'Correo no verificado',
                                  desc: 'Revisa tu correo e ingresa al link para verificarlo',
                                  btnText: 'Reintentar',
                                ).show();
                              }
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'user-not-found') {
                                signUpAlert(
                                  context: context,
                                  onPressed: () {
                                    setState(() {
                                      _saving = false;
                                    });
                                    Navigator.popAndPushNamed(context, '/home');
                                  },
                                  title: 'Usuario no encontrado',
                                  desc: 'Al parecer aún no tienes una cuenta registrada a este correo',
                                  btnText: 'Reintentar',
                                ).show();
                              } else if (e.code == 'wrong-password' || e.code == 'invalid-email') {
                                signUpAlert(
                                  context: context,
                                  onPressed: () {
                                    setState(() {
                                      _saving = false;
                                    });
                                    Navigator.popAndPushNamed(context, '/login');
                                  },
                                  title: 'CONTRASEÑA O CORREO ERRONEOS',
                                  desc: 'Confirma tu correo y contraseña e intenta de nuevo',
                                  btnText: 'Reintentar',
                                ).show();
                              }
                              
                            }
                          },
                          questionPressed: () {
                            signUpAlert(
                              onPressed: () async {
                                await FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
                              },
                              title: 'RESTABLECE TU CONSTASEÑA',
                              desc: 'Presiona el boton para restablecer tu contraseña',
                              btnText: 'Restablecer',
                              context: context,
                            ).show();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}