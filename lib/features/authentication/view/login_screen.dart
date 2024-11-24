import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_app/features/home/view/home_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:schedule_app/features/authentication/view/widgets/user_image_picker.dart';

final _firebase = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _enteredName = '';
  String _enteredSurname = '';
  String _enteredEmail = '';
  String _enteredNumber = '';
  String _enteredPassword = '';
  final _formKey = GlobalKey<FormState>();
  bool _doRemember = true;
  bool _isLogin = true;
  File? _selectedImage;
  var _isAuthing = false;

  bool isPasswordObsecure = true;

  void toggleRememberMe() {
    setState(() {
      _doRemember = !_doRemember;
    });
  }

  void togglePasswordObsec() {
    setState(() {
      isPasswordObsecure = !isPasswordObsecure;
    });
  }

  void _submit() async {
    // await FirebaseAuth.instance.setPersistence(Persistence.NONE);

    var isValid = _formKey.currentState!.validate();

    if (!isValid || !_isLogin && _selectedImage == null) {
      return;
    }

    _formKey.currentState!.save();

    try {
      setState(() {
        _isAuthing = true;
      });
      // if (_doRemember) {
      //   await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
      // } else {
      //   await FirebaseAuth.instance.setPersistence(Persistence.NONE);
      // }

      if (_isLogin) {
        final userCredentials = await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
        // print(userCredentials);
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
        // print(userCredentials);
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userCredentials.user!.uid}.jpg');

        await storageRef.putFile(_selectedImage!);
        final imageUrl = await storageRef.getDownloadURL();
        // print(imageUrl);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user!.uid)
            .set({
          'name': _enteredName,
          'surname': _enteredSurname,
          'email': _enteredEmail,
          'number': _enteredNumber,
          'image_url': imageUrl,
          'description': '',
        });
        // widget.renew();
      }
    } on FirebaseAuthException catch (error) {
      // print(error.code + error.message.toString());
      if (error.code == 'email-already-in-use') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(error.message ??
                  'email уже используется\nemail-already-in-use.')));
        }
      }
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(error.message ??
                'Что-то пошло не так...\nAuthentification failed.')));
      }

      setState(() {
        _isAuthing = false;
      });
      // widget.renew();
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    if (width > 450) {
      width = 400;
    }
    var cardColor = Theme.of(context).cardTheme.color;

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: SizedBox(
            width: width - 20,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.logo_dev,
                    size: 100,
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          if (!_isLogin)
                            UserImagePicker(
                              onPickedImage: (File pickedImage) {
                                _selectedImage = pickedImage;
                              },
                            ),
                          if (!_isLogin)
                            TextFormField(
                              decoration: InputDecoration(
                                  labelText: 'Имя',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  )),
                              enableSuggestions: false,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().length < 2 ||
                                    value.trim().length > 12) {
                                  return 'Некорректное имя';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredName = value!;
                              },
                            ),
                          if (!_isLogin)
                            const SizedBox(
                              height: 8,
                            ),
                          if (!_isLogin)
                            TextFormField(
                              decoration: InputDecoration(
                                  labelText: 'Фамилия',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  )),
                              enableSuggestions: false,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().length < 2 ||
                                    value.trim().length > 12) {
                                  return 'Некорректная фамилия';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredSurname = value!;
                              },
                            ),
                          if (!_isLogin)
                            const SizedBox(
                              height: 8,
                            ),
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Эл. почта',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                )),
                            keyboardType: TextInputType.emailAddress,
                            maxLines: 1,
                            validator: (value) {
                              RegExp regex = RegExp(r'''''');
                              if (value != null &&
                                  regex.hasMatch(value) &&
                                  value != '') {
                                return null;
                              }
                              return 'Некорректная эл. почта';
                            },
                            onSaved: (value) {
                              _enteredEmail = value!;
                            },
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          if (!_isLogin)
                            TextFormField(
                              decoration: InputDecoration(
                                  labelText: 'Номер телефона',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  )),
                              keyboardType: TextInputType.phone,
                              maxLines: 1,
                              validator: (value) {
                                RegExp regex = RegExp(r'''''');
                                if (value != null &&
                                    regex.hasMatch(value) &&
                                    value != '') {
                                  return null;
                                }
                                return 'Некорректный номер телефона';
                              },
                              onSaved: (value) {
                                _enteredNumber = value!;
                              },
                            ),
                          if (!_isLogin)
                            const SizedBox(
                              height: 8,
                            ),
                          Stack(children: [
                            TextFormField(
                              obscureText: isPasswordObsecure,
                              decoration: InputDecoration(
                                  labelText: 'Пароль',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  )),
                              validator: (value) {
                                if (value == null || value == '') {
                                  return 'Некорректный пароль';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredPassword = value!;
                              },
                            ),
                            Positioned(
                                right: 5,
                                top: 3.5,
                                child: Container(
                                  color: cardColor,
                                  child: IconButton(
                                      onPressed: togglePasswordObsec,
                                      icon: isPasswordObsecure
                                          ? const Icon(Icons.visibility)
                                          : const Icon(Icons.visibility_off)),
                                ))
                          ]),
                          const SizedBox(
                            height: 8,
                          ),
                          CheckboxListTile(
                              title: const Text('Оставаться в аккаунте'),
                              value: _doRemember,
                              onChanged: (bool? value) {
                                toggleRememberMe();
                              }),
                          const SizedBox(
                            height: 8,
                          ),
                          if (_isAuthing) const CircularProgressIndicator(),
                          ElevatedButton(
                              onPressed: _submit,
                              child: Text(
                                  _isLogin ? 'Войти' : 'Зарегистрироваться')),
                          if (!_isAuthing)
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isLogin = !_isLogin;
                                  });
                                },
                                child: Text(_isLogin
                                    ? 'Создать аккаунт'
                                    : 'Уже есть аккаунт')),
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
