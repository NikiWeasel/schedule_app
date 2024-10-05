import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_app/screens/main_screen.dart';

class LoginScreen extends StatelessWidget{
  const LoginScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: Center(
          child: SizedBox(
            width: 250,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.logo_dev, size: 100,),

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
                              )                          ),
                          keyboardType: TextInputType.phone,
                          maxLines: 1,
                        ),
                        SizedBox(height: 8,),

                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Пароль',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            )
                          ),


                        ),
                        SizedBox(height: 8,),
                        ElevatedButton(onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => MainScreen()));
                        }, child: const Text('Войти'))
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