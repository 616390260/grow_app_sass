import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:do_task_project/app/domain/entities/task.dart';
import 'package:flutter/foundation.dart';
import '../models/task_model.dart';

/// 任务服务类 - 数据访问层
class TaskService extends GetxService {
  late final GetStorage _storage;
  static const String _tasksKey = 'tasks';

  @override
  Future<void> onInit() async {
    super.onInit();
    _storage = GetStorage();
    await _storage.initStorage;
  }

  /// 获取所有任务
  Future<List<Task>> getAllTasks() async {
    try {
      final tasksData = _storage.read<List>(_tasksKey) ?? [];
      return tasksData
          .map((taskData) => TaskModel.fromJson(Map<String, dynamic>.from(taskData)).toEntity())
          .toList();
    } catch (e) {
      debugPrint('获取任务失败: $e');
      return [];
    }
  }

  /// 根据ID获取任务
  Future<Task?> getTaskById(String id) async {
    try {
      final tasks = await getAllTasks();
      return tasks.firstWhereOrNull((task) => task.id == id);
    } catch (e) {
      debugPrint('获取任务失败: $e');
      return null;
    }
  }

  /// 创建任务
  Future<void> createTask(Task task) async {
    try {
      final tasks = await getAllTasks();
      tasks.add(task);
      await _saveTasks(tasks);
    } catch (e) {
      throw Exception('创建任务失败: $e');
    }
  }

  /// 更新任务
  Future<void> updateTask(Task task) async {
    try {
      final tasks = await getAllTasks();
      final index = tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        tasks[index] = task;
        await _saveTasks(tasks);
      } else {
        throw Exception('任务不存在');
      }
    } catch (e) {
      throw Exception('更新任务失败: $e');
    }
  }

  /// 删除任务
  Future<void> deleteTask(String id) async {
    try {
      final tasks = await getAllTasks();
      tasks.removeWhere((task) => task.id == id);
      await _saveTasks(tasks);
    } catch (e) {
      throw Exception('删除任务失败: $e');
    }
  }

  /// 搜索任务
  Future<List<Task>> searchTasks(String query) async {
    try {
      final tasks = await getAllTasks();
      if (query.isEmpty) return tasks;
      
      return tasks.where((task) =>
          task.title.toLowerCase().contains(query.toLowerCase()) ||
          task.description.toLowerCase().contains(query.toLowerCase()) ||
          task.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase()))
      ).toList();
    } catch (e) {
      debugPrint('搜索任务失败: $e');
      return [];
    }
  }

  /// 按状态获取任务
  Future<List<Task>> getTasksByStatus(TaskStatus status) async {
    try {
      final tasks = await getAllTasks();
      return tasks.where((task) => task.status == status).toList();
    } catch (e) {
      debugPrint('获取任务失败: $e');
      return [];
    }
  }

  /// 获取任务统计信息
  Future<Map<String, int>> getTaskStatistics() async {
    try {
      final tasks = await getAllTasks();
      return {
        'total': tasks.length,
        'pending': tasks.where((t) => t.status == TaskStatus.pending).length,
        'inProgress': tasks.where((t) => t.status == TaskStatus.inProgress).length,
        'completed': tasks.where((t) => t.status == TaskStatus.completed).length,
        'cancelled': tasks.where((t) => t.status == TaskStatus.cancelled).length,
        'overdue': tasks.where((t) => t.isOverdue).length,
      };
    } catch (e) {
      debugPrint('获取统计信息失败: $e');
      return {};
    }
  }

  /// 清除所有任务
  Future<void> clearAllTasks() async {
    try {
      await _storage.remove(_tasksKey);
    } catch (e) {
      throw Exception('清除任务失败: $e');
    }
  }

  /// 私有方法：保存任务列表
  Future<void> _saveTasks(List<Task> tasks) async {
    try {
      final tasksData = tasks
          .map((task) => TaskModel.fromEntity(task).toJson())
          .toList();
      await _storage.write(_tasksKey, tasksData);
    } catch (e) {
      throw Exception('保存任务失败: $e');
    }
  }
}
