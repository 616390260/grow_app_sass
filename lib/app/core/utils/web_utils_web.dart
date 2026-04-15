import 'package:web/web.dart' as web;

/// Web 端动态更新浏览器 favicon
void updateFavicon(String url) {
  final link = web.document.querySelector('link[rel="icon"]');
  if (link != null) {
    (link as web.HTMLLinkElement).href = url;
  }
}

/// Web 端动态更新浏览器标签标题
void updateDocumentTitle(String title) {
  web.document.title = title;
}
