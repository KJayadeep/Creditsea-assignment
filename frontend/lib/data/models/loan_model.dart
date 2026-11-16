class LoanModel {
  final String id;
  final String applicationNumber;
  final double principalAmount;
  final int tenure;
  final String purpose;
  final double interestRatePerDay;
  final double interestAmount;
  final double processingFee;
  final double totalPayable;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  LoanModel({
    required this.id,
    required this.applicationNumber,
    required this.principalAmount,
    required this.tenure,
    required this.purpose,
    this.interestRatePerDay = 1.0,
    required this.interestAmount,
    required this.processingFee,
    required this.totalPayable,
    this.status = 'Submitted',
    this.createdAt,
    this.updatedAt,
  });

  factory LoanModel.fromJson(Map<String, dynamic> json) {
    return LoanModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      applicationNumber: json['applicationNumber']?.toString() ?? '',
      principalAmount: (json['principalAmount'] as num?)?.toDouble() ?? 0.0,
      tenure: (json['tenure'] as num?)?.toInt() ?? 0,
      purpose: json['purpose']?.toString() ?? '',
      interestRatePerDay: (json['interestRatePerDay'] as num?)?.toDouble() ?? 1.0,
      interestAmount: (json['interestAmount'] as num?)?.toDouble() ?? 0.0,
      processingFee: (json['processingFee'] as num?)?.toDouble() ?? 0.0,
      totalPayable: (json['totalPayable'] as num?)?.toDouble() ?? 0.0,
      status: json['status']?.toString() ?? 'Submitted',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'applicationNumber': applicationNumber,
      'principalAmount': principalAmount,
      'tenure': tenure,
      'purpose': purpose,
      'interestRatePerDay': interestRatePerDay,
      'interestAmount': interestAmount,
      'processingFee': processingFee,
      'totalPayable': totalPayable,
      'status': status,
    };
  }
}
