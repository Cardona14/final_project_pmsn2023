// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_pmsn2023/contants.dart';
import 'package:final_project_pmsn2023/widgets/components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _auth = FirebaseAuth.instance;
  late String _name;
  late String _lastName;
  late String _phoneNumber;
  late String _photoURL;
  late String _email;
  late String _password;
  late String _confirmPass;
  DateTime _dateOfBirth = DateTime.now();
  File? _imageFile;
  bool _saving = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  bool get _isRegisterButtonEnabled =>
      _nameController.text.isNotEmpty &&
      _lastnameController.text.isNotEmpty &&
      _phoneController.text.isNotEmpty &&
      _dateController.text.isNotEmpty &&
      _emailController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty &&
      _confirmController.text.isNotEmpty;

  //selector de fecha
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _dateOfBirth) {
      setState(() {
        _dateOfBirth = picked;
        _dateController.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }
  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  final ImagePicker _picker = ImagePicker();
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  Future<void> _showPicker(context) async {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popAndPushNamed(context, '/home');
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LoadingOverlay(
          isLoading: _saving,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [ 
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const ScreenTitle(title: 'Inicia tu Registro'),
                          GestureDetector(
                            onTap: () => _showPicker(context),
                            child: CircleAvatar(
                              radius: 80,
                              backgroundColor: Colors.grey[300],
                              backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                              child: _imageFile == null ? const Icon(Icons.camera_alt, size: 50) : null,
                            ),
                          ),
                          CustomTextField(
                            textField: TextField(
                              onChanged: (value) {
                                _name = value;
                              },
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              decoration: kTextInputDecoration.copyWith(
                                hintText: 'Nombre',
                              ),
                              controller: _nameController,
                            ),
                          ),
                          CustomTextField(
                            textField: TextField(
                              onChanged: (value) {
                                _lastName = value;
                              },
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              decoration: kTextInputDecoration.copyWith(
                                hintText: 'Apellidos',
                              ),
                              controller: _lastnameController,
                            ),
                          ),
                          CustomTextField(
                            textField: TextField(
                              onChanged: (value) {
                                _phoneNumber = value;
                              },
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              decoration: kTextInputDecoration.copyWith(
                                hintText: 'Número telefónico',
                              ),
                              controller: _phoneController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10)
                              ]
                            ),
                          ),
                          CustomTextField(
                            textField: TextField(
                              readOnly: true,
                              onChanged: (value) {
                                _dateOfBirth = value as DateTime;
                              },
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              decoration: kTextInputDecoration.copyWith(
                                hintText: 'Fecha de Nacimiento',
                              ),
                              controller: _dateController,
                              onTap: () => _selectDate(context),
                            ),
                          ),
                          CustomTextField(
                            textField: TextField(
                              onChanged: (value) {
                                _email = value;
                              },
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              decoration: kTextInputDecoration.copyWith(
                                hintText: 'Correo electrónico',
                              ),
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              inputFormatters: [
                                FilteringTextInputFormatter.singleLineFormatter,
                                LengthLimitingTextInputFormatter(50),
                              ]
                            ),
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
                              decoration: kTextInputDecoration.copyWith(
                                hintText: 'Contraseña',
                              ),
                              controller: _passwordController,
                            ),
                          ),
                          CustomTextField(
                            textField: TextField(
                              obscureText: true,
                              onChanged: (value) {
                                _confirmPass = value;
                              },
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              decoration: kTextInputDecoration.copyWith(
                                hintText: 'Confirma tu contraseña',
                              ),
                              controller: _confirmController,
                            ),
                          ),
                          CustomBottomScreen(
                            textButton: 'Registrate',
                            heroTag: 'signup_btn',
                            question: 'Ya tiene una cuenta?',
                            buttonPressed: () async {
                              if (_isRegisterButtonEnabled) {
                                FocusManager.instance.primaryFocus?.unfocus();
                                setState(() {
                                  _saving = true;
                                });
                                if (_confirmPass == _password) {
                                  try {
                                    //Se crea el usuario en Firebase Auth
                                    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: _email, password: _password);
                                    //Se envia un correo de verificación
                                    await userCredential.user!.sendEmailVerification();
                                    //Se obtiene el ID unico de usuario
                                    String? uid = _auth.currentUser?.uid;
                                    //Se sube la imagen a Firebase Storage
                                    try {
                                      Reference storageReference = FirebaseStorage.instance.ref().child('profile_images/$uid');
                                      UploadTask uploadTask = storageReference.putFile(_imageFile!);
                                      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
                                      _photoURL = await taskSnapshot.ref.getDownloadURL();
                                    } catch (e) {
                                      showAlert(
                                        context: context,
                                        type: AlertType.error,
                                        title: 'Ocurrió un error',
                                        desc: 'Ocurrió un error al subir la imagen, intentalo más tarde',
                                        onPressed: () {
                                          setState(() {_saving = false;});
                                          Navigator.popAndPushNamed(context, '/signup');
                                        }).show();
                                    }
                                    //Se crea un doc en Firestore para los datos del perfil
                                    FirebaseFirestore.instance.collection('users').doc(uid).set({
                                      'name': _name,
                                      'lastName': _lastName,
                                      'phoneNumber': _phoneNumber,
                                      'photoURL' : _photoURL,
                                      'dateOfBirth' : _dateOfBirth
                                    });
                                        
                                    if (context.mounted) {
                                      signUpAlert(
                                        context: context,
                                        title: 'EXCELENTE',
                                        desc: 'Ahora ya puede iniciar sesión',
                                        btnText: 'Acceder',
                                        onPressed: () {
                                          setState(() {
                                            _saving = false;
                                            Navigator.popAndPushNamed(context, '/signup');
                                          });
                                          Navigator.pushNamed(context, '/login');
                                        },
                                      ).show();
                                    }
                                  } on FirebaseAuthException catch (e) {
                                    if (e.code == 'weak-password') {
                                      showAlert(
                                        context: context,
                                        title: 'Contraseña demisiado debil',
                                        desc: 'Tu contraseña debe tener más de 6 caracteres',
                                        type: AlertType.info,
                                        onPressed: () {
                                          setState(() {_saving = false;});
                                          Navigator.pop(context);
                                        }).show();
                                    } else if (e.code == 'email-already-in-use') {
                                      showAlert(
                                        context: context,
                                        title: 'Usuario ya existente',
                                        desc: 'El correo ingresado ya esta asociado a una cuenta existente',
                                        type: AlertType.error,
                                        onPressed: () {
                                          setState(() {_saving = false;});
                                          Navigator.pop(context);
                                        }).show();
                                    } else if (e.code == 'invalid-email') {
                                      showAlert(
                                        context: context,
                                        title: 'Correo no valido',
                                        desc: 'Revisa que tu correo sea valido',
                                        type: AlertType.error,
                                        onPressed: () {
                                          setState(() {_saving = false;});
                                          Navigator.pop(context);
                                        }).show();
                                    }
                                  }
                                } else {
                                  showAlert(
                                    context: context,
                                    type: AlertType.warning,
                                    title: 'CONTRASEÑA ERRONEA',
                                    desc:'Asegurate que hayas escrito la misma contraseña',
                                    onPressed: () {
                                      setState(() {_saving = false;});
                                      Navigator.pop(context);
                                    }).show();
                                }
                              } else {
                                showAlert(
                                  context: context,
                                  type: AlertType.info,
                                  title: 'Información faltante',
                                  desc: 'Debes llenar todos los campos para registrarte',
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }).show();
                              }
                            },
                            questionPressed: () async {
                              Navigator.pushNamed(context, '/login');
                            },
                          ),
                        ],
                      ),
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