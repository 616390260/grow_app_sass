import 'package:flutter/foundation.dart';
import 'package:timezone/timezone.dart' as tz;

/// 计算「距下一日 0:00」剩余时间，以及转换当前时间到目标时区
///
/// 支持两种时区格式：
///   1. IANA 标准名，如 `Asia/Tokyo`、`Etc/UTC`
///   2. UTC 偏移量字符串，如 `UTC+4`、`UTC-5`、`UTC+5:30`
class MidnightCountdownUtil {
  MidnightCountdownUtil._();

  // ── 内部工具：把当前 UTC 时刻按偏移量还原为"目标时区本地时间" ──────────────

  /// 解析 `UTC±HH` 或 `UTC±HH:MM` → `Duration` 偏移量；失败返回 null
  static Duration? _parseUtcOffset(String raw) {
    // 匹配 UTC+4 / UTC-05 / UTC+5:30 / UTC-05:30
    final re = RegExp(r'^UTC([+-])(\d{1,2})(?::(\d{2}))?$', caseSensitive: false);
    final m = re.firstMatch(raw.trim());
    if (m == null) return null;
    final sign = m.group(1) == '+' ? 1 : -1;
    final hours = int.parse(m.group(2)!);
    final minutes = int.tryParse(m.group(3) ?? '0') ?? 0;
    return Duration(hours: hours * sign, minutes: minutes * sign);
  }

  /// 将 UTC 当前时刻偏移到目标时区的本地 DateTime（未附带时区信息）
  static DateTime _nowInOffset(Duration offset) {
    return DateTime.now().toUtc().add(offset);
  }

  // ── 公开 API ──────────────────────────────────────────────────────────────

  /// 距「目标时区」下一日 0 点的剩余时间；格式为空则回退到本机时间
  static Duration untilMidnight(String? tzStr) {
    if (tzStr != null && tzStr.isNotEmpty) {
      // 1. 先尝试 UTC±X 偏移格式（如 UTC+4、UTC-5:30）
      final offset = _parseUtcOffset(tzStr);
      if (offset != null) {
        // 把当前 UTC 时刻加上偏移 → 目标时区的"本地时间"（保持 isUtc=true）
        final nowLocal = _nowInOffset(offset);
        // 用 DateTime.utc 保持坐标系一致，避免与本机时区混淆
        final todayMidnightUtc =
            DateTime.utc(nowLocal.year, nowLocal.month, nowLocal.day);
        final nextMidnightUtc =
            todayMidnightUtc.add(const Duration(days: 1));
        final diff = nextMidnightUtc.difference(nowLocal);
        debugPrint(
          '[Countdown] offset=$offset  nowLocal=$nowLocal  '
          'nextMidnight=$nextMidnightUtc  diff=$diff',
        );
        return diff.isNegative ? Duration.zero : diff;
      }
      // 2. 再尝试 IANA 名（如 Asia/Tokyo、Etc/UTC）
      try {
        final loc = tz.getLocation(tzStr);
        final now = tz.TZDateTime.now(loc);
        final nextMidnight =
            tz.TZDateTime(loc, now.year, now.month, now.day)
                .add(const Duration(days: 1));
        final diff = nextMidnight.difference(now);
        debugPrint('[Countdown] IANA tz=$tzStr  now=$now  diff=$diff');
        return diff.isNegative ? Duration.zero : diff;
      } catch (e) {
        debugPrint('[Countdown] getLocation failed for "$tzStr": $e');
      }
    }
    // 3. 回退：本机本地时间
    final now = DateTime.now();
    final nextMidnight =
        DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
    final diff = nextMidnight.difference(now);
    return diff.isNegative ? Duration.zero : diff;
  }

  /// 把当前时刻转换成目标时区的本地时间，返回 `YYYY-MM-DD HH:mm:ss`
  static String currentTimeInZone(String? tzStr) {
    DateTime dt;
    if (tzStr != null && tzStr.isNotEmpty) {
      final offset = _parseUtcOffset(tzStr);
      if (offset != null) {
        dt = _nowInOffset(offset);
      } else {
        try {
          dt = tz.TZDateTime.now(tz.getLocation(tzStr));
        } catch (_) {
          dt = DateTime.now();
        }
      }
    } else {
      dt = DateTime.now();
    }
    return '${dt.year.toString().padLeft(4, '0')}-'
        '${dt.month.toString().padLeft(2, '0')}-'
        '${dt.day.toString().padLeft(2, '0')} '
        '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}:'
        '${dt.second.toString().padLeft(2, '0')}';
  }

  static String formatHms(Duration d) {
    if (d.inSeconds <= 0) return '00:00:00';
    final h = d.inHours;
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;
    return '${h.toString().padLeft(2, '0')}:'
        '${m.toString().padLeft(2, '0')}:'
        '${s.toString().padLeft(2, '0')}';
  }
}
