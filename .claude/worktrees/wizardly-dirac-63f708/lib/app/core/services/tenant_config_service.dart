import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../data/models/tenant_template_model.dart';
import '../../data/services/tenant_api_service.dart';

/// 租户/品牌配置服务（单例）
/// 启动时从本地缓存恢复，并异步拉取最新配置
class TenantConfigService extends GetxService {
  static TenantConfigService get to => Get.find();

  static const String _cacheKey = 'tenant_template_cache';

  final GetStorage _storage = GetStorage();
  final TenantApiService _api = TenantApiService();

  final Rxn<TenantTemplateModel> template = Rxn<TenantTemplateModel>();

  BrandConfig? get brand => template.value?.brand;
  String? get brandLogo => brand?.brandLogo;
  String? get appName => brand?.appName;
  String? get h5Domain => brand?.h5Domain;
  TemplateInfo? loginTemplate() => template.value?.templates['login'];
  TemplateInfo? homeTemplate() => template.value?.templates['home'];

  @override
  void onInit() {
    super.onInit();
    _loadFromCache();
  }

  void _loadFromCache() {
    try {
      final cached = _storage.read(_cacheKey);
      if (cached is Map) {
        template.value =
            TenantTemplateModel.fromJson(Map<String, dynamic>.from(cached));
      }
    } catch (e) {
      debugPrint('TenantConfig 读取缓存失败: $e');
    }
  }

  /// 从接口刷新；失败时保留旧缓存，不抛出
  Future<void> refresh() async {
    try {
      final fresh = await _api.getTemplate();
      template.value = fresh;
      await _storage.write(_cacheKey, fresh.toJson());
    } catch (e) {
      debugPrint('TenantConfig 刷新失败: $e');
    }
  }
}
