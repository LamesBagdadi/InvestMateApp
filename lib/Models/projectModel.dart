class Project {
  final String id;
  final String title;
  final String description;
  final double goalAmount;
  final double raisedAmount;
  final String category;
  final String creatorId;
  final DateTime createdAt;
  final int investorsCount;
  final double returnRate;
  final int durationMonths;
  final bool isActive;
  final String? riskLevel; // Made optional with ?
  final int? daysRemaining; // Made optional with ?

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.goalAmount,
    required this.raisedAmount,
    required this.category,
    required this.creatorId,
    required this.createdAt,
    required this.investorsCount,
    required this.returnRate,
    required this.durationMonths,
    required this.isActive,
    this.riskLevel, // Optional
    this.daysRemaining, // Optional
  });

  factory Project.fromFirebase(Map<String, dynamic> data, String id) {
    return Project(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      goalAmount: (data['goalAmount'] ?? 0).toDouble(),
      raisedAmount: (data['raisedAmount'] ?? 0).toDouble(),
      category: data['category'] ?? '',
      creatorId: data['creatorId'] ?? '',
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'])
          : DateTime.now(),
      investorsCount: data['investorsCount'] ?? 0,
      returnRate: (data['returnRate'] ?? 0).toDouble(),
      durationMonths: data['durationMonths'] ?? 0,
      isActive: data['isActive'] ?? true,
      riskLevel: data['riskLevel'] as String?, // Cast as nullable String
      daysRemaining: data['daysRemaining'] as int?, // Cast as nullable int
    );
  }

  // Get risk level with fallback
  String get computedRiskLevel {
    return riskLevel ?? 'Medium';
  }

  // Get days remaining with fallback
  int get computedDaysRemaining {
    return daysRemaining ?? 30;
  }
}