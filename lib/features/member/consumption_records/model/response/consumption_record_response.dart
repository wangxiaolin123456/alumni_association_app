class ConsumptionRecordResponse {
  const ConsumptionRecordResponse({
    required this.id,
    required this.merchantName,
    required this.offerName,
    required this.date,
    required this.originalAmount,
    required this.paidAmount,
    required this.status,
    required this.accentColor,
  });

  final String id;
  final String merchantName;
  final String offerName;
  final String date;
  final double originalAmount;
  final double paidAmount;
  final String status;
  final int accentColor;
}
