import 'package:flutter/material.dart';

const Duration kFadeOutDuration = Duration(milliseconds: 50);
const Duration kFadeInDuration = Duration(milliseconds: 200);
const Duration kScaleOutDuration = Duration(milliseconds: 0);
const Duration kScaleInDuration = Duration(milliseconds: 200);
final Tween<double> _scaleTween = Tween<double>(begin: 1.0, end: 0.9);

class TickButton extends StatefulWidget {
  const TickButton({
    super.key,
    required this.child,
    this.padding,
    this.onPressed,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
  });

  final Widget? child;

  final EdgeInsetsGeometry? padding;
  final VoidCallback? onPressed;
  final GestureTapUpCallback? onTapUp;
  final GestureTapDownCallback? onTapDown;
  final GestureTapCancelCallback? onTapCancel;

  bool get enabled => onPressed != null;

  @override
  LazyButtonStateS createState() => LazyButtonStateS();
}

class LazyButtonStateS extends State<TickButton> with TickerProviderStateMixin {
  AnimationController? _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      value: 0.0,
      vsync: this,
    );
    _scaleAnimation = _animationController!
        .drive(CurveTween(curve: Curves.easeInOut))
        .drive(_scaleTween);
  }

  @override
  void dispose() {
    _animationController!.dispose();
    _animationController = null;
    super.dispose();
  }

  bool _buttonHeldDown = false;

  void _handleTapDown(TapDownDetails event) {
    widget.onTapDown?.call(event);
    if (!_buttonHeldDown) {
      _buttonHeldDown = true;
      _animate();
    }
  }

  void _handleTapUp(TapUpDetails event) {
    widget.onTapUp?.call(event);
    if (_buttonHeldDown) {
      _buttonHeldDown = false;
      _animate();
    }
  }

  void _handleTapCancel() {
    widget.onTapCancel?.call();
    if (_buttonHeldDown) {
      _buttonHeldDown = false;
      _animate();
    }
  }

  void _animate() {
    if (_animationController!.isAnimating) return;
    final bool wasHeldDown = _buttonHeldDown;
    final TickerFuture ticker = _buttonHeldDown
        ? _animationController!.animateTo(1.0, duration: kScaleOutDuration)
        : _animationController!.animateTo(0.0, duration: kScaleInDuration);
    ticker.then<void>((void value) {
      if (mounted && wasHeldDown != _buttonHeldDown) _animate();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool enabled = widget.enabled;
    var c = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: enabled ? _handleTapDown : null,
      onTapUp: enabled ? _handleTapUp : null,
      onTapCancel: enabled ? _handleTapCancel : null,
      onTap: widget.onPressed,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
    return c;
  }
}
