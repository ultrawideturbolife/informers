import 'package:flutter/material.dart';

/// Holds a title and feature example widget.
class FeatureExample extends StatelessWidget {
  const FeatureExample({
    required this.title,
    required this.child,
    super.key,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.blue,
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(32),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            child: Text(
              title,
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    fontWeight: FontWeight.bold,
                color: Colors.white,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        child,
      ],
    );
  }
}
