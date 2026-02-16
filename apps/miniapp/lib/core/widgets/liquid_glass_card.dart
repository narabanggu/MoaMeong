import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:moameong_miniapp/core/theme/app_palette.dart';

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
    return ColoredBox(
      color: AppPalette.white,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxContentWidth),
          child: child,
        ),
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
    this.tintColor = AppPalette.yellowSoft,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double borderRadius;
  final Color tintColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Colors.white.withValues(alpha: 0.9),
                  tintColor.withValues(alpha: 0.18),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: AppPalette.line.withValues(alpha: 0.48),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppPalette.yellow.withValues(alpha: 0.12),
                  blurRadius: 12,
                  spreadRadius: -6,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  spreadRadius: -8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: padding,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
