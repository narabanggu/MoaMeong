import 'package:flutter/material.dart';
import 'package:miniapp/core/models/alert_signal.dart';
import 'package:miniapp/core/theme/app_palette.dart';
import 'package:miniapp/core/widgets/liquid_glass_card.dart';
import 'package:miniapp/core/widgets/mascot_branding.dart';

class AlertsDrawer extends StatelessWidget {
  const AlertsDrawer({
    super.key,
    required this.alerts,
    required this.onAddSubscription,
  });

  final List<AlertSignal> alerts;
  final VoidCallback onAddSubscription;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final drawerWidth = (screenWidth * 0.88).clamp(280.0, 380.0).toDouble();
    final highCount =
        alerts.where((item) => item.severity == AlertSeverity.high).length;
    final mediumCount =
        alerts.where((item) => item.severity == AlertSeverity.medium).length;
    final lowCount =
        alerts.where((item) => item.severity == AlertSeverity.low).length;

    return Drawer(
      width: drawerWidth,
      child: SafeArea(
        child: WarmGradientBackground(
          maxContentWidth: drawerWidth,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: Column(
              children: <Widget>[
                LiquidGlassCard(
                  tintColor: AppPalette.yellowPale,
                  padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '알림 센터',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const Icon(Icons.close_rounded),
                        tooltip: '닫기',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: alerts.isEmpty
                      ? Center(
                          child: PlainEmptyState(
                            message: '임박 알림이 없어요. 새 구독을 추가해 흐름을 점검해보세요.',
                            action: () {
                              Navigator.of(context).maybePop();
                              onAddSubscription();
                            },
                            actionLabel: '구독 추가',
                            icon: Icons.notifications_none_rounded,
                          ),
                        )
                      : ListView(
                          padding: EdgeInsets.zero,
                          children: <Widget>[
                            LiquidGlassCard(
                              tintColor: AppPalette.yellowSoft,
                              child: Wrap(
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
                            ),
                            const SizedBox(height: 8),
                            ...alerts
                                .map((alert) => _AlertDetailTile(alert: alert)),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AlertDetailTile extends StatelessWidget {
  const _AlertDetailTile({
    required this.alert,
  });

  final AlertSignal alert;

  @override
  Widget build(BuildContext context) {
    final tone = _severityColor(alert.severity);

    return LiquidGlassCard(
      margin: const EdgeInsets.only(bottom: 8),
      tintColor: tone.withValues(alpha: 0.2),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: tone.withValues(alpha: 0.14),
          child: Icon(
            Icons.notifications_active_outlined,
            color: tone,
          ),
        ),
        title: Text(
          alert.serviceName,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '${alert.reason}\nD-${alert.daysUntilDue} · ${alert.amount.round()}원',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppPalette.inkSoft,
                ),
          ),
        ),
        isThreeLine: true,
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
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
