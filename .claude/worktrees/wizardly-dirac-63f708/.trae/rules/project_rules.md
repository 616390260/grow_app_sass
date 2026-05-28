所有的新建的view都继承baseview  新建的controller  都继承basecontroller
所有新建的string 都要在lib/app/core/i18n目录下i18n_keys.dart 中定义 并且同步翻译到app_translations.dart中的中文，只需要中文即可
新建的页面都必须配置好路由
新建的页面 都实现沉浸式状态栏效果
每次修改完不要停止正在运行的程序，不要重新启动，可以使用热重载
所有的api调用都要使用safeApiCall方法
要运行预览的时候 执行 flutter run -d PERM00

<!-- 要运行预览的时候 执行 flutter run -d NAB0220416033759  -->
