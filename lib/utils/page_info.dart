import 'page.dart';

class PageInfo {
  final String route;
  final Page Function() page;
  final bool isUnAuth;

  const PageInfo(this.route, this.page, {this.isUnAuth = false});

  @override
  operator ==(Object object) => object is String && object == route;
}
