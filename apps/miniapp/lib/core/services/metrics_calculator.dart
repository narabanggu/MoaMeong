import 'package:moameong_miniapp/core/models/cost_snapshot.dart';
import 'package:moameong_miniapp/core/models/subscription_item.dart';

class MetricsCalculator {
  double toMonthlyNormalized(SubscriptionItem item) {
    if (!item.isTrackable) {
      return 0;
    }

    final amount = item.amount;
    switch (item.cycle) {
      case BillingCycle.monthly:
        return amount;
      case BillingCycle.yearly:
        return amount / 12;
      case BillingCycle.weekly:
        return amount * 52 / 12;
      case BillingCycle.customDays:
        final days = item.cycleDays <= 0 ? 30 : item.cycleDays;
        return amount * 30.4375 / days;
    }
  }

  int daysUntilDue(DateTime dueDate, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate.year, dueDate.month, dueDate.day);
    return due.difference(today).inDays;
  }

  CostSnapshot buildSnapshot({
    required List<SubscriptionItem> subscriptions,
    required DateTime now,
  }) {
    var monthlyNormalizedTotal = 0.0;
    var weeklyDueTotal = 0.0;
    var monthlyDueTotal = 0.0;

    for (final item in subscriptions) {
      if (!item.isTrackable) {
        continue;
      }

      monthlyNormalizedTotal += toMonthlyNormalized(item);

      final days = daysUntilDue(item.nextBillingDate, now);
      if (days >= 0 && days <= 7) {
        weeklyDueTotal += item.amount;
      }

      if (days >= 0 && _isSameMonth(item.nextBillingDate, now)) {
        monthlyDueTotal += item.amount;
      }
    }

    final annualProjection = monthlyNormalizedTotal * 12;

    return CostSnapshot(
      monthlyNormalizedTotal: monthlyNormalizedTotal,
      annualProjection: annualProjection,
      weeklyDueTotal: weeklyDueTotal,
      monthlyDueTotal: monthlyDueTotal,
    );
  }

  bool _isSameMonth(DateTime left, DateTime right) {
    return left.year == right.year && left.month == right.month;
  }
}
