import '../pages/pages.dart';
import '../utils/utils.dart';

class PagesInfo {
  static Map<String, PageInfo> get pages => {
        '/loading': PageInfo("/loading", () => LoadingPage(), isUnAuth: true),
        '/setup_data_source': PageInfo(
          "/setup_data_source",
          () => SetupDataSourcePage(),
          isUnAuth: true,
        ),
        '/login': PageInfo("/login", () => LoginPage(), isUnAuth: true),
        '/setup_user': PageInfo(
          "/setup_user",
          () => SetupUserPage(),
          isUnAuth: true,
        ),
        '/home': PageInfo("/home", () => HomePage()),
        '/create_edit_client': PageInfo(
          "/create_edit_client",
          () => CreateEditClientPage(),
        ),
        '/create_edit_driver': PageInfo(
          "/create_edit_driver",
          () => CreateEditDriverPage(),
        ),
        '/create_edit_truck': PageInfo(
          "/create_edit_truck",
          () => CreateEditTruckPage(),
        ),
        '/create_edit_trip': PageInfo(
          "/create_edit_trip",
          () => CreateEditTripPage(),
        ),
        '/create_edit_order': PageInfo(
          "/create_edit_order",
          () => CreateEditOrderPage(),
        ),
      };

  static List<String> get unAuthPages => [
        for (PageInfo page in pages.values)
          if (page.isUnAuth) page.route,
      ];

  static List<String> get unHaveUserPages => [
        loading.route,
        setupDataSource.route,
        setupUser.route,
      ];

  static PageInfo get loading => pages['/loading']!;
  static PageInfo get setupDataSource => pages['/setup_data_source']!;
  static PageInfo get login => pages['/login']!;
  static PageInfo get setupUser => pages['/setup_user']!;
  static PageInfo get home => pages['/home']!;
  static PageInfo get createEditClient => pages['/create_edit_client']!;
  static PageInfo get createEditDriver => pages['/create_edit_driver']!;
  static PageInfo get createEditTruck => pages['/create_edit_truck']!;
  static PageInfo get createEditTrip => pages['/create_edit_trip']!;
  static PageInfo get createEditOrder => pages['/create_edit_order']!;

  static PageInfo initialPage = loading;
  static PageInfo onAuthPage = home;
  static PageInfo onUnAuthAndHaveUser = login;
  static PageInfo onUnAuthAndUnHaveUser = setupUser;
}
