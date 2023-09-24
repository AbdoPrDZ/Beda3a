import 'package:get/get.dart';

import '../../models/models.dart';
import '../../services/main.service.dart';
import '../../utils/utils.dart';
import '../../views/views.dart';

class HomeController extends GetxController {
  MainService mainService = Get.find();

  PageController pageController = PageController();

  int currentTabIndex = 0;

  List<TruckModel> trucks = [];
  TruckId? selectedTruckId;

  @override
  void onInit() {
    TruckModel.streamMap().listen((items) {
      trucks = items.values.toList();
      if ((selectedTruckId == null || !items.keys.contains(selectedTruckId))) {
        selectedTruckId = items.isNotEmpty ? items.keys.first : null;
      }
      update();
    });
    super.onInit();
  }

  Future logout() async {
    bool logout = await DialogsView.message(
          'Logout',
          'Are sure you want to logout?',
          actions: DialogAction.rYesCancel,
        ).show() ??
        false;
    if (logout) {
      mainService.logout();
      RouteManager.to(PagesInfo.login, clearHeaders: true);
    }
  }
}
