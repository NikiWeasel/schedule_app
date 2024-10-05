import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircularAvatarButton extends StatefulWidget{
  const CircularAvatarButton({super.key, required this.onTap});

  final void Function() onTap;

  @override
  State<CircularAvatarButton> createState() => _CircularAvatarButtonState();
}

class _CircularAvatarButtonState extends State<CircularAvatarButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(90),


      onTap: widget.onTap,
      child: CircleAvatar(
        child: Icon(Icons.person),
      ),
    );
  }
}