import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.child,
    this.minSize = 0,
    this.onPressed,
    this.padding = EdgeInsets.zero,
    this.pressedOpacity = 0.6,
  }) : super(key: key);

  final Widget child;
  final double minSize;
  final VoidCallback? onPressed;
  final EdgeInsets? padding;
  final double? pressedOpacity;

  @override
  Widget build(BuildContext context) {
    return _CupertinoButtonHijacked(
      onPressed: onPressed,
      padding: padding,
      minSize: minSize,
      pressedOpacity: pressedOpacity,
      child: child,
    );
  }
}

class _CupertinoButtonHijacked extends StatefulWidget {
  const _CupertinoButtonHijacked({
    Key? key,
    required this.child,
    required this.minSize,
    this.padding,
    this.pressedOpacity,
    required this.onPressed,
  }) : super(key: key);

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onPressed;
  final double minSize;
  final double? pressedOpacity;

  bool get enabled => onPressed != null;

  @override
  _CupertinoButtonHijackedState createState() =>
      _CupertinoButtonHijackedState();
}

class _CupertinoButtonHijackedState extends State<_CupertinoButtonHijacked>
    with SingleTickerProviderStateMixin {
  static const Duration _fadeDuration = Duration(milliseconds: 100);
  final Tween<double> _opacityTween = Tween<double>(begin: 1.0);

  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      value: 0.0,
      vsync: this,
    );
    _opacityAnimation = _animationController
        .drive(CurveTween(curve: Curves.decelerate))
        .drive(_opacityTween);
    _setTween();
  }

  @override
  void didUpdateWidget(_CupertinoButtonHijacked old) {
    super.didUpdateWidget(old);
    _setTween();
  }

  void _setTween() {
    _opacityTween.end = widget.pressedOpacity ?? 1.0;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool _buttonHeldDown = false;

  void _handleTapDown(TapDownDetails event) {
    if (!_buttonHeldDown) {
      _buttonHeldDown = true;
      _animate();
    }
  }

  void _handleTapUp(TapUpDetails event) {
    if (_buttonHeldDown) {
      _buttonHeldDown = false;
      _animate();
    }
  }

  void _handleTapCancel() {
    if (_buttonHeldDown) {
      _buttonHeldDown = false;
      _animate();
    }
  }

  void _animate() {
    if (_animationController.isAnimating) return;
    final bool wasHeldDown = _buttonHeldDown;
    final TickerFuture ticker = _buttonHeldDown
        ? _animationController.animateTo(1.0, duration: _fadeDuration)
        : _animationController.animateTo(0.0, duration: _fadeDuration);
    ticker.then<void>((void value) {
      if (mounted && wasHeldDown != _buttonHeldDown) _animate();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool enabled = widget.enabled;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: enabled ? _handleTapDown : null,
      onTapUp: enabled ? _handleTapUp : null,
      onTapCancel: enabled ? _handleTapCancel : null,
      onTap: widget.onPressed,
      child: Semantics(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: widget.minSize,
            minHeight: widget.minSize,
          ),
          child: widget.padding != null
              ? Padding(
                  padding: widget.padding!,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: widget.child,
                  ),
                )
              : FadeTransition(
                  opacity: _opacityAnimation,
                  child: widget.child,
                ),
        ),
      ),
    );
  }
}
