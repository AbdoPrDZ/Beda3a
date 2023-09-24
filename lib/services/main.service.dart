import 'package:get/get.dart';
import 'package:storage_database/storage_database.dart';

import '../models/models.dart';
import '../utils/utils.dart';

class MainService extends GetxService {
  late StorageDatabase storageDatabase;
  late StorageDatabase dataDatabase;
  bool haveDataSource = false;

  SettingsModel? settings;
  String? dataSourcePassword;
  UserModel? get currentUser => realUser?.isAuth == true ? realUser : null;
  UIThemeMode get themeMode => settings?.themeMode ?? UIThemeMode.light;
  UserModel? realUser;

  Future fastInit() async {
    storageDatabase = await StorageDatabase.getInstance();
    // await storageDatabase.clear();
    await SettingsModel.init();
  }

  Future<PageInfo> init() async {
    if (settings?.dataSourcePath != null && dataSourcePassword != null) {
      await initDataSource();
    } else {
      return PagesInfo.setupDataSource;
    }

    await initModels();

    return currentUser != null
        ? PagesInfo.home
        : realUser != null
            ? PagesInfo.login
            : PagesInfo.setupUser;
  }

  Future initDataSource() async {
    dataDatabase = StorageDatabase(await FileStorageSource.getInstance(
      settings!.dataSourcePath!,
      dataSourcePassword!,
    ));
    dataDatabase.initExplorer(path: '${settings!.dataSourcePath!}/explorer');
    // await dataDatabase.clear();
    haveDataSource = true;
  }

  Future initModels() async {
    await ViewSessions.init();
    await UserModel.init();
    realUser = await UserModel.get();
    await ClientModel.init();
    await DriverModel.init();
    await TruckModel.init();
    await TripModel.init();
    await PayloadModel.init();
    await ExpensesModel.init();
  }

  Future onAuth() {
    realUser!.isAuth = true;
    return realUser!.save();
  }

  Future logout() {
    realUser!.isAuth = false;
    return realUser!.save();
  }
}
