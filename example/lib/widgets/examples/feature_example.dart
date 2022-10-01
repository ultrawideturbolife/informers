import 'package:example/data/constants/const_durations.dart';
import 'package:example/widgets/util/shrink.dart';
import 'package:flutter/material.dart';

import '../util/custom_button.dart';

/// Holds a title and feature example widget.
class FeatureExample extends StatefulWidget {
  const FeatureExample({
    required this.title,
    required this.child,
    super.key,
  });

  final String title;
  final Widget child;

  @override
  State<FeatureExample> createState() => _FeatureExampleState();
}

class _FeatureExampleState extends State<FeatureExample> {
  final ValueNotifier<bool> _isExpandedNotifier = ValueNotifier(false);

  @override
  void dispose() {
    _isExpandedNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
      decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.2), borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomButton(
            onPressed: () => _isExpandedNotifier.value = !_isExpandedNotifier.value,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                child: Row(
                  children: [
                    const SizedBox(width: 32),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      width: 32,
                      child: ValueListenableBuilder<bool>(
                        valueListenable: _isExpandedNotifier,
                        builder: (context, isExpanded, child) => AnimatedRotation(
                          duration: ConstDurations.defaultAnimationDuration,
                          turns: isExpanded ? 0.5 : 1,
                          child: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _isExpandedNotifier,
            builder: (context, isExpanded, _) => VerticalShrink.showHide(
              show: isExpanded,
              showChild: widget.child,
              alignment: Alignment.topCenter,
            ),
          )
        ],
      ),
    );
  }
}
