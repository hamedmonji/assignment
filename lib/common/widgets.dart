
import 'package:flutter/material.dart';

class AnimatedScaleFade extends StatelessWidget {
  final bool slideOut;
  final Widget child;
  final int scaleDuration;
  final int fadeDuration;
  final Alignment alignment;

  const AnimatedScaleFade(
      {Key? key,
        required this.slideOut,
        required this.child,
        this.scaleDuration = 300,
        this.fadeDuration = 300,
        this.alignment = Alignment.center})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: Duration(milliseconds: scaleDuration),
      alignment: alignment,
      scale: slideOut ? 0 : 1,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: fadeDuration),
        opacity: slideOut ? 0 : 1,
        child: child,
      ),
    );
  }
}