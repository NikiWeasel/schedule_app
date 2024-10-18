import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SheduleApp'),
      ),
      body: const Column(children: [
        Center(child: CircularProgressIndicator()),
      ]),
    );
  }
}
