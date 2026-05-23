import 'package:do_task_project/app/core/widgets/rich_html_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:html/dom.dart' as dom;

Future<HtmlWidget> _pump(
  WidgetTester tester,
  String html, {
  Color? linkColor,
  TextAlign textAlign = TextAlign.start,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: RichHtmlText(
          html: html,
          style: const TextStyle(fontSize: 12, color: Colors.black),
          linkColor: linkColor,
          textAlign: textAlign,
        ),
      ),
    ),
  );
  return tester.widget<HtmlWidget>(find.byType(HtmlWidget));
}

void main() {
  testWidgets('渲染为 HtmlWidget 并透传 html 与点击处理', (tester) async {
    final w = await _pump(tester, '<a href="https://t.me/group">群组链接</a>');
    expect(w.onTapUrl, isNotNull, reason: '链接必须有点击处理才能跳转');
    expect(w.html, contains('群组链接'));
  });

  testWidgets('<a> 应用链接颜色，其他元素不干预', (tester) async {
    final w = await _pump(tester, '<a href="x">x</a>');
    final aStyle = w.customStylesBuilder!(dom.Element.tag('a'));
    expect(aStyle?['color'], '#2f6bff');
    expect(w.customStylesBuilder!(dom.Element.tag('p')), isNull);
  });

  testWidgets('自定义 linkColor 生效', (tester) async {
    final w = await _pump(
      tester,
      '<a href="x">x</a>',
      linkColor: const Color(0xFF059669),
    );
    final aStyle = w.customStylesBuilder!(dom.Element.tag('a'));
    expect(aStyle?['color'], '#059669');
  });

  testWidgets('基础 textStyle 透传给 HtmlWidget', (tester) async {
    final w = await _pump(tester, '<p>公告内容</p>');
    expect(w.textStyle?.fontSize, 12);
    expect(w.textStyle?.color, Colors.black);
  });

  testWidgets('textAlign.center 包裹 text-align', (tester) async {
    final w = await _pump(tester, '标题', textAlign: TextAlign.center);
    expect(w.html, contains('text-align: center'));
    expect(w.html, contains('标题'));
  });

  testWidgets('textAlign.start 不额外包裹', (tester) async {
    final w = await _pump(tester, '内容', textAlign: TextAlign.start);
    expect(w.html, '内容');
  });
}
