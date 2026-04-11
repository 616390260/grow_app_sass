import 'package:do_task_project/app/domain/entities/task.dart';
import '../models/task_model.dart';
import '../../core/services/http_service.dart';

/// 任务API服务类
class TaskApiService {
  final HttpService _httpService = HttpService.to;

  /// API端点
  static const String _tasksEndpoint = '/api/tasks';
  static const String _taskStatsEndpoint = '/api/tasks/stats';

  /// 获取所有任务
  Future<List<Task>> getAllTasks({
    int page = 1,
    int limit = 20,
    String? status,
    String? priority,
    String? search,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
      if (status != null) 'status': status,
      if (priority != null) 'priority': priority,
      if (search != null && search.isNotEmpty) 'search': search,
    };

    final data = await _httpService.get<List<dynamic>>(
      _tasksEndpoint,
      queryParameters: queryParams,
    );

    return data.map((item) => TaskModel.fromJson(item).toEntity()).toList();
  }

  /// 根据ID获取任务
  Future<Task> getTaskById(String taskId) async {
    final data = await _httpService.get<Map<String, dynamic>>(
      '$_tasksEndpoint/$taskId',
    );

    return TaskModel.fromJson(data).toEntity();
  }

  /// 创建新任务
  Future<Task> createTask(Task task) async {
    final taskModel = TaskModel.fromEntity(task);

    final data = await _httpService.postData<Map<String, dynamic>>(
      _tasksEndpoint,
      data: taskModel.toJson(),
    );

    return TaskModel.fromJson(data).toEntity();
  }

  /// 更新任务
  Future<Task> updateTask(String taskId, Task task) async {
    final taskModel = TaskModel.fromEntity(task);

    final data = await _httpService.putData<Map<String, dynamic>>(
      '$_tasksEndpoint/$taskId',
      data: taskModel.toJson(),
    );

    return TaskModel.fromJson(data).toEntity();
  }

  /// 删除任务
  Future<bool> deleteTask(String taskId) async {
    await _httpService.deleteData<dynamic>(
      '$_tasksEndpoint/$taskId',
    );
    return true;
  }

  /// 批量删除任务
  Future<bool> deleteTasks(List<String> taskIds) async {
    await _httpService.postData<dynamic>(
      '$_tasksEndpoint/batch-delete',
      data: {'task_ids': taskIds},
    );
    return true;
  }

  /// 标记任务为已完成
  Future<Task> markTaskAsCompleted(String taskId) async {
    final data = await _httpService.putData<Map<String, dynamic>>(
      '$_tasksEndpoint/$taskId/complete',
    );

    return TaskModel.fromJson(data).toEntity();
  }

  /// 标记任务为进行中
  Future<Task> markTaskAsInProgress(String taskId) async {
    final data = await _httpService.putData<Map<String, dynamic>>(
      '$_tasksEndpoint/$taskId/in-progress',
    );

    return TaskModel.fromJson(data).toEntity();
  }

  /// 获取任务统计信息
  Future<Map<String, int>> getTaskStatistics() async {
    final data = await _httpService.get<Map<String, dynamic>>(
      _taskStatsEndpoint,
    );

    return data.map((key, value) => MapEntry(key, value as int));
  }

  /// 搜索任务
  Future<List<Task>> searchTasks(
    String query, {
    int page = 1,
    int limit = 20,
  }) async {
    final data = await _httpService.get<List<dynamic>>(
      '$_tasksEndpoint/search',
      queryParameters: {
        'q': query,
        'page': page,
        'limit': limit,
      },
    );

    return data.map((item) => TaskModel.fromJson(item).toEntity()).toList();
  }

  /// 按状态获取任务
  Future<List<Task>> getTasksByStatus(TaskStatus status) async {
    final data = await _httpService.get<List<dynamic>>(
      '$_tasksEndpoint/by-status',
      queryParameters: {'status': status.index},
    );

    return data.map((item) => TaskModel.fromJson(item).toEntity()).toList();
  }

  /// 按优先级获取任务
  Future<List<Task>> getTasksByPriority(TaskPriority priority) async {
    final data = await _httpService.get<List<dynamic>>(
      '$_tasksEndpoint/by-priority',
      queryParameters: {'priority': priority.index},
    );

    return data.map((item) => TaskModel.fromJson(item).toEntity()).toList();
  }

  /// 获取过期任务
  Future<List<Task>> getOverdueTasks() async {
    final data = await _httpService.get<List<dynamic>>(
      '$_tasksEndpoint/overdue',
    );

    return data.map((item) => TaskModel.fromJson(item).toEntity()).toList();
  }

  /// 获取今日任务
  Future<List<Task>> getTodayTasks() async {
    final data = await _httpService.get<List<dynamic>>(
      '$_tasksEndpoint/today',
    );

    return data.map((item) => TaskModel.fromJson(item).toEntity()).toList();
  }

  /// 同步任务到服务器
  Future<bool> syncTasks(List<Task> tasks) async {
    final tasksData =
        tasks.map((task) => TaskModel.fromEntity(task).toJson()).toList();

    await _httpService.postData<dynamic>(
      '$_tasksEndpoint/sync',
      data: {'tasks': tasksData},
    );

    return true;
  }
}
