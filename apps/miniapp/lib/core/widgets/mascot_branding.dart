import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:miniapp/core/theme/app_palette.dart';
import 'package:miniapp/core/widgets/liquid_glass_card.dart';

const String kMascotBodyAsset = 'assets/characters/maltipoo_mascot.svg';

class MascotBrandBar extends StatelessWidget {
  const MascotBrandBar({super.key});

  @override
  Widget build(BuildContext context) {
    return LiquidGlassCard(
      borderRadius: 22,
      tintColor: AppPalette.white,
      child: Row(
        children: <Widget>[
          const MascotCharacter(size: 74),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '모아멍',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  '귀엽게 모으고, 똑똑하게 줄여요',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppPalette.inkSoft,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MascotCharacter extends StatelessWidget {
  const MascotCharacter({
    super.key,
    this.size = 120,
    this.showFrame = true,
  });

  final double size;
  final bool showFrame;

  @override
  Widget build(BuildContext context) {
    final character = SvgPicture.asset(
      kMascotBodyAsset,
      fit: BoxFit.contain,
    );

    if (!showFrame) {
      return SizedBox(
        width: size,
        height: size,
        child: character,
      );
    }

    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.06),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.3),
        gradient: LinearGradient(
          colors: <Color>[
            AppPalette.yellowSoft.withValues(alpha: 0.78),
            AppPalette.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: AppPalette.line.withValues(alpha: 0.9),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppPalette.yellow.withValues(alpha: 0.2),
            blurRadius: size * 0.22,
            spreadRadius: -size * 0.12,
            offset: Offset(0, size * 0.09),
          ),
        ],
      ),
      child: character,
    );
  }
}

class AnimatedMascotFace extends StatefulWidget {
  const AnimatedMascotFace({
    super.key,
    required this.size,
    required this.isUrgent,
    required this.isReacting,
    required this.onTap,
    this.reducedMotion = false,
  });

  final double size;
  final bool isUrgent;
  final bool isReacting;
  final bool reducedMotion;
  final VoidCallback onTap;

  @override
  State<AnimatedMascotFace> createState() => _AnimatedMascotFaceState();
}

class _AnimatedMascotFaceState extends State<AnimatedMascotFace>
    with TickerProviderStateMixin {
  static const Duration _idleDuration = Duration(milliseconds: 2400);
  static const Duration _reactionDuration = Duration(milliseconds: 360);
  static const Duration _blinkDuration = Duration(milliseconds: 130);
  static const Duration _urgentHintDuration = Duration(milliseconds: 1600);
  static const Duration _calmHintDuration = Duration(milliseconds: 2200);

  late final AnimationController _idleController = AnimationController(
    vsync: this,
    duration: _idleDuration,
  );

  late final AnimationController _reactionController = AnimationController(
    vsync: this,
    duration: _reactionDuration,
  );

  late final Animation<double> _reactionScale =
      TweenSequence<double>(<TweenSequenceItem<double>>[
    TweenSequenceItem<double>(
      tween: Tween<double>(begin: 1.0, end: 1.08)
          .chain(CurveTween(curve: Curves.easeOutCubic)),
      weight: 120,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(begin: 1.08, end: 0.97)
          .chain(CurveTween(curve: Curves.easeInOut)),
      weight: 100,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(begin: 0.97, end: 1.0)
          .chain(CurveTween(curve: Curves.easeOut)),
      weight: 140,
    ),
  ]).animate(_reactionController);

  late final AnimationController _stateHintController = AnimationController(
    vsync: this,
    duration: _stateHintDuration(widget.isUrgent),
  );

  late final AnimationController _blinkController = AnimationController(
    vsync: this,
    duration: _blinkDuration,
  );

  final math.Random _random = math.Random();
  Timer? _blinkTimer;

  static Duration _stateHintDuration(bool isUrgent) {
    return isUrgent ? _urgentHintDuration : _calmHintDuration;
  }

  @override
  void initState() {
    super.initState();
    _syncMotionLoops(restartStateHint: true);
  }

  @override
  void didUpdateWidget(covariant AnimatedMascotFace oldWidget) {
    super.didUpdateWidget(oldWidget);
    final urgencyChanged = oldWidget.isUrgent != widget.isUrgent;
    final reducedMotionChanged =
        oldWidget.reducedMotion != widget.reducedMotion;

    if (oldWidget.isUrgent != widget.isUrgent) {
      _stateHintController.duration = _stateHintDuration(widget.isUrgent);
    }
    if (urgencyChanged || reducedMotionChanged) {
      _syncMotionLoops(restartStateHint: urgencyChanged);
    }
    if (!oldWidget.isReacting && widget.isReacting) {
      _reactionController.forward(from: 0);
    }
  }

  void _syncMotionLoops({required bool restartStateHint}) {
    if (widget.reducedMotion) {
      _idleController
        ..stop()
        ..value = 0;
      _stateHintController
        ..stop()
        ..value = 0;
      _blinkTimer?.cancel();
      _blinkTimer = null;
      return;
    }

    if (!_idleController.isAnimating) {
      _idleController.repeat(reverse: true);
    }
    if (restartStateHint || !_stateHintController.isAnimating) {
      _stateHintController
        ..stop()
        ..repeat(reverse: true);
    }
    if (!(_blinkTimer?.isActive ?? false)) {
      _scheduleBlink();
    }
  }

  void _scheduleBlink() {
    if (widget.reducedMotion) {
      _blinkTimer = null;
      return;
    }
    _blinkTimer?.cancel();
    final milliseconds = 3200 + _random.nextInt(2601);
    _blinkTimer = Timer(Duration(milliseconds: milliseconds), _triggerBlink);
  }

  Future<void> _triggerBlink() async {
    if (!mounted) {
      return;
    }
    await _blinkController.forward(from: 0);
    if (!mounted) {
      return;
    }
    await _blinkController.reverse();
    if (!mounted) {
      return;
    }
    _scheduleBlink();
  }

  @override
  void dispose() {
    _blinkTimer?.cancel();
    _idleController.dispose();
    _reactionController.dispose();
    _stateHintController.dispose();
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animation = Listenable.merge(
      <Listenable>[
        _idleController,
        _reactionController,
        _stateHintController,
        _blinkController,
      ],
    );

    return Semantics(
      button: true,
      label: '모아멍 비서 캐릭터',
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: widget.size,
          height: widget.size,
          child: AnimatedBuilder(
            animation: animation,
            child: MascotCharacter(
              size: widget.size,
              showFrame: false,
            ),
            builder: (context, child) {
              final idleScale = widget.reducedMotion
                  ? 1.0
                  : 0.992 + (_idleController.value * 0.018);
              final idleOffset =
                  widget.reducedMotion ? 0.0 : -1.2 * _idleController.value;

              final stateHintScale = widget.reducedMotion || widget.isReacting
                  ? 1.0
                  : widget.isUrgent
                      ? 1.0 + (_stateHintController.value * 0.03)
                      : 1.0 + (_stateHintController.value * 0.014);
              final stateHintOffset = widget.reducedMotion || widget.isReacting
                  ? 0.0
                  : widget.isUrgent
                      ? -1.6 * _stateHintController.value
                      : -2.2 * _stateHintController.value;

              final reactionScale = widget.isReacting
                  ? widget.reducedMotion
                      ? 1.0 + (_reactionController.value * 0.012)
                      : _reactionScale.value
                  : 1.0;
              final reactionRotation = widget.isReacting &&
                      !widget.reducedMotion
                  ? math.sin(_reactionController.value * math.pi * 4) * 0.045
                  : 0.0;

              final scale = idleScale * stateHintScale * reactionScale;
              final offsetY = idleOffset + stateHintOffset;
              final blinkOpacity =
                  widget.reducedMotion ? 0.0 : _blinkController.value;
              final blinkHeight =
                  (widget.size * 0.055 * blinkOpacity).clamp(1.0, 5.0);
              final stateKey = widget.isReacting
                  ? 'reacting'
                  : widget.isUrgent
                      ? 'hint-urgent'
                      : 'hint-calm';

              return KeyedSubtree(
                key: ValueKey<String>('mascot-state-$stateKey'),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Transform.translate(
                      offset: Offset(0, offsetY),
                      child: Transform.rotate(
                        angle: reactionRotation,
                        child: Transform.scale(
                          scale: scale,
                          child: child,
                        ),
                      ),
                    ),
                    if (blinkOpacity > 0.03)
                      Positioned(
                        top: widget.size * 0.34,
                        left: widget.size * 0.28,
                        right: widget.size * 0.28,
                        child: Opacity(
                          opacity: blinkOpacity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              _BlinkLid(
                                width: widget.size * 0.14,
                                height: blinkHeight,
                              ),
                              _BlinkLid(
                                width: widget.size * 0.14,
                                height: blinkHeight,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _BlinkLid extends StatelessWidget {
  const _BlinkLid({
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFC28A58).withValues(alpha: 0.84),
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class PlainEmptyState extends StatelessWidget {
  const PlainEmptyState({
    super.key,
    required this.message,
    this.action,
    this.actionLabel,
    this.icon = Icons.inbox_outlined,
  });

  final String message;
  final VoidCallback? action;
  final String? actionLabel;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return LiquidGlassCard(
      borderRadius: 20,
      tintColor: AppPalette.white,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppPalette.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: AppPalette.line,
              ),
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              color: AppPalette.inkSoft,
            ),
          ),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 260),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.4,
                  ),
            ),
          ),
          if (action != null && actionLabel != null) ...<Widget>[
            const SizedBox(height: 12),
            FilledButton(
              onPressed: action,
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}
