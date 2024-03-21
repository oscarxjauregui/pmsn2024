import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pmsn2024/screens/dashboard_screen.dart';
import 'package:pmsn2024/services/email_auth_farebase.dart';

class ImageController extends ChangeNotifier {
  File? _imageFile;

  File? get imageFile => _imageFile;

  void setImageFile(File? imageFile) {
    _imageFile = imageFile;
    notifyListeners();
  }
}

TextEditingController conUser = TextEditingController(text: "");
TextEditingController conEmail = TextEditingController(text: "");
TextEditingController conPwd = TextEditingController(text: "");

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({Key? key}) : super(key: key);

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  bool isLoading = false;
  late ImageController imageController;
  final _formKey = GlobalKey<FormState>();

  final authFirebase = EmailAuthFirebase();

  final txtUser = TextFormField(
    keyboardType: TextInputType.text,
    controller: conUser,
    decoration: const InputDecoration(border: OutlineInputBorder()),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Ingresa el nombre';
      }
      return null;
    },
  );

  final txtEmail = TextFormField(
    keyboardType: TextInputType.emailAddress,
    controller: conEmail,
    decoration: const InputDecoration(border: OutlineInputBorder()),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Ingresa el email';
      }
      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
        return 'Email invalido';
      }
      return null;
    },
  );

  final pwdUser = TextFormField(
    keyboardType: TextInputType.text,
    controller: conPwd,
    obscureText: true,
    decoration: const InputDecoration(border: OutlineInputBorder()),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Ingresa la contraseña';
      }
      return null;
    },
  );


  Future<void> imgAvatar(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          imageController.setImageFile(File(pickedFile.path));
        });
      }
    } catch (e) {
      print("Error al seleccionar la imagen: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    imageController = ImageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              child: Container(
                height: 600,
                width: MediaQuery.of(context).size.width * .9,
                child: Form(
                  key: _formKey,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      SizedBox(
                        height: 30,
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text('Nombre'),
                        ),
                      ),
                      txtUser,
                      SizedBox(
                        height: 30,
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text('Email'),
                        ),
                      ),
                      txtEmail,
                      SizedBox(
                        height: 30,
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text('Contraseña'),
                        ),
                      ),
                      pwdUser,
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return ListView(
                                padding: EdgeInsets.all(10),
                                children: [
                                  SizedBox(
                                    height: 50,
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: Text('Seleccionar imagen'),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      imgAvatar(ImageSource.gallery);
                                    },
                                    child: Text('Desde la galeria'),
                                    
                                  ),
                                  SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: () {
                                      imgAvatar(ImageSource.camera);
                                    },
                                    child: Text('Desde la camara'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text('Seleccionar avatar'),
                      ),
                      /*imageController.imageFile != null
                          ? Image.file(imageController.imageFile!)
                          : const Text(''),*/
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            authFirebase.signUpUser(name: conUser.text, password: conPwd.text, email: conEmail.text).then((value) {
                              if(value)
                              {
                                if (imageController.imageFile == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Selecciona un avatar.'),
                                ),
                              );
                            } else {
                              setState(() {
                                isLoading = !isLoading;
                              });
                              Future.delayed(
                                const Duration(microseconds: 3000),
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DashboardScreen(
                                        /*conUser.text,
                                        conEmail.text,
                                        imageController.imageFile!,*/
                                      ),
                                    ),
                                  ).then((value) {
                                    setState(() {
                                      isLoading = !isLoading;
                                    });
                                  });
                                },
                              );
                            }
                              }
                            });
                          }
                        },
                        child: Text('Registrarse'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            isLoading
                ? Positioned(
                    top: 260,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
