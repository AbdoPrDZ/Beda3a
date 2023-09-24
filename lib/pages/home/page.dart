import 'package:gap/gap.dart';

import '../../src/src.dart';
import '../../utils/utils.dart' as utils;
import '../../views/views.dart';
import 'controller.dart';
import 'tabs/tabs.dart';

class HomePage extends utils.Page<HomeController> {
  HomePage({Key? key}) : super(controller: HomeController(), key: key);

  @override
  HomeController get controller => super.controller!;

  @override
  Widget? buildFloatingActionButton(BuildContext context) =>
      tabs[controller.currentTabIndex].buildFloatingActionButton?.call(context);

  List<DrawerItem> get tabs => [
        DrawerItem(
          'Home',
          Icons.home_outlined,
          buildTab: (context) => HomeTab(homeController: controller),
        ),
        DrawerItem(
          'Drivers',
          Icons.person_4_outlined,
          buildTab: (context) => DriversTab(),
          buildFloatingActionButton: DriversTab.floatingActionButton,
        ),
        DrawerItem(
          'Trucks',
          Icons.directions_bus_outlined,
          buildTab: (context) => TrucksTab(),
          buildFloatingActionButton: TrucksTab.floatingActionButton,
        ),
        DrawerItem(
          'Trips',
          Icons.alt_route_rounded,
          buildTab: (context) => TripsTab(),
          buildFloatingActionButton: (context) =>
              TripsTab.floatingActionButton(controller, context),
        ),
        DrawerItem(
          'Clients',
          Icons.groups_2_outlined,
          buildTab: (context) => ClientsTab(),
          buildFloatingActionButton: ClientsTab.floatingActionButton,
        ),
        DrawerItem(
          'Logout',
          Icons.logout,
          isAction: true,
          onActionTab: controller.logout,
        ),
      ];

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => AppBar(
        backgroundColor: UIThemeColors.primary,
        title: Text(tabs[controller.currentTabIndex].text),
      );

  @override
  Widget? buildDrawer() => CustomDrawerView(
        tabsItems: tabs,
        pageController: controller.pageController,
        themeMode: controller.mainService.themeMode,
        onTabItemSelected: (drawerItem) {
          controller.currentTabIndex = [
            for (var tab in tabs) tab.text,
          ].indexOf(drawerItem.text);
          controller.pageController.animateToPage(
            controller.currentTabIndex,
            duration: const Duration(milliseconds: 200),
            curve: Curves.bounceIn,
          );
          controller.update();
        },
        buildHeader: (context) => Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: CircleAvatar(
                backgroundColor: UIThemeColors.cardBg1,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Image.asset(
                    Consts.logo,
                  ),
                ),
              ),
            ),
            const Gap(5),
            Text(
              controller.mainService.currentUser?.fullName ?? '',
              style: TextStyle(
                color: LightTheme.pageBackground,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            )
          ],
        ),
        buildFooter: (context) => Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              Consts.appName,
              style: TextStyle(
                color: LightTheme.pageBackground,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(5),
            Text(
              '${Consts.appName}\nⒸ Powered By Abdo Pr',
              style: TextStyle(
                color: LightTheme.pageBackground,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        onThemeModeChanged: controller.mainService.settings!.setThemeMode,
      );

  @override
  Widget buildBody(BuildContext context) => PageView(
        controller: controller.pageController,
        children: [
          for (DrawerItem item in tabs)
            if (!item.isAction) item.buildTab!(context),
        ],
        onPageChanged: (index) {
          controller.currentTabIndex = index;
          controller.update();
        },
      );
}
