import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_app/screens/main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String userNumber = '';
  String userPassword = '';
  final _formKey = GlobalKey<FormState>();
  bool isChecked = false;

  bool isPasswordObsecure = true;

  void toggleCheckBox() {
    setState(() {
      isChecked = !isChecked;
    });
  }

  void togglePasswordObsec() {
    setState(() {
      isPasswordObsecure = !isPasswordObsecure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: SizedBox(
            width: 250,
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
                        TextFormField(
                          decoration: InputDecoration(
                              hintText: 'Номер',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              )),
                          keyboardType: TextInputType.phone,
                          maxLines: 1,
                          validator: (value) {
                            RegExp regex = RegExp(r'[0-9]');
                            if (value != null && regex.hasMatch(value)) {
                              return null;
                            }
                            return 'Некорректный номер';
                          },
                          onSaved: (value) {
                            userNumber = value!;
                          },
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.black)),
                          child: Row(
                            // mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 165,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8.0,
                                    right: 8.0,
                                    top: 4.0,
                                    bottom: 4.0,
                                  ),
                                  child: TextFormField(
                                    obscureText: isPasswordObsecure,
                                    decoration: const InputDecoration(
                                        hintText: 'Пароль',
                                        border: InputBorder.none),
                                    validator: (value) {
                                      if (value == null || value == '') {
                                        return 'Некорректный пароль';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: togglePasswordObsec,
                                  icon: isPasswordObsecure
                                      ? Icon(Icons.visibility)
                                      : Icon(Icons.visibility_off))
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        CheckboxListTile(
                            title: const Text('Запомни меня'),
                            value: isChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked = value!;
                                print(isChecked);
                              });
                            }),
                        const SizedBox(
                          height: 8,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              // _formKey.currentState!.save();
                              bool validator =
                                  _formKey.currentState!.validate();
                              if (validator) {
                                Route route = MaterialPageRoute(
                                    builder: (ctx) => MainScreen());
                                Navigator.pushReplacement(context, route);
                              }
                            },
                            child: const Text('Войти'))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
