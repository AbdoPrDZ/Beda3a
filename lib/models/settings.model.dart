import 'package:get/get.dart';
import 'package:storage_database/storage_collection.dart';

import '../services/main.service.dart';
import '../src/src.dart';

class SettingsModel {
  UIThemeMode themeMode;
  String? dataSourcePath;

  SettingsModel(
    this.themeMode,
    this.dataSourcePath,
  );

  static MainService get mainService => Get.find();
  static StorageCollection get collection =>
      mainService.storageDatabase.collection('settings');

  static Future init() async {
    await collection.set({});
    Map cData = await collection.get();
    if (cData.isEmpty) {
      await collection.set({
        'theme': 'Light',
        'data_source_path': null,
      });
    }
    mainService.settings = await get();
  }

  static Future<SettingsModel> get() async => fromMap(await collection.get());

  static SettingsModel fromMap(Map data) => SettingsModel(
        UIThemeMode(data['theme']),
        data['data_source_path'],
      );

  Future setThemeMode(UIThemeMode themeMode) {
    this.themeMode = themeMode;
    Get.forceAppUpdate();
    return save();
  }

  Future save() => collection.set(map);

  Map<String, dynamic> get map => {
        'theme': '$themeMode',
        'data_source_path': dataSourcePath,
      };
}
