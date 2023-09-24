import 'package:get/get.dart';

import '../middlewares/auth.middleware.dart';
import '../utils/utils.dart';
export '../src/src.dart';

class RouteManager {
  static Future<T?>? to<T, AT>(
    PageInfo page, {
    bool clearHeaders = false,
    AT? arguments,
    int? id,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
  }) =>
      clearHeaders
          ? Get.offAllNamed(
              page.route,
              arguments: arguments,
              id: id,
              parameters: parameters,
            )
          : Get.toNamed(
              page.route,
              arguments: arguments,
              id: id,
              preventDuplicates: preventDuplicates,
              parameters: parameters,
            );

  static List<GetPage> get pages {
    List<GetPage> pages = [];
    for (PageInfo pageInfo in PagesInfo.pages.values) {
      pages.add(
        GetPage(
          name: pageInfo.route,
          page: pageInfo.page,
          middlewares: [AuthMiddleware()],
          title: pageInfo.page().pageHeaders.title,
          participatesInRootNavigator:
              pageInfo.page().pageHeaders.participatesInRootNavigator,
          gestureWidth: pageInfo.page().pageHeaders.gestureWidth,
          maintainState: pageInfo.page().pageHeaders.maintainState,
          curve: pageInfo.page().pageHeaders.curve,
          alignment: pageInfo.page().pageHeaders.alignment,
          parameters: pageInfo.page().pageHeaders.parameters,
          opaque: pageInfo.page().pageHeaders.opaque,
          transitionDuration: pageInfo.page().pageHeaders.transitionDuration,
          popGesture: pageInfo.page().pageHeaders.popGesture,
          binding: pageInfo.page().pageHeaders.binding,
          bindings: pageInfo.page().pageHeaders.bindings,
          transition: pageInfo.page().pageHeaders.transition,
          customTransition: pageInfo.page().pageHeaders.customTransition,
          fullscreenDialog: pageInfo.page().pageHeaders.fullscreenDialog,
          showCupertinoParallax:
              pageInfo.page().pageHeaders.showCupertinoParallax,
          preventDuplicates: pageInfo.page().pageHeaders.preventDuplicates,
        ),
      );
    }
    return pages;
  }
}
