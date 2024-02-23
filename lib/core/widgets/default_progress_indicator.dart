import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DefaultProgressIndicator extends StatelessWidget {
  final double size;

  const DefaultProgressIndicator({super.key, this.size = 40.0});

  @override
  Widget build(BuildContext context) {
    return SpinKitChasingDots(
      color: Theme.of(context).colorScheme.primary,
      size: size,
    );
  }
}
