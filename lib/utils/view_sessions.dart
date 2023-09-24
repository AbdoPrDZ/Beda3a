import 'package:get/get.dart';
import 'package:storage_database/storage_document.dart';

import '../services/main.service.dart';

class ViewSessions<T> {
  final String name;
  T? data;

  ViewSessions(this.name, {T? initialData, bool loadData = true}) {
    data = initialData;
    if (loadData) this.loadData(initialData: initialData);
  }

  static Future init() => Get.find<MainService>()
      .storageDatabase
      .collection('view_sessions')
      .set({});

  StorageDocument get document =>
      Get.find<MainService>().storageDatabase.document('view_sessions/$name');

  Future<T?> loadData({T? initialData}) async {
    await document.set({});
    T? dData = (await document.get())['data'];
    data = dData ?? initialData;
    if (dData != data) await saveData();
    return data;
  }

  saveData() => document.set({'data': data});
}
