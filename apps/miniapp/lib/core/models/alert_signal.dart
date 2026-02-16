enum AlertSeverity { high, medium, low }

class AlertSignal {
  const AlertSignal({
    required this.subscriptionId,
    required this.serviceName,
    required this.amount,
    required this.daysUntilDue,
    required this.severity,
    required this.reason,
  });

  final String subscriptionId;
  final String serviceName;
  final double amount;
  final int daysUntilDue;
  final AlertSeverity severity;
  final String reason;
}
