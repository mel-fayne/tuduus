import 'package:flutter/material.dart';

class CountWidget extends StatelessWidget {
  final int count;
  const CountWidget({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.tertiary),
      child: Center(
        child: Text(
          count.toString(),
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiaryContainer,
            fontSize: 16,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
