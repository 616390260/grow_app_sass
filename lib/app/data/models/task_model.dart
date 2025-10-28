import '../../../domain/entities/task.dart';

/// 任务数据模型类 - 用于数据持久化和序列化
class TaskModel extends Task {
  const TaskModel({
    required super.id,
    required super.title,
    required super.description,
    required super.priority,
    required super.status,
    required super.createdAt,
    super.dueDate,
    super.completedAt,
    super.tags,
  });

  /// 从实体创建模型
  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      priority: task.priority,
      status: task.status,
      createdAt: task.createdAt,
      dueDate: task.dueDate,
      completedAt: task.completedAt,
      tags: task.tags,
    );
  }

  /// 从JSON创建模型
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      priority: TaskPriority.values[json['priority'] as int],
      status: TaskStatus.values[json['status'] as int],
      createdAt: DateTime.parse(json['createdAt'] as String),
      dueDate: json['dueDate'] != null 
          ? DateTime.parse(json['dueDate'] as String) 
          : null,
      completedAt: json['completedAt'] != null 
          ? DateTime.parse(json['completedAt'] as String) 
          : null,
      tags: (json['tags'] as String?)?.split(',') ?? [],
    );
  }

  /// 从Map创建模型（用于数据库）
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      priority: TaskPriority.values[map['priority'] as int],
      status: TaskStatus.values[map['status'] as int],
      createdAt: DateTime.parse(map['created_at'] as String),
      dueDate: map['due_date'] != null 
          ? DateTime.parse(map['due_date'] as String) 
          : null,
      completedAt: map['completed_at'] != null 
          ? DateTime.parse(map['completed_at'] as String) 
          : null,
      tags: (map['tags'] as String?)?.split(',') ?? [],
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority.index,
      'status': status.index,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'tags': tags.join(','),
    };
  }

  /// 转换为Map（用于数据库）
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority.index,
      'status': status.index,
      'created_at': createdAt.toIso8601String(),
      'due_date': dueDate?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'tags': tags.join(','),
    };
  }

  /// 转换为实体
  Task toEntity() {
    return Task(
      id: id,
      title: title,
      description: description,
      priority: priority,
      status: status,
      createdAt: createdAt,
      dueDate: dueDate,
      completedAt: completedAt,
      tags: tags,
    );
  }

  /// 复制并修改
  @override
  TaskModel copyWith({
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
    return TaskModel(
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
}