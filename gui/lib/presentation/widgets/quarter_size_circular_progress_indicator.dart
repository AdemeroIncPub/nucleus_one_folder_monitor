import 'package:flutter/material.dart';

class QuarterSizeCircularProgressIndicator extends StatelessWidget {
  const QuarterSizeCircularProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const AspectRatio(
      aspectRatio: 1,
      child: FractionallySizedBox(
        heightFactor: 0.25,
        widthFactor: 0.25,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
