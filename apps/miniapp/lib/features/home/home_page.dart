import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:moameong_miniapp/core/models/alert_signal.dart';
import 'package:moameong_miniapp/core/models/cost_snapshot.dart';
import 'package:moameong_miniapp/core/models/subscription_item.dart';
import 'package:moameong_miniapp/core/services/metrics_calculator.dart';
import 'package:moameong_miniapp/core/theme/app_palette.dart';
import 'package:moameong_miniapp/core/widgets/liquid_glass_card.dart';
import 'package:moameong_miniapp/core/widgets/moameong_branding.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.snapshot,
    required this.alerts,
    required this.subscriptions,
    required this.now,
    required this.nowProvider,
    required this.recoveredFromCorruption,
    required this.onAddSubscription,
    required this.onEditSubscription,
    required this.onDeleteSubscription,
  });

  final CostSnapshot snapshot;
  final List<AlertSignal> alerts;
  final List<SubscriptionItem> subscriptions;
  final DateTime now;
  final DateTime Function() nowProvider;
  final bool recoveredFromCorruption;
  final VoidCallback onAddSubscription;
  final ValueChanged<SubscriptionItem> onEditSubscription;
  final ValueChanged<String> onDeleteSubscription;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const double _heroCollapseDistance = 140;
  static const Duration _reactionDuration = Duration(milliseconds: 360);
  static const Duration _reactionCooldown = Duration(milliseconds: 700);

  late final ScrollController _scrollController = ScrollController();
  DateTime? _lastReactionAt;
  bool _isMascotReacting = false;

  double get _collapseProgress {
    if (!_scrollController.hasClients) {
      return 0;
    }
    final clampedOffset =
        _scrollController.offset.clamp(0.0, _heroCollapseDistance).toDouble();
    return clampedOffset / _heroCollapseDistance;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onMascotTap() {
    final now = widget.nowProvider();
    if (_isMascotReacting) {
      return;
    }
    if (_lastReactionAt != null &&
        now.difference(_lastReactionAt!) < _reactionCooldown) {
      return;
    }

    setState(() {
      _isMascotReacting = true;
      _lastReactionAt = now;
    });

    unawaited(
      Future<void>.delayed(_reactionDuration, () {
        if (!mounted) {
          return;
        }
        setState(() {
          _isMascotReacting = false;
        });
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final calculator = MetricsCalculator();
    final prefersReducedMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final now = widget.now;
    final trackableSubscriptions = widget.subscriptions
        .where((item) => item.isTrackable)
        .toList(growable: false)
      ..sort((left, right) =>
          left.nextBillingDate.compareTo(right.nextBillingDate));

    final imminentAlerts = widget.alerts
        .where((item) => item.daysUntilDue >= 0 && item.daysUntilDue <= 7)
        .toList(growable: false);
    final imminentAmount = imminentAlerts.fold<double>(
      0,
      (sum, item) => sum + item.amount,
    );
    final briefing = _buildBriefing(
      imminentCount: imminentAlerts.length,
      imminentAmount: imminentAmount,
      subscriptionCount: trackableSubscriptions.length,
      monthlyTotal: widget.snapshot.monthlyNormalizedTotal,
    );

    SubscriptionItem? upcomingSubscription;
    for (final item in trackableSubscriptions) {
      final days = calculator.daysUntilDue(item.nextBillingDate, now);
      if (days >= 0) {
        upcomingSubscription = item;
        break;
      }
    }

    return WarmGradientBackground(
      child: SafeArea(
        child: ListView(
          controller: _scrollController,
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
          children: <Widget>[
            AnimatedBuilder(
              animation: _scrollController,
              builder: (context, child) => _HeroBriefingCard(
                briefing: briefing,
                upcomingSubscription: upcomingSubscription,
                collapseProgress: _collapseProgress,
                isMascotReacting: _isMascotReacting,
                prefersReducedMotion: prefersReducedMotion,
                onMascotTap: _onMascotTap,
              ),
            ),
            if (widget.recoveredFromCorruption) ...<Widget>[
              const SizedBox(height: 12),
              LiquidGlassCard(
                tintColor: AppPalette.yellowPale,
                child: Row(
                  children: <Widget>[
                    const Icon(
                      Icons.health_and_safety_outlined,
                      color: AppPalette.orange,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '저장 데이터 복구 과정에서 오류가 있어 기본 상태로 시작했어요. 핵심 구독 항목부터 다시 입력해보세요.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            _MonthlyTotalCard(
              monthlyTotal: widget.snapshot.monthlyNormalizedTotal,
              subscriptionCount: trackableSubscriptions.length,
            ),
            const SizedBox(height: 18),
            Row(
              children: <Widget>[
                Text(
                  '구독 목록',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const Spacer(),
                Text(
                  '총 ${trackableSubscriptions.length}개',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppPalette.inkSoft,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (trackableSubscriptions.isEmpty)
              MoaMeongPlainEmptyState(
                message: '아직 구독 데이터가 없어요. 우측 상단 버튼으로 첫 구독을 추가해보세요.',
                action: widget.onAddSubscription,
                actionLabel: '구독 추가',
                icon: Icons.playlist_add_check_circle_outlined,
              )
            else
              ...trackableSubscriptions.map(
                (item) => _SubscriptionTile(
                  item: item,
                  monthlyCost: calculator.toMonthlyNormalized(item),
                  onEditSubscription: widget.onEditSubscription,
                  onDeleteSubscription: widget.onDeleteSubscription,
                ),
              ),
          ],
        ),
      ),
    );
  }

  _Briefing _buildBriefing({
    required int imminentCount,
    required double imminentAmount,
    required int subscriptionCount,
    required double monthlyTotal,
  }) {
    if (imminentCount > 0) {
      return _Briefing(
        headline: '7일 내 결제 $imminentCount건이 예정되어 있어요',
        detail: '이번 주 결제 예상 ${_formatMoney(imminentAmount)}를 먼저 확인해요.',
        isUrgent: true,
      );
    }

    return _Briefing(
      headline: '현재 구독 $subscriptionCount개를 관리 중이에요',
      detail: '월환산 총액은 ${_formatMoney(monthlyTotal)}입니다.',
      isUrgent: false,
    );
  }

  static String _formatMoney(double value) {
    return '${value.round()}원';
  }
}

class _HeroBriefingCard extends StatelessWidget {
  const _HeroBriefingCard({
    required this.briefing,
    required this.upcomingSubscription,
    required this.collapseProgress,
    required this.isMascotReacting,
    required this.prefersReducedMotion,
    required this.onMascotTap,
  });

  final _Briefing briefing;
  final SubscriptionItem? upcomingSubscription;
  final double collapseProgress;
  final bool isMascotReacting;
  final bool prefersReducedMotion;
  final VoidCallback onMascotTap;

  @override
  Widget build(BuildContext context) {
    final progress = collapseProgress.clamp(0.0, 1.0).toDouble();
    final accentColor =
        briefing.isUrgent ? AppPalette.orangeDeep : AppPalette.ink;
    final theme = Theme.of(context);
    final titleBaseSize = theme.textTheme.titleMedium?.fontSize ?? 16;
    final bodyBaseSize = theme.textTheme.bodyMedium?.fontSize ?? 14;
    final labelBaseSize = theme.textTheme.labelLarge?.fontSize ?? 12;
    final bodySmallBaseSize = theme.textTheme.bodySmall?.fontSize ?? 12;
    final mascotSize = lerpDouble(122, 82, progress)!;
    final cardPadding = EdgeInsets.lerp(
      const EdgeInsets.fromLTRB(18, 18, 16, 16),
      const EdgeInsets.fromLTRB(12, 11, 12, 10),
      progress,
    )!;
    final titleFontSize =
        lerpDouble(titleBaseSize + 3, titleBaseSize, progress)!;
    final bodyFontSize = lerpDouble(bodyBaseSize + 1, bodyBaseSize, progress)!;
    final labelFontSize =
        lerpDouble(labelBaseSize + 1, labelBaseSize, progress)!;
    final helperFontSize =
        lerpDouble(bodySmallBaseSize + 0.5, bodySmallBaseSize, progress)!;
    final reducedMotion = prefersReducedMotion || progress > 0.78;

    return LiquidGlassCard(
      padding: cardPadding,
      tintColor: briefing.isUrgent ? AppPalette.yellow : AppPalette.yellowPale,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          MoaMeongAnimatedMascot(
            size: mascotSize,
            isUrgent: briefing.isUrgent,
            isReacting: isMascotReacting,
            reducedMotion: reducedMotion,
            onTap: onMascotTap,
          ),
          SizedBox(width: lerpDouble(12, 8, progress)!),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      briefing.isUrgent
                          ? Icons.warning_amber_rounded
                          : Icons.check_circle_outline_rounded,
                      size: lerpDouble(18, 16, progress)!,
                      color: accentColor,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        briefing.isUrgent ? '이번 주 체크' : '오늘의 요약',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: accentColor,
                          fontWeight: FontWeight.w800,
                          fontSize: labelFontSize,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: lerpDouble(6, 4, progress)!),
                Text(
                  briefing.headline,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: accentColor,
                    fontSize: titleFontSize,
                  ),
                ),
                SizedBox(height: lerpDouble(4, 3, progress)!),
                Text(
                  briefing.detail,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppPalette.inkSoft,
                    fontSize: bodyFontSize,
                  ),
                ),
                if (upcomingSubscription != null) ...<Widget>[
                  SizedBox(height: lerpDouble(8, 6, progress)!),
                  Text(
                    '다음 결제는 ${upcomingSubscription!.name}, ${_dateText(upcomingSubscription!.nextBillingDate)} 예정',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppPalette.inkSoft,
                      fontWeight: FontWeight.w600,
                      fontSize: helperFontSize,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _dateText(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }
}

class _MonthlyTotalCard extends StatelessWidget {
  const _MonthlyTotalCard({
    required this.monthlyTotal,
    required this.subscriptionCount,
  });

  final double monthlyTotal;
  final int subscriptionCount;

  @override
  Widget build(BuildContext context) {
    return LiquidGlassCard(
      tintColor: AppPalette.yellowSoft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '월환산 총액',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppPalette.inkSoft,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${monthlyTotal.round()}원',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: AppPalette.line.withValues(alpha: 0.7),
              ),
            ),
            child: Text(
              '구독 $subscriptionCount개',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubscriptionTile extends StatelessWidget {
  const _SubscriptionTile({
    required this.item,
    required this.monthlyCost,
    required this.onEditSubscription,
    required this.onDeleteSubscription,
  });

  final SubscriptionItem item;
  final double monthlyCost;
  final ValueChanged<SubscriptionItem> onEditSubscription;
  final ValueChanged<String> onDeleteSubscription;

  @override
  Widget build(BuildContext context) {
    return LiquidGlassCard(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: () => onEditSubscription(item),
        title: Text(
          item.name,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            '${_cycleText(item)} · 다음 결제 ${_dateText(item.nextBillingDate)}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppPalette.inkSoft,
                ),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              '${monthlyCost.round()}원',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  onEditSubscription(item);
                } else if (value == 'delete') {
                  onDeleteSubscription(item.id);
                }
              },
              itemBuilder: (_) => const <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'edit',
                  child: Text('수정'),
                ),
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Text('삭제'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _cycleText(SubscriptionItem item) {
    switch (item.cycle) {
      case BillingCycle.monthly:
        return '월 결제';
      case BillingCycle.yearly:
        return '연 결제';
      case BillingCycle.weekly:
        return '주 결제';
      case BillingCycle.customDays:
        return '${item.cycleDays}일 주기';
    }
  }

  String _dateText(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }
}

class _Briefing {
  const _Briefing({
    required this.headline,
    required this.detail,
    required this.isUrgent,
  });

  final String headline;
  final String detail;
  final bool isUrgent;
}
