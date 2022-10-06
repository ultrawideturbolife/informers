import 'package:flutter/material.dart';

class VerticalShrink extends StatelessWidget {
  const VerticalShrink.showHide({
    required this.show,
    required this.showChild,
    Key? key,
    this.fadeDuration = const Duration(milliseconds: 300),
    this.sizeDuration = const Duration(milliseconds: 300),
    this.fadeInCurve = Curves.easeInOut,
    this.fadeOutCurve = Curves.easeInOut,
    this.sizeCurve = Curves.easeInOut,
    this.alignment = Alignment.center,
    this.hideChild,
    this.width,
  }) : super(key: key);

  static final _key = UniqueKey();
  final Widget showChild;
  final Duration fadeDuration;
  final Duration sizeDuration;
  final Curve fadeInCurve;
  final Curve fadeOutCurve;
  final Curve sizeCurve;
  final AlignmentGeometry alignment;
  final bool show;
  final Widget? hideChild;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: AnimatedSize(
        duration: sizeDuration,
        curve: sizeCurve,
        alignment: alignment,
        child: AnimatedSwitcher(
          duration: fadeDuration,
          switchInCurve: fadeInCurve,
          switchOutCurve: fadeOutCurve,
          transitionBuilder: hideChild != null
              ? (child, animation) => FadeTransition(
                    opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve:
                            const Interval(0.15, 1.0, curve: Curves.easeInOut),
                      ),
                    ),
                    child: child,
                  )
              : AnimatedSwitcher.defaultTransitionBuilder,
          layoutBuilder: (currentChild, previousChildren) {
            List<Widget> children = previousChildren;
            if (currentChild != null) {
              if (previousChildren.isEmpty) {
                children = [currentChild];
              } else {
                children = [
                  Positioned(
                    left: 0.0,
                    right: 0.0,
                    child: previousChildren[0],
                  ),
                  currentChild,
                ];
              }
            }
            return Stack(
              clipBehavior: Clip.none,
              alignment: alignment,
              children: children,
            );
          },
          child: show
              ? showChild
              : (hideChild ??
                  SizedBox(
                    key: _key,
                    width: width ?? double.infinity,
                    height: 0,
                  )),
        ),
      ),
    );
  }
}

class HorizontalShrink extends StatelessWidget {
  const HorizontalShrink.showHide({
    required this.show,
    required this.showChild,
    Key? key,
    this.fadeDuration = const Duration(milliseconds: 300),
    this.sizeDuration = const Duration(milliseconds: 300),
    this.fadeInCurve = Curves.easeInOut,
    this.fadeOutCurve = Curves.easeInOut,
    this.sizeCurve = Curves.easeInOut,
    this.alignment = Alignment.center,
    this.hideChild,
    this.height,
  }) : super(key: key);

  static final _key = UniqueKey();
  final Widget showChild;
  final Duration fadeDuration;
  final Duration sizeDuration;
  final Curve fadeInCurve;
  final Curve fadeOutCurve;
  final Curve sizeCurve;
  final Alignment alignment;
  final bool show;
  final Widget? hideChild;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: AnimatedSize(
        duration: sizeDuration,
        curve: sizeCurve,
        alignment: alignment,
        child: AnimatedSwitcher(
          duration: fadeDuration,
          switchInCurve: fadeInCurve,
          layoutBuilder: (currentChild, previousChildren) {
            List<Widget> children = previousChildren;
            if (currentChild != null) {
              if (previousChildren.isEmpty) {
                children = [currentChild];
              } else {
                children = [
                  Positioned(
                    top: 0,
                    bottom: 0,
                    child: previousChildren[0],
                  ),
                  currentChild,
                ];
              }
            }
            return Stack(
              clipBehavior: Clip.none,
              alignment: alignment,
              children: children,
            );
          },
          switchOutCurve: fadeOutCurve,
          child: show
              ? showChild
              : (hideChild ??
                  SizedBox(
                    key: _key,
                    width: 0,
                    height: height ?? double.infinity,
                  )),
        ),
      ),
    );
  }
}
