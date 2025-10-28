import '../../../domain/entities/task.dart';
import '../models/task_model.dart';
import '../../core/services/http_service.dart';
import '../../core/utils/api_result.dart';

/// 任务API服务类
class TaskApiService {
  final HttpService _httpService = HttpService.to;

  /// API端点
  static const String _tasksEndpoint = '/api/tasks';
  static const String _taskStatsEndpoint = '/api/tasks/stats';

  /// 获取所有任务
  Future<ApiResult<List<Task>>> getAllTasks({
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

    final response = await _httpService.get<List<Task>>(
      _tasksEndpoint,
      queryParameters: queryParams,
      fromJson: (data) {
        if (data is List) {
          return data.map((item) => TaskModel.fromJson(item).toEntity()).toList();
        }
        return <Task>[];
      },
    );

    return response;
  }

  /// 根据ID获取任务
  Future<ApiResult<Task>> getTaskById(String taskId) async {
    final response = await _httpService.get<Task>(
      '$_tasksEndpoint/$taskId',
      fromJson: (data) => TaskModel.fromJson(data).toEntity(),
    );

    return response;
  }

  /// 创建新任务
  Future<ApiResult<Task>> createTask(Task task) async {
    final taskModel = TaskModel.fromEntity(task);
    
    final response = await _httpService.post<Task>(
      _tasksEndpoint,
      data: taskModel.toJson(),
      fromJson: (data) => TaskModel.fromJson(data).toEntity(),
    );

    return response;
  }

  /// 更新任务
  Future<ApiResult<Task>> updateTask(String taskId, Task task) async {
    final taskModel = TaskModel.fromEntity(task);
    
    final response = await _httpService.put<Task>(
      '$_tasksEndpoint/$taskId',
      data: taskModel.toJson(),
      fromJson: (data) => TaskModel.fromJson(data).toEntity(),
    );

    return response;
  }

  /// 删除任务
  Future<ApiResult<bool>> deleteTask(String taskId) async {
    final response = await _httpService.delete<bool>(
      '$_tasksEndpoint/$taskId',
      fromJson: (data) => true,
    );

    return response;
  }

  /// 批量删除任务
  Future<ApiResult<bool>> deleteTasks(List<String> taskIds) async {
    final response = await _httpService.post<bool>(
      '$_tasksEndpoint/batch-delete',
      data: {'task_ids': taskIds},
      fromJson: (data) => true,
    );

    return response;
  }

  /// 标记任务为已完成
  Future<ApiResult<Task>> markTaskAsCompleted(String taskId) async {
    final response = await _httpService.put<Task>(
      '$_tasksEndpoint/$taskId/complete',
      fromJson: (data) => TaskModel.fromJson(data).toEntity(),
    );

    return response;
  }

  /// 标记任务为进行中
  Future<ApiResult<Task>> markTaskAsInProgress(String taskId) async {
    final response = await _httpService.put<Task>(
      '$_tasksEndpoint/$taskId/in-progress',
      fromJson: (data) => TaskModel.fromJson(data).toEntity(),
    );

    return response;
  }

  /// 获取任务统计信息
  Future<ApiResult<Map<String, int>>> getTaskStatistics() async {
    final response = await _httpService.get<Map<String, int>>(
      _taskStatsEndpoint,
      fromJson: (data) {
        if (data is Map<String, dynamic>) {
          return data.map((key, value) => MapEntry(key, value as int));
        }
        return <String, int>{};
      },
    );

    return response;
  }

  /// 搜索任务
  Future<ApiResult<List<Task>>> searchTasks(String query, {
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _httpService.get<List<Task>>(
      '$_tasksEndpoint/search',
      queryParameters: {
        'q': query,
        'page': page,
        'limit': limit,
      },
      fromJson: (data) {
        if (data is List) {
          return data.map((item) => TaskModel.fromJson(item).toEntity()).toList();
        }
        return <Task>[];
      },
    );

    return response;
  }

  /// 按状态获取任务
  Future<ApiResult<List<Task>>> getTasksByStatus(TaskStatus status) async {
    final response = await _httpService.get<List<Task>>(
      '$_tasksEndpoint/by-status',
      queryParameters: {'status': status.index},
      fromJson: (data) {
        if (data is List) {
          return data.map((item) => TaskModel.fromJson(item).toEntity()).toList();
        }
        return <Task>[];
      },
    );

    return response;
  }

  /// 按优先级获取任务
  Future<ApiResult<List<Task>>> getTasksByPriority(TaskPriority priority) async {
    final response = await _httpService.get<List<Task>>(
      '$_tasksEndpoint/by-priority',
      queryParameters: {'priority': priority.index},
      fromJson: (data) {
        if (data is List) {
          return data.map((item) => TaskModel.fromJson(item).toEntity()).toList();
        }
        return <Task>[];
      },
    );

    return response;
  }

  /// 获取过期任务
  Future<ApiResult<List<Task>>> getOverdueTasks() async {
    final response = await _httpService.get<List<Task>>(
      '$_tasksEndpoint/overdue',
      fromJson: (data) {
        if (data is List) {
          return data.map((item) => TaskModel.fromJson(item).toEntity()).toList();
        }
        return <Task>[];
      },
    );

    return response;
  }

  /// 获取今日任务
  Future<ApiResult<List<Task>>> getTodayTasks() async {
    final response = await _httpService.get<List<Task>>(
      '$_tasksEndpoint/today',
      fromJson: (data) {
        if (data is List) {
          return data.map((item) => TaskModel.fromJson(item).toEntity()).toList();
        }
        return <Task>[];
      },
    );

    return response;
  }

  /// 同步任务到服务器
  Future<ApiResult<bool>> syncTasks(List<Task> tasks) async {
    final tasksData = tasks.map((task) => TaskModel.fromEntity(task).toJson()).toList();
    
    final response = await _httpService.post<bool>(
      '$_tasksEndpoint/sync',
      data: {'tasks': tasksData},
      fromJson: (data) => true,
    );

    return response;
  }
}