class CostSnapshot {
  const CostSnapshot({
    required this.monthlyNormalizedTotal,
    required this.annualProjection,
    required this.weeklyDueTotal,
    required this.monthlyDueTotal,
  });

  final double monthlyNormalizedTotal;
  final double annualProjection;
  final double weeklyDueTotal;
  final double monthlyDueTotal;
}
