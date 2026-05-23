import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:url_launcher/url_launcher.dart';

/// 富文本渲染组件：基于 flutter_widget_from_html_core 渲染后台配置的 HTML，
/// 行为尽量与 H5 富文本保持一致。
///
/// 相比之前各页面里手写的 `_parseHtmlToTextSpan`：
/// - `<a href>` 超链接渲染为链接样式并可点击跳转（外部浏览器 / 对应 App）；
/// - 支持内联样式（颜色 / 字号 / 加粗 / 下划线等）、段落、列表、图片；
/// - 解析与渲染交给成熟库，不再自己维护一套 HTML 解析逻辑。
class RichHtmlText extends StatelessWidget {
  const RichHtmlText({
    super.key,
    required this.html,
    required this.style,
    this.linkColor,
    this.maxLines,
    this.textAlign = TextAlign.start,
    this.overflow = TextOverflow.clip,
  });

  /// 待渲染的 HTML 字符串。
  final String html;

  /// 基础文本样式（非链接文字继承此样式）。
  final TextStyle style;

  /// 链接颜色，默认链接蓝。
  final Color? linkColor;

  /// 兼容旧调用签名；HtmlWidget 为块级渲染，不做行数截断，此参数不生效。
  final int? maxLines;

  /// 文字对齐，通过包裹 `text-align` 实现。
  final TextAlign textAlign;

  /// 兼容旧调用签名；块级渲染下不生效。
  final TextOverflow overflow;

  static const Color _defaultLinkColor = Color(0xFF2F6BFF);

  Color get _linkColor => linkColor ?? _defaultLinkColor;

  /// 把 [Color] 转成 CSS 十六进制颜色（如 `#2f6bff`），使用 Flutter 3.27+ 的
  /// 0~1 分量 API，避免 `Color.value` 的弃用告警。
  String _toCssColor(Color c) {
    int channel(double v) => (v * 255).round().clamp(0, 255);
    String hex(int v) => v.toRadixString(16).padLeft(2, '0');
    return '#${hex(channel(c.r))}${hex(channel(c.g))}${hex(channel(c.b))}';
  }

  String? get _alignCss {
    switch (textAlign) {
      case TextAlign.center:
        return 'center';
      case TextAlign.right:
      case TextAlign.end:
        return 'right';
      case TextAlign.justify:
        return 'justify';
      default:
        return null;
    }
  }

  Future<bool> _openLink(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    if (await canLaunchUrl(uri)) {
      return launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final align = _alignCss;
    final content =
        align == null ? html : '<div style="text-align: $align">$html</div>';
    return HtmlWidget(
      content,
      textStyle: style,
      onTapUrl: _openLink,
      customStylesBuilder: (element) {
        if (element.localName == 'a') {
          return {'color': _toCssColor(_linkColor)};
        }
        return null;
      },
    );
  }
}
