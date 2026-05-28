import 'package:do_task_project/app/domain/entities/task.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task_model.g.dart';

/// 任务数据模型类 - 用于数据持久化和序列化
@JsonSerializable()
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
    return _$TaskModelFromJson(json);
  }

  /// 从Map创建模型（用于数据库）
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    // 由于数据库存储的时间格式与JSON不同，需要单独处理
    final parsedMap = {
      'id': map['id'] as String,
      'title': map['title'] as String,
      'description': map['description'] as String,
      'priority': map['priority'] as int,
      'status': map['status'] as int,
      'createdAt': DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int).toIso8601String(),
      'dueDate': map['dueDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['dueDate'] as int).toIso8601String() : null,
      'completedAt': map['completedAt'] != null ? DateTime.fromMillisecondsSinceEpoch(map['completedAt'] as int).toIso8601String() : null,
      'tags': map['tags'] as String,
    };
    return _$TaskModelFromJson(parsedMap);
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() => _$TaskModelToJson(this);

  /// 转换为Map（用于数据库）
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority.index,
      'status': status.index,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'dueDate': dueDate?.millisecondsSinceEpoch,
      'completedAt': completedAt?.millisecondsSinceEpoch,
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