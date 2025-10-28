/// 任务优先级枚举
enum TaskPriority {
  low,
  medium,
  high,
  urgent,
}

/// 任务状态枚举
enum TaskStatus {
  pending,
  inProgress,
  completed,
  cancelled,
}

/// 任务实体类
class Task {
  final String id;
  final String title;
  final String description;
  final TaskPriority priority;
  final TaskStatus status;
  final DateTime createdAt;
  final DateTime? dueDate;
  final DateTime? completedAt;
  final List<String> tags;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.createdAt,
    this.dueDate,
    this.completedAt,
    this.tags = const [],
  });

  /// 复制任务并修改指定字段
  Task copyWith({
    String? id,
    String? title,
    String? description,
    TaskPriority? priority,
    TaskStatus? status,
    DateTime? createdAt,
    DateTime? dueDate,
    DateTime? completedAt,
    List<String>? tags,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      completedAt: completedAt ?? this.completedAt,
      tags: tags ?? this.tags,
    );
  }

  /// 标记任务为已完成
  Task markAsCompleted() {
    return copyWith(
      status: TaskStatus.completed,
      completedAt: DateTime.now(),
    );
  }

  /// 标记任务为进行中
  Task markAsInProgress() {
    return copyWith(
      status: TaskStatus.inProgress,
      completedAt: null,
    );
  }

  /// 检查任务是否过期
  bool get isOverdue {
    if (dueDate == null || status == TaskStatus.completed) {
      return false;
    }
    return DateTime.now().isAfter(dueDate!);
  }

  /// 检查任务是否已完成
  bool get isCompleted => status == TaskStatus.completed;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Task && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Task(id: $id, title: $title, status: $status, priority: $priority)';
  }
}