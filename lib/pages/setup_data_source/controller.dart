import 'dart:io';

import 'package:get/get.dart';

import '../../services/main.service.dart';
import '../../utils/utils.dart';
import '../../views/views.dart';

class SetupDataSourceController extends GetxController {
  MainService mainService = Get.find();

  final formKey = GlobalKey<FormState>();

  Map<String, String> errors = {};

  final passwordController = TextEditController();
  final confirmController = TextEditController();

  Directory? sourceDir;
  bool sourceExistsAlready = false;

  void checkSourceExistsAlready() {
    if (sourceDir != null) {
      final source = File('${sourceDir!.path}/beda3a.b3');
      sourceExistsAlready =
          source.existsSync() && source.readAsStringSync().isNotEmpty;
    } else {
      sourceExistsAlready = false;
    }

    update();
  }

  @override
  onInit() {
    if (mainService.settings!.dataSourcePath != null) {
      sourceDir = Directory(mainService.settings!.dataSourcePath!);
      checkSourceExistsAlready();
    }
    super.onInit();
  }

  setup() async {
    if (formKey.currentState!.validate()) {
      DialogsView.loading().show();

      mainService.settings!.dataSourcePath = sourceDir!.path;
      mainService.dataSourcePassword = passwordController.text;
      await mainService.settings!.save();

      await mainService.initDataSource();
      await mainService.initModels();

      formKey.currentState!.save();
      Get.back();
      await DialogsView.message(
        'Login',
        'Successfully setup data source',
      ).show();
      RouteManager.to(PagesInfo.login, clearHeaders: true);
    }
  }
}
