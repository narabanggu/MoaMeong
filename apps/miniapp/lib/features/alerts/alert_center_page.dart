import 'package:flutter/material.dart';
import 'package:moameong_miniapp/core/models/alert_signal.dart';
import 'package:moameong_miniapp/core/theme/app_palette.dart';
import 'package:moameong_miniapp/core/widgets/liquid_glass_card.dart';
import 'package:moameong_miniapp/core/widgets/moameong_branding.dart';

class AlertCenterPage extends StatelessWidget {
  const AlertCenterPage({
    super.key,
    required this.alerts,
    required this.onAddSubscription,
  });

  final List<AlertSignal> alerts;
  final VoidCallback onAddSubscription;

  @override
  Widget build(BuildContext context) {
    if (alerts.isEmpty) {
      return WarmGradientBackground(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: MoaMeongPlainEmptyState(
              message: '임박 알림이 없어요. 새 구독을 추가해 흐름을 점검해보세요.',
              action: onAddSubscription,
              actionLabel: '구독 추가',
              icon: Icons.notifications_none_rounded,
            ),
          ),
        ),
      );
    }

    final highCount =
        alerts.where((a) => a.severity == AlertSeverity.high).length;
    final mediumCount =
        alerts.where((a) => a.severity == AlertSeverity.medium).length;
    final lowCount =
        alerts.where((a) => a.severity == AlertSeverity.low).length;

    return WarmGradientBackground(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        children: <Widget>[
          LiquidGlassCard(
            tintColor: AppPalette.yellowSoft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '임박 결제 알림',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: <Widget>[
                    _CounterBadge(
                      label: '높음 $highCount',
                      color: AppPalette.orangeDeep,
                    ),
                    _CounterBadge(
                      label: '중간 $mediumCount',
                      color: AppPalette.orange,
                    ),
                    _CounterBadge(
                      label: '낮음 $lowCount',
                      color: AppPalette.stable,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ...alerts.map(
            (alert) {
              final severityColor = _severityColor(alert.severity);
              return LiquidGlassCard(
                margin: const EdgeInsets.only(bottom: 8),
                tintColor: severityColor.withValues(alpha: 0.2),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: severityColor.withValues(alpha: 0.14),
                    child: Icon(
                      Icons.notifications_active_outlined,
                      color: severityColor,
                    ),
                  ),
                  title: Text(
                    alert.serviceName,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '${alert.reason}\nD-${alert.daysUntilDue} · ${alert.amount.round()}원',
                    ),
                  ),
                  isThreeLine: true,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Color _severityColor(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.high:
        return AppPalette.orangeDeep;
      case AlertSeverity.medium:
        return AppPalette.orange;
      case AlertSeverity.low:
        return AppPalette.stable;
    }
  }
}

class _CounterBadge extends StatelessWidget {
  const _CounterBadge({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: color.withValues(alpha: 0.22),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}
