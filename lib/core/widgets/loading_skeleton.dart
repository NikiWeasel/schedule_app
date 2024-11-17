import 'package:flutter/material.dart';

class LoadingSkeleton extends StatefulWidget {
  final Widget child; // Виджет, который вы хотите отобразить в виде силуэта.

  const LoadingSkeleton({required this.child, Key? key}) : super(key: key);

  @override
  _LoadingSkeletonState createState() => _LoadingSkeletonState();
}

class _LoadingSkeletonState extends State<LoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(); // Зацикливаем анимацию

    _animation = Tween<double>(begin: -0.3, end: 1.3).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.grey.shade300, // Цвет силуэта
            Colors.black54, // Цвет полоски
            Colors.grey.shade300,
          ],
          stops: [
            _animation.value - 0.3,
            _animation.value,
            _animation.value + 0.3,
          ],
        ).createShader(bounds);
      },
      blendMode: BlendMode.srcATop,
      child: Opacity(
        opacity: 0.5,
        child: widget.child,
      ),
    );
  }
}
