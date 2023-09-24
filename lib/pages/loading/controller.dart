import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../services/main.service.dart';
import '../../utils/utils.dart';
import '../../views/views.dart';

class LoadingController extends GetxController {
  MainService mainService = Get.find();

  @override
  void onReady() {
    loading();
    super.onReady();
  }

  void loading() async {
    if ((await Permission.manageExternalStorage.status) ==
        PermissionStatus.denied) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.manageExternalStorage,
      ].request();

      if (statuses[Permission.manageExternalStorage]! ==
          PermissionStatus.denied) {
        await DialogsView.message(
          'Permission Error',
          'The application need storage permission, you need to allow app to manage your files.',
        ).show();
        SystemNavigator.pop();
      }
    }

    RouteManager.to(await mainService.init(), clearHeaders: true);
  }
}
