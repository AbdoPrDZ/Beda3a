import 'package:gap/gap.dart';

import '../../../../models/models.dart';
import '../../../../src/src.dart';
import '../../../../utils/utils.dart' as utils;
import '../../../../views/views.dart';
import '../../controller.dart';
import 'controller.dart';

class HomeTab extends utils.Page<HomeTabController> {
  final HomeController homeController;
  HomeTab({Key? key, required this.homeController})
      : super(controller: HomeTabController(), key: key);

  @override
  HomeTabController get controller => super.controller!;

  @override
  Widget buildBody(BuildContext context) => Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Home',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: UIThemeColors.text1,
              fontWeight: FontWeight.bold,
              fontSize: 50,
            ),
          ),
          DropDownView<TruckId?>(
            value: homeController.selectedTruckId,
            items: [
              const DropdownMenuItem(value: null, child: Text('Select Truck')),
              for (TruckModel truck in homeController.trucks)
                DropdownMenuItem(value: truck.id, child: Text(truck.name)),
            ],
            onChanged: (value) {
              homeController.selectedTruckId = value;
              homeController.update();
            },
          ),
          const Gap(20),
          Text(
            'First name: ${controller.mainService.currentUser?.firstName}',
            style: TextStyle(color: UIThemeColors.text2),
          ),
          Text(
            'Last name: ${controller.mainService.currentUser?.lastName}',
            style: TextStyle(color: UIThemeColors.text2),
          ),
          Text(
            'Full name: ${controller.mainService.currentUser?.fullName}',
            style: TextStyle(color: UIThemeColors.text2),
          ),
          Text(
            'Email: ${controller.mainService.currentUser?.email}',
            style: TextStyle(color: UIThemeColors.text2),
          ),
          Text(
            'Password: ${controller.mainService.currentUser?.password}',
            style: TextStyle(color: UIThemeColors.text2),
          ),
        ],
      );
}
