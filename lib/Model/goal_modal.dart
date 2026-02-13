class GoalModel {
  final String id;
  final String title;
  final double targetAmount;
  final double currentAmount;
  final int? deadline;
  final int priority;
  final int createdAt;

  const GoalModel({
    required this.id,
    required this.title,
    required this.targetAmount,
    required this.currentAmount,
    this.deadline,
    required this.priority,
    required this.createdAt,
  });

  double get progress => targetAmount == 0 ? 0 : currentAmount / targetAmount;

  bool get isCompleted => currentAmount >= targetAmount;

  DateTime? get deadlineDate =>
      deadline != null ? DateTime.fromMillisecondsSinceEpoch(deadline!) : null;

  GoalModel copyWith({
    String? title,
    double? targetAmount,
    double? currentAmount,
    int? deadline,
    int? priority,
  }) {
    return GoalModel(
      id: id,
      title: title ?? this.title,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      deadline: deadline ?? this.deadline,
      priority: priority ?? this.priority,
      createdAt: createdAt,
    );
  }

  factory GoalModel.fromMap(Map<String, Object?> map) {
    return GoalModel(
      id: map['id'] as String,
      title: map['title'] as String,
      targetAmount: (map['target_amount'] as num).toDouble(),
      currentAmount: (map['total_contributed'] as num).toDouble(),
      deadline: map['deadline'] as int?,
      priority: map['priority'] as int,
      createdAt: map['created_at'] as int,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'target_amount': targetAmount,
      'deadline': deadline,
      'priority': priority,
      'created_at': createdAt,
    };
  }
}
