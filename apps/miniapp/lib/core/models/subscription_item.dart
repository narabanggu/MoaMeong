enum BillingCycle { monthly, yearly, weekly, customDays }

enum SubscriptionStatus { active, paused, review, canceled }

enum Importance { critical, normal, low }

class SubscriptionItem {
  const SubscriptionItem({
    required this.id,
    required this.name,
    required this.amount,
    required this.cycle,
    required this.cycleDays,
    required this.nextBillingDate,
    required this.status,
    required this.importance,
    this.category,
  });

  final String id;
  final String name;
  final double amount;
  final BillingCycle cycle;
  final int cycleDays;
  final DateTime nextBillingDate;
  final SubscriptionStatus status;
  final Importance importance;
  final String? category;

  bool get isTrackable =>
      status == SubscriptionStatus.active ||
      status == SubscriptionStatus.review;

  bool get isValidInput =>
      id.trim().isNotEmpty &&
      name.trim().isNotEmpty &&
      amount.isFinite &&
      amount > 0 &&
      cycleDays > 0;

  SubscriptionItem copyWith({
    String? id,
    String? name,
    double? amount,
    BillingCycle? cycle,
    int? cycleDays,
    DateTime? nextBillingDate,
    SubscriptionStatus? status,
    Importance? importance,
    String? category,
  }) {
    return SubscriptionItem(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      cycle: cycle ?? this.cycle,
      cycleDays: cycleDays ?? this.cycleDays,
      nextBillingDate: nextBillingDate ?? this.nextBillingDate,
      status: status ?? this.status,
      importance: importance ?? this.importance,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'amount': amount,
      'cycle': cycle.name,
      'cycleDays': cycleDays,
      'nextBillingDate': nextBillingDate.toIso8601String(),
      'status': status.name,
      'importance': importance.name,
      'category': category,
    };
  }

  factory SubscriptionItem.fromJson(Map<String, dynamic> json) {
    final id = (json['id'] ?? '').toString().trim();
    final name = (json['name'] ?? '').toString().trim();
    final amount = _toDouble(json['amount']);
    final parsedCycle = _billingCycleByName((json['cycle'] ?? '').toString());
    final parsedCycleDays =
        _sanitizeCycleDays(_toInt(json['cycleDays'], fallback: 30));

    return SubscriptionItem(
      id: id.isEmpty ? 'sub_unknown' : id,
      name: name.isEmpty ? '이름 없음 구독' : name,
      amount: amount.isFinite && amount > 0 ? amount : 0,
      cycle: parsedCycle,
      cycleDays: parsedCycle == BillingCycle.customDays ? parsedCycleDays : 30,
      nextBillingDate: _toDate(
        (json['nextBillingDate'] ?? DateTime.now().toIso8601String())
            .toString(),
      ),
      status: _statusByName((json['status'] ?? '').toString()),
      importance: _importanceByName((json['importance'] ?? '').toString()),
      category: (json['category'] ?? '').toString().trim().isEmpty
          ? null
          : json['category'].toString().trim(),
    );
  }

  static BillingCycle _billingCycleByName(String value) {
    return BillingCycle.values.firstWhere(
      (item) => item.name == value,
      orElse: () => BillingCycle.monthly,
    );
  }

  static SubscriptionStatus _statusByName(String value) {
    return SubscriptionStatus.values.firstWhere(
      (item) => item.name == value,
      orElse: () => SubscriptionStatus.active,
    );
  }

  static Importance _importanceByName(String value) {
    return Importance.values.firstWhere(
      (item) => item.name == value,
      orElse: () => Importance.normal,
    );
  }

  static DateTime _toDate(String raw) {
    return DateTime.tryParse(raw) ?? DateTime.now();
  }

  static double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static int _toInt(dynamic value, {required int fallback}) {
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  static int _sanitizeCycleDays(int value) {
    if (value <= 0) {
      return 30;
    }
    return value > 3650 ? 3650 : value;
  }
}
