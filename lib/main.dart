import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'services/main.service.dart';
import 'utils/route_manager.dart';

Future<void> main() async {
  await Get.put(MainService()).fastInit();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => GetMaterialApp(
        title: Consts.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: Consts.fontFamily,
          primaryColor: UIColors.primary1,
          backgroundColor: UIColors.primary1,
        ),
        getPages: RouteManager.pages,
        initialRoute: PagesInfo.initialPage.route,
      );
}
