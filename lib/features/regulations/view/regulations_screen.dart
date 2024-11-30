import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegulationsScreen extends StatelessWidget {
  const RegulationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Регламент'),
      ),
      body: Center(
        child: Text('regulations'),
      ),
    );
  }
}
