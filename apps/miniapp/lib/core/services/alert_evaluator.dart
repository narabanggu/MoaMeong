import 'package:miniapp/core/models/alert_signal.dart';
import 'package:miniapp/core/models/subscription_item.dart';
import 'package:miniapp/core/services/metrics_calculator.dart';

class AlertEvaluator {
  AlertEvaluator(this._metricsCalculator);

  final MetricsCalculator _metricsCalculator;

  List<AlertSignal> buildAlerts({
    required List<SubscriptionItem> subscriptions,
    required DateTime now,
  }) {
    final alerts = <AlertSignal>[];

    for (final item in subscriptions) {
      if (!item.isTrackable) {
        continue;
      }

      final days = _metricsCalculator.daysUntilDue(item.nextBillingDate, now);
      if (days > 30) {
        continue;
      }

      final severity = _resolveSeverity(days);
      alerts.add(
        AlertSignal(
          subscriptionId: item.id,
          serviceName: item.name,
          amount: item.amount,
          daysUntilDue: days,
          severity: severity,
          reason: _buildReason(days),
        ),
      );
    }

    alerts.sort((left, right) {
      final severityCompare = _severityWeight(left.severity)
          .compareTo(_severityWeight(right.severity));
      if (severityCompare != 0) {
        return severityCompare;
      }
      return left.daysUntilDue.compareTo(right.daysUntilDue);
    });

    return alerts;
  }

  AlertSeverity _resolveSeverity(int daysUntilDue) {
    if (daysUntilDue <= 3) {
      return AlertSeverity.high;
    }
    if (daysUntilDue <= 7) {
      return AlertSeverity.medium;
    }
    return AlertSeverity.low;
  }

  int _severityWeight(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.high:
        return 0;
      case AlertSeverity.medium:
        return 1;
      case AlertSeverity.low:
        return 2;
    }
  }

  String _buildReason(int daysUntilDue) {
    if (daysUntilDue < 0) {
      return '결제일이 지났어요. 즉시 확인이 필요해요.';
    }
    if (daysUntilDue == 0) {
      return '오늘 결제 예정이에요.';
    }
    if (daysUntilDue <= 3) {
      return '결제일이 매우 임박했어요.';
    }
    if (daysUntilDue <= 7) {
      return '이번 주 안에 결제가 예정되어 있어요.';
    }
    return '30일 이내 결제 예정 항목이에요.';
  }
}
