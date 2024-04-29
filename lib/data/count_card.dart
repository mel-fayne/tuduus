import 'package:flutter/material.dart';

class CountWidget extends StatelessWidget {
  final int count;
  const CountWidget({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 25,
      height: 25,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.tertiary),
      child: Center(
        child: Text(
          count.toString(),
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiaryContainer,
            fontSize: 20,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
