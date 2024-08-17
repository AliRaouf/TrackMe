import 'package:flutter/material.dart';

class ShimmerList extends StatelessWidget {
  final Widget child;
  const ShimmerList({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (context, index) => child,
        itemCount: 10,
        physics: const NeverScrollableScrollPhysics(),
      ),
    );
  }
}
