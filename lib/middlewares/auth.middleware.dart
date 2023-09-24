import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/main.service.dart';
import '../src/src.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (route == PagesInfo.initialPage.route) return null;

    MainService mainService = Get.find();

    if (!mainService.haveDataSource &&
        route != PagesInfo.setupDataSource.route) {
      return RouteSettings(name: PagesInfo.setupDataSource.route);
    } else if (mainService.realUser == null &&
        route != PagesInfo.onUnAuthAndUnHaveUser.route &&
        !PagesInfo.unHaveUserPages.contains(route)) {
      return RouteSettings(name: PagesInfo.onUnAuthAndUnHaveUser.route);
    } else if (mainService.currentUser != null &&
        PagesInfo.unAuthPages.contains(route)) {
      return RouteSettings(name: PagesInfo.onAuthPage.route);
    } else if (mainService.currentUser == null &&
        !PagesInfo.unAuthPages.contains(route)) {
      return RouteSettings(
        name: PagesInfo.onUnAuthAndHaveUser.route,
      );
    }

    return null;
  }
}
