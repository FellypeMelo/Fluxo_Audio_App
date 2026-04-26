class Task {
  final String id;
  final String title;
  final String priority;
  final String category;
  final int durationMin;
  final String status;
  final DateTime createdAt;
  final DateTime? completedAt;

  Task({
    required this.id,
    required this.title,
    required this.priority,
    required this.category,
    required this.durationMin,
    required this.status,
    required this.createdAt,
    this.completedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'priority': priority,
      'category': category,
      'duration_min': durationMin,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      priority: json['priority'],
      category: json['category'],
      durationMin: json['duration_min'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at']) : null,
    );
  }
  
  Task copyWith({
    String? status,
    DateTime? completedAt,
  }) {
    return Task(
      id: id,
      title: title,
      priority: priority,
      category: category,
      durationMin: durationMin,
      status: status ?? this.status,
      createdAt: createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
