import 'package:flutter/material.dart';
import 'package:miniapp/core/theme/app_palette.dart';

class WarmGradientBackground extends StatelessWidget {
  const WarmGradientBackground({
    super.key,
    required this.child,
    this.maxContentWidth = 430,
  });

  final Widget child;
  final double maxContentWidth;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppPalette.background,
        gradient: LinearGradient(
          colors: <Color>[
            Color(0xFFF4F5F7),
            Color(0xFFF1F3F6),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: -120,
            left: -50,
            child: _GlowOrb(
              size: 220,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
          Positioned(
            top: 120,
            right: -70,
            child: _GlowOrb(
              size: 170,
              color: Colors.white.withValues(alpha: 0.45),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxContentWidth),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

class LiquidGlassCard extends StatelessWidget {
  const LiquidGlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.margin = EdgeInsets.zero,
    this.borderRadius = 18,
    this.tintColor = AppPalette.white,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double borderRadius;
  final Color tintColor;

  @override
  Widget build(BuildContext context) {
    final hasTint = tintColor != AppPalette.white;

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: AppPalette.white,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: AppPalette.line,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppPalette.shadow.withValues(alpha: 0.09),
            blurRadius: 26,
            spreadRadius: -16,
            offset: const Offset(0, 14),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.9),
            blurRadius: 2,
            spreadRadius: 0,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                AppPalette.white,
                hasTint ? tintColor.withValues(alpha: 0.24) : AppPalette.white,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: <Color>[
              color,
              color.withValues(alpha: 0),
            ],
            stops: const <double>[0, 1],
          ),
        ),
      ),
    );
  }
}
