import 'dart:convert';

import 'package:miniapp/core/models/subscription_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageLoadResult {
  const LocalStorageLoadResult({
    required this.subscriptions,
    required this.recoveredFromCorruption,
  });

  final List<SubscriptionItem> subscriptions;
  final bool recoveredFromCorruption;
}

class LocalStorageRepository {
  static const String _stateKey = 'subscription_state_v1';

  Future<LocalStorageLoadResult> loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_stateKey);
    if (raw == null || raw.isEmpty) {
      return const LocalStorageLoadResult(
        subscriptions: <SubscriptionItem>[],
        recoveredFromCorruption: false,
      );
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Unexpected state shape');
      }

      final subscriptions = <SubscriptionItem>[];
      final rawSubscriptions = decoded['subscriptions'];
      if (rawSubscriptions is List) {
        for (final entry in rawSubscriptions) {
          if (entry is Map<String, dynamic>) {
            subscriptions.add(SubscriptionItem.fromJson(entry));
          } else if (entry is Map) {
            subscriptions.add(
              SubscriptionItem.fromJson(entry.cast<String, dynamic>()),
            );
          }
        }
      }

      final sanitizedSubscriptions = _sanitizeSubscriptions(subscriptions);

      return LocalStorageLoadResult(
        subscriptions: sanitizedSubscriptions,
        recoveredFromCorruption: false,
      );
    } catch (_) {
      await prefs.remove(_stateKey);
      return const LocalStorageLoadResult(
        subscriptions: <SubscriptionItem>[],
        recoveredFromCorruption: true,
      );
    }
  }

  Future<void> saveState({
    required List<SubscriptionItem> subscriptions,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final sanitizedSubscriptions = _sanitizeSubscriptions(subscriptions);

    final payload = <String, dynamic>{
      'subscriptions':
          sanitizedSubscriptions.map((item) => item.toJson()).toList(),
    };
    await prefs.setString(_stateKey, jsonEncode(payload));
  }

  List<SubscriptionItem> _sanitizeSubscriptions(
    List<SubscriptionItem> source,
  ) {
    final byId = <String, SubscriptionItem>{};
    for (final item in source) {
      final sanitizedCategory = item.category?.trim();
      final normalized = SubscriptionItem(
        id: item.id.trim(),
        name: item.name.trim(),
        amount: item.amount,
        cycle: item.cycle,
        cycleDays: item.cycle == BillingCycle.customDays
            ? (item.cycleDays <= 0 ? 30 : item.cycleDays)
            : 30,
        nextBillingDate: item.nextBillingDate,
        status: item.status,
        importance: item.importance,
        category: (sanitizedCategory == null || sanitizedCategory.isEmpty)
            ? null
            : sanitizedCategory,
      );
      if (!normalized.isValidInput) {
        continue;
      }
      byId[normalized.id] = normalized;
    }
    final result = byId.values.toList()
      ..sort((left, right) =>
          left.nextBillingDate.compareTo(right.nextBillingDate));
    return result;
  }
}
